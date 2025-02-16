resource "aws_s3_bucket" "my_bucket_V1" {
    bucket = "kamesh-tf-s3-bucket"

    tags = {
        Name = "kamesh-tf-s3-bucket"
    }
}
