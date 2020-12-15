output "availability_zones" {
  value = data.aws_availability_zones.az.zone_ids
}