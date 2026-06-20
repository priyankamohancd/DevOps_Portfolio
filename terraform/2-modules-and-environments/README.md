# EC2 + RDS — Modules + Environments

The same EC2 + RDS setup as the simple version, refactored into reusable
**modules** consumed by separate **environments**. The resources are identical;
they are just organised so each environment is independent.

## Structure

```
.
├── modules/
│   ├── ec2/        # Reusable EC2 + security group
│   └── rds/        # Reusable RDS + subnet group + security group
└── environments/
    ├── dev/        # Calls the modules with dev values
    └── qa/         # Calls the modules with qa values
```

The big idea: a **module** is defined once (how to build a thing), and an
**environment** calls it with its own values (what to build). The `dev` and `qa`
`main.tf` files are identical — only their `terraform.tfvars` differ.

## How the pieces connect

1. Each environment looks up the default VPC and subnets.
2. It calls the `ec2` module, which returns its `security_group_id`.
3. It passes that ID into the `rds` module, so the database allows traffic from
   the app and nothing else.

## Before you start

1. AWS credentials configured.
2. Edit `allowed_ssh_cidrs` in the tfvars to your own IP.
3. Set the DB password as an environment variable so it stays out of code:

```bash
export TF_VAR_db_password="ChooseAStrongPassword123!"
```

## Run it

Each environment is its own working directory, so you `init` inside it:

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

Then do the same in `environments/qa`. Because they are separate folders, dev
and qa can both exist at the same time without clashing.

## Tear down

```bash
terraform destroy
```

## Next step up

This version keeps state locally in each folder. The production version adds an
S3 remote backend (so a team can share state safely), AWS Secrets Manager for
the DB password, and extra hardening — but the module/environment shape stays
exactly the same as what you see here.
