# # S3 Bucket
# resource "aws_s3_bucket" "example" {
#   bucket = "cloudfront-content-9876"

#   tags = {
#     Name        = "cdn-demo"
#     Environment = "test"
#   }
# }

resource "null_resource" "generate_keys" {
  provisioner "local-exec" {
    command = "python ${path.module}/code/key_generation.py"
  }
}

resource "null_resource" "remove_keys" {
  provisioner "local-exec" {
    command = "rm -rf *key.pem"
    when    = destroy
  }
}

resource "aws_cloudfront_public_key" "cf_public_key" {
  comment     = "cf public key"
  encoded_key = file("${path.module}/public_key.pem")
  name        = "cf-public-key"

  depends_on = [null_resource.generate_keys]

}




