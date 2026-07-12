---
name: reference-backend-bootstrap-pattern
description: backend.tf in this repo intentionally comments out the S3 remote backend for first-run bootstrap - do not flag as an accidental omission without checking the comments
metadata:
  type: reference
---

`terraform/backend.tf` documents a deliberate bootstrap flow in its own comments:
first `terraform init`/`apply` locally to create the state bucket, then uncomment
the `backend "s3" {}` block and run `terraform init -migrate-state`. So finding
the backend block commented out is expected at early project stages, not a bug —
still worth flagging as a finding (local state has no encryption/locking) but
frame it as "currently in bootstrap phase" rather than "misconfigured," and check
git history / ask the user whether the state bucket has been created yet before
assuming this is stale.
