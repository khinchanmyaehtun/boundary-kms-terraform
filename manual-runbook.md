## Boundary KMS Setup Notes

These notes provide an overview of setting up and managing KMS keys for HashiCorp Boundary using Terraform. It also explains the background process after applying the Terraform code.

### 1. Key Generation

Terraform generates four random 32-byte keys, each serving a specific purpose:

```hcl
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
```

### 2. Key Configuration Files

Terraform uses the `local_file` resource to populate `.hcl` configuration files with the generated keys.

Example for Recovery Key:

```hcl
resource "local_file" "recovery_kms_file" {
  content = templatefile("${path.root}/templates/boundary/boundary-recovery-kms.hcl.tpl", {
    recovery_kms = random_id.recovery_kms.b64_std
  })
  filename = "./tmp/boundary-recovery-kms.hcl"
}
```

The same logic applies to other keys.

### 3. Background Process After Applying Terraform Code

#### Step 1: Key Generation
- Terraform generates four random 32-byte keys using the `random_id` resource.
- Each key is Base64-encoded and stored in Terraform state.

#### Step 2: Template Population
- Terraform reads the `.tpl` template files from the `templates/boundary/` directory.
- The `templatefile` function injects the Base64-encoded keys into the respective placeholders.

#### Step 3: File Creation
- Terraform creates four `.hcl` files in the `./tmp/` directory:
  - `boundary-recovery-kms.hcl`
  - `boundary-root-kms.hcl`
  - `boundary-worker-kms.hcl`
  - `boundary-bsr-kms.hcl`

### 4. Workflow

1. **Generate Keys:** Terraform creates the keys using the `random_id` resource.
2. **Template Injection:** Keys are inserted into `.hcl.tpl` template files.
3. **File Output:** Configured files are saved in the `./tmp/` directory.
4. **Boundary Initialization:** The generated files are used during Boundary initialization to configure KMS.

### 5. Security Considerations

- **Access Control:** Restrict access to the `./tmp/` directory to prevent unauthorized key exposure.
- **KMS in Production:** Consider using AWS KMS, GCP KMS, or another managed key service for enhanced security.
- **Key Rotation:** Implement regular key rotation.
- **State File Security:** Store `terraform.tfstate` securely in a remote backend like AWS S3 or Terraform Cloud.

### 6. Troubleshooting

**Issue: Terraform fails to apply changes.**
- Ensure the `./tmp/` directory exists and is writable.
- Verify that the template files (`*.tpl`) are correctly formatted and located in `templates/boundary/`.

**Issue: Keys are not generated.**
- Ensure the `random_id` resources are correctly defined in the Terraform configuration.

### 7. Key Rotation Process

1. Update the `random_id` resources in Terraform to generate new keys.
2. Run `terraform apply` to regenerate keys and configuration files.
3. Update Boundary’s configuration with the new `.hcl` files.
4. Restart Boundary services to apply the new keys.

### Summary

This setup automates the creation and management of KMS keys for Boundary. Proper key management ensures secure access, recovery, and session handling in your Boundary environment. The background process includes key generation, template population, file creation, and Boundary initialization.

