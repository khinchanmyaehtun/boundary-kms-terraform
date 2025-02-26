resource "random_id" "root_kms" {
  byte_length = 32
}

resource "random_id" "recovery_kms" {
  byte_length = 32
}

resource "random_id" "worker_auth_kms" {
  byte_length = 32
}

resource "random_id" "bsr_kms" {
  byte_length = 32
}

# This file is needed for initial login to Boundary
# https://developer.hashicorp.com/boundary/docs/install-boundary/initialize#log-in-with-recovery-kms
resource "local_file" "recovery_kms_file" {
  content = templatefile("${path.root}/templates/boundary/boundary-recovery-kms.hcl.tpl", {
    recovery_kms = random_id.recovery_kms.b64_std
  })
  filename = "./tmp/boundary-recovery-kms.hcl"
}

resource "local_file" "root_kms_file" {
  content = templatefile("${path.root}/templates/boundary/boundary-root-kms.hcl.tpl", {
    root_kms = random_id.root_kms.b64_std
  })
  filename = "./tmp/boundary-root-kms.hcl"
}

resource "local_file" "worker_kms_file" {
  content = templatefile("${path.root}/templates/boundary/boundary-worker-kms.hcl.tpl", {
    worker_kms = random_id.worker_auth_kms.b64_std
  })
  filename = "./tmp/boundary-worker-kms.hcl"
}

resource "local_file" "bsr_kms_file" {
  content = templatefile("${path.root}/templates/boundary/boundary-bsr-kms.hcl.tpl", {
    bsr_kms = random_id.bsr_kms.b64_std
  })
  filename = "./tmp/boundary-bsr-kms.hcl"
}
