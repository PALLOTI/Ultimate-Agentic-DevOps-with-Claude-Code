# Remote state backend (S3)
#
# Bootstrap instructions:
#   1. On the FIRST run, leave this block commented out and run `terraform init`
#      with local state. Then `terraform apply` to create the infrastructure.
#      Create an S3 bucket to hold remote state (manually, or with a separate
#      bootstrap config).
#   2. Once a state bucket exists, uncomment the block below and fill in the
#      bucket name / key / region.
#   3. Run `terraform init -migrate-state` to move your local state into S3.
#
# terraform {
#   backend "s3" {
#     bucket       = "portfolio-site-tfstate"          # your state bucket name
#     key          = "portfolio-site/terraform.tfstate"
#     region       = "ap-south-1"
#     encrypt      = true
#     use_lockfile = true                              # S3-native state locking
#   }
# }
