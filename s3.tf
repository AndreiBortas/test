resource "aws_s3_bucket" "s3-media" {
  bucket = "media-andreib-${random_id.unique_key_code.hex}"

}
resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.s3-media.bucket

  index_document {
    suffix = "index.html"
  }

}

resource "random_id" "unique_key_code" {
  byte_length = 3
}

