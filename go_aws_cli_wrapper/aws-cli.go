package main

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"fmt"
)

func listS3Buckets(sess *session.Session) string {
	svc := s3.New(sess)
	input := &s3.ListBucketsInput{}
	result, err := svc.ListBuckets(input)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println(result)
	}
	return result.GoString()
}

func createS3Bucket(sess *session.Session, name string, cannedACL string, region string) bool {
	success := false
	cannedACL = *aws.String(cannedACL)
	svc := s3.New(sess)
	input := &s3.CreateBucketInput{}
	input.SetBucket(*aws.String(name))
	if cannedACL == "private" || cannedACL == "public-read" ||
		cannedACL == "public-read-write" || cannedACL == "aws-exec-read" ||
		cannedACL == "authenticated-read" || cannedACL == "bucket-owner-read" ||
		cannedACL == "bucket-owner-full-control" || cannedACL == "log-delivery-write" {
		
		input.SetACL(cannedACL)
	} else {
		input.SetACL("private")
	}
	if region != "us-east-1" {
		bucket_config := &s3.CreateBucketConfiguration{
			LocationConstraint: aws.String(region),
		}
		input.SetCreateBucketConfiguration(bucket_config)
	} else {
		// input.SetCreateBucketConfiguration(&s3.CreateBucketConfiguration{})
	}
	if a := input.Validate(); a != nil {
		fmt.Println(a)
	} else {
		result, err := svc.CreateBucket(input)
		if err != nil {
			fmt.Println(err)
		} else {
			fmt.Println(result)
			success = true
		}
	}
	return success
}

func copyObject(sess *session.Session, name string, cannedACL string, file string) string {
	res := ""
	svc := s3.New(sess)
	input := &s3.CopyObjectInput{}
	input.SetBucket(*aws.String(name))
	if cannedACL == "private" || cannedACL == "public-read" ||
		cannedACL == "public-read-write" || cannedACL == "aws-exec-read" ||
		cannedACL == "authenticated-read" || cannedACL == "bucket-owner-read" ||
		cannedACL == "bucket-owner-full-control" || cannedACL == "log-delivery-write" {
		
		input.SetACL(cannedACL)
	} else {
		input.SetACL("private")
	}
	input.SetCopySource(file)
	input.SetKey(file)
	if a := input.Validate(); a != nil {
		fmt.Println(a)
	} else {
		result, err := svc.CopyObject(input)
		if err != nil {
			fmt.Println(err)
		} else {
			fmt.Println(result)
			res = result.GoString()
		}
	}
	return res
}

func main() {
	sess := session.Must(session.NewSession(&aws.Config{
		Region: aws.String("us-east-1"),
	}))
	listS3Buckets(sess)
	createS3Bucket(sess, "go-lang-test-bucket_1", "public-read", "us-east-1")
	// copyObject(sess, "go-lang-test-bucket1", "public read", "x.txt")
}