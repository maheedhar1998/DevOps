provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "/home/maheedharm/.aws/credentials"
  profile = "default"
}
module "Dev" {
    source = "./modules/environments/"
}
# module "Prod" {
#     source = "./modules"
# }
# module "QA" {
#     source = "./modules"
# }