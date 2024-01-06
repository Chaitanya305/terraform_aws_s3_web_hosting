terraform {
	required_providers{
		aws = {
			source = "hashicorp/aws"
			version = "5.31.0"
		}
	}
}
provider "aws" {
	region = "us-east-1"
}

resource "aws_s3_bucket" "s3_res" {
	bucket = "chaitnay-demo-static-bucket"
}

resource "aws_s3_bucket_website_configuration" "website_res" {
	bucket = aws_s3_bucket.s3_res.id
	index_document {
		suffix = "index.html"
	}
}

resource "aws_s3_bucket_versioning" "vers_res" {
	bucket = aws_s3_bucket.s3_res.id
	versioning_configuration {
	status = "Enabled"
	}
}

resource "aws_s3_bucket_public_access_block" "pub_acces_res" {
	bucket = aws_s3_bucket.s3_res.id
	block_public_acls = false         # Block public access to buckets and objects granted through new access control lists
	block_public_policy = false       # Block public access to buckets and objects granted through any access control lists (ACLs)
	ignore_public_acls = false        # Block public access to buckets and objects granted through new public bucket or access point policies
	restrict_public_buckets = false    # Block public and cross-account access to buckets and objects through any public bucket or access point policies
}

data "aws_iam_policy_document" "allow_other_to_acces_s3_objects" {
	statement {
	principals {
		type = "AWS"
		identifiers = ["*"] 
	}
	actions = ["s3:GetObject"]
	resources = ["${aws_s3_bucket.s3_res.arn}/*"]
	}
}

resource "aws_s3_bucket_policy" "bucket_policy_res" {
	bucket = aws_s3_bucket.s3_res.id
	policy = data.aws_iam_policy_document.allow_other_to_acces_s3_objects.json
}

