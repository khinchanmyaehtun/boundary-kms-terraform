# Recovery KMS block: configures the recovery key for Boundary
# Use a production KMS such as AWS KMS for production installs
kms "aead"{
  purpose = "bsr"
  aead_type = "aes-gcm"
  key = "${bsr_kms}"
  key_id = "session_recording"
}