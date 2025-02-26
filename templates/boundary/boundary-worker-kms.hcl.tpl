# Recovery KMS block: configures the recovery key for Boundary
# Use a production KMS such as AWS KMS for production installs
kms "aead"{
  purpose = "worker-auth"
  aead_type = "aes-gcm"
  key = "${worker_kms}"
  key_id = "global_worker-auth"
}