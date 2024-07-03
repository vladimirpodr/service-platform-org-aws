### Outputs
output "lb_access_bucket_id" {
  value = module.lb_access_bucket.bucket_id
}

output "project_logs_bucket_id" {
  value = module.project_logs_bucket.bucket_id
}

output "s3_access_bucket_id" {
  value = module.s3_access_bucket.bucket_id
}
