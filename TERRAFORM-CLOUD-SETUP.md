# Terraform Cloud Setup (app.terraform.io)

This repo is designed to run as separate Terraform Cloud workspaces, one per component directory.

## Workspace Strategy

Create these 5 workspaces and set each workspace **Working Directory**:

1. `networkingglobal` -> `Networkingglobal`
2. `core-it-infrastructure` -> `core-it-infrastructure`
3. `jenkins-vm` -> `jenkins-vm`
4. `jenkins-ilb` -> `jenkins-ilb`
5. `dns-jenkins` -> `dns-jenkins`

Use Terraform version `>= 1.0` (matching code constraints).

## Required Environment Variable

Set this in each workspace (Sensitive):
- `GOOGLE_CREDENTIALS` = contents of your GCP service account JSON key

## Required Terraform Variables By Workspace

### 1) networkingglobal
- `project_id` (string)
- `new_project_id` (string)
- `billing_account` (string, sensitive)
- `region` (string, optional if default used)
- `subnet_cidr` (string, optional if default used)

### 2) core-it-infrastructure
- `new_project_id` (string)
- `billing_account` (string, sensitive)
- `region` (string, optional if default used)
- `subnet_cidr` (string, optional if default used)

### 3) jenkins-vm
- `project_id` (string)
- `region` (string, optional if default used)
- `zone` (string, optional if default used)
- `vm_name` (string, default `gcp-jenkins`)
- `jenkins_display_name` (string, default `GCP-Jenkins`)

### 4) jenkins-ilb
- `project_id` (string)
- `region` (string, optional if default used)
- `zone` (string, optional if default used)
- `jenkins_vm_name` (string, default `gcp-jenkins`)
- `ssl_private_key` (string, sensitive; PEM private key)
- `ssl_certificate` (string, sensitive; PEM certificate chain)

### 5) dns-jenkins
- `project_id` (string)
- `region` (string, optional if default used)
- `jenkins_lb_ip` (string, default `10.10.10.50`)
- `dns_zone_name` (string, default `gcphome.store.`)
- `jenkins_host_label` (string, default `jenkins`)

## Apply Order

Run workspaces in this order:

1. `networkingglobal`
2. `core-it-infrastructure`
3. `jenkins-vm`
4. `jenkins-ilb`
5. `dns-jenkins`

## Notes

- DNS forwarder is removed from this POC.
- Deployment is non-HA (single Jenkins backend).
- Jenkins VM name is `gcp-jenkins` and Jenkins display name is `GCP-Jenkins`.
- Resulting private Jenkins URL (by default): `https://jenkins.gcphome.store`.
