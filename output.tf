output "bucket_name" {
	value = aws_s3_bucket.s3_res.id
}

output "website_endpoint" {
	value = aws_s3_bucket_website_configuration.website_res.website_endpoint 
}
