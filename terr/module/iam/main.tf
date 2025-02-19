resource "aws_iam_user" "this" {
  name = var.user_name
}

resource "aws_iam_user_policy_attachment" "this" {
  count      = length(var.policy_arns)
  user       = aws_iam_user.this.name
  policy_arn = var.policy_arns[count.index]
}
