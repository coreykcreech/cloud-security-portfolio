# Build Notes — Secure Multi-Tier VPC

A running log of decisions, problems hit, and things learned while building this project — written as I go, not cleaned up after the fact. Mistakes and dead ends are left in on purpose; they're part of showing the actual process, not just the finished result.

---

<!--
Entry format:

## YYYY-MM-DD
What I did, what I hit, what I learned or decided, and why. A sentence or two is fine — this isn't a formal writeup, that's what the README is for.
-->

## 09-28-26
### Project 1: VPC / Terraform Foundation

### What this covers

### Architecture decisions
#### Why S3 backend + native locking (vs. DynamoDB)

Post Terraform 1.10, this is the new standard for State Management. Built in, it reduces the initial configuration (no db table to create), has security in mind with a smaller IAM/policy footprint, and falls within the AWS free tier entirely.

#### Why us-east-1

us-east-1 is the default region for new AWS accounts. It's also the first-ever region, so typically new features land here before other regions. Aside from these facts, it offers the highest EC2 capacity, best on-demand availability, and favorable pricing compared to some other regions. Note that a major outage in us-east-1 usually has cascading effects on other regions and resources, since many foundational AWS services rely heavily on this region being online.

- (add VPC/subnet/NAT design decisions once main.tf exists)

### Problems encountered
#### Backend block not inheriting provider profile (IMDS hang on init)

When setting up the bucket encryption, a small typo caused it to give back an error. It's important to be able to review what comes back, as well as your input, to make sure what you're passing in is syntaxually correct.

- (add anything new from main.tf work)

### Trade-offs / tech debt
#### terraform IAM user has AdministratorAccess — remediation plan via IAM Access Analyzer once resources exist

Technical debt is a real thing. From a security standpoint, things like stale or over-privilegded access are vulnerabilities that need to be corrected. This account will need to be adjusted once the Terraform part of this portfolio is correctly configured and completed.

### Gotchas for anyone repeating this
#### .gitignore excluding .terraform.lock.hcl by default — should be committed

During one of the pushes, I noticed the .hcl file was being ignored. Not sure why that happened, but it was flagged as concerning. According to official HashiCorp best practices, this file should NOT be excluded. I fixed it, but wondering if this is a natural default or just something I did wrong during one of my commits.

### Status / next steps