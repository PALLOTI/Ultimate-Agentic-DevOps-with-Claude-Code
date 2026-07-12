---
name: project-portfolio-site-terraform
description: Baseline security gaps repeatedly found in this repo's terraform/ (S3+CloudFront static site) - use as checklist starting point on re-audits
metadata:
  type: project
---

This repo (`Ultimate-Agentic-DevOps-with-Claude-Code`) provisions a static HTML/CSS
portfolio site via S3 + CloudFront (OAC, not OAI) in `terraform/` with 5 files:
providers.tf, variables.tf, main.tf, outputs.tf, backend.tf.

As of 2026-07-11 audit, the IaC already does several things correctly:
- S3 bucket fully private: `aws_s3_bucket_public_access_block` with all 4 flags true,
  plus `aws_s3_bucket_ownership_controls` set to `BucketOwnerEnforced` (ACLs disabled).
- Bucket policy scoped to `cloudfront.amazonaws.com` service principal with an
  `AWS:SourceArn` condition tied to the specific distribution ARN — least privilege,
  no wildcard principal/resource beyond the standard `/*` object suffix.
- CloudFront uses OAC (`aws_cloudfront_origin_access_control`), not legacy OAI.
- `viewer_protocol_policy = "redirect-to-https"` enforces HTTPS.
- No hardcoded secrets, ARNs, or account IDs anywhere in the 5 files.

Recurring gaps found (still open as of last audit, main.tf / backend.tf):
- No `aws_s3_bucket_server_side_encryption_configuration` for the site bucket.
- No `aws_cloudfront_response_headers_policy` — missing CSP, X-Frame-Options,
  HSTS, X-Content-Type-Options on the distribution's `default_cache_behavior`.
- `viewer_certificate { cloudfront_default_certificate = true }` is used
  unconditionally even though `aliases = var.domain_name == "" ? [] : [var.domain_name]`
  — AWS rejects a default cert when aliases are set, so this breaks the moment
  someone fills in `domain_name`. Needs an ACM cert + `minimum_protocol_version`
  wired in conditionally.
- No S3 bucket versioning, no S3 access logging, no CloudFront `logging_config`.
- `backend.tf` remote S3 backend is intentionally left commented out (documented
  bootstrap procedure in the file's own comments — this is deliberate, not an
  oversight, see [[reference-backend-bootstrap-pattern]]). Current effective
  backend is local state.
- No `.gitignore` at repo root at all — `terraform.tfstate`, `.terraform/`,
  and `*.tfvars` are not excluded from git, so any local terraform run risks
  committing state/secrets.
- No IAM or OIDC resources exist in terraform/ at all yet — if a GitHub Actions
  deploy role is added later, must check OIDC trust policy is scoped to
  repo/branch (checklist item currently N/A because no such resource exists).

How to apply: on re-audit, first check whether the above gaps still exist before
re-reporting them verbatim — verify current file contents, don't assume memory
is still accurate.
