data "aws_iam_policy_document" "aws_hosted_react_cloudfront_policy_doc" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.app_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "aws_hosted_react_cloudfront_policy" {
  bucket = aws_s3_bucket.app_bucket.id
  policy = data.aws_iam_policy_document.aws_hosted_react_cloudfront_policy_doc.json

  tags = {
    Project = "aws-hosted-react"
  }
}