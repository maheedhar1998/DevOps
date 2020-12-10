module "Dev" {
    source = "./environments/Dev"
}
module "Prod" {
    source = "./environments/Prod"
}
module "QA" {
    source = "./environments/QA"
}