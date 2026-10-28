# Cloud Security Portfolio

Hands-on projects built to demonstrate practical cloud security, networking, and identity engineering skills across AWS and Azure - built and documented as part of a return to hands-on technical work after 15+ years in network admin/VoIP engineering and a stint in sales leadership.

Each project below is self-contained: infrastructure-as-code, a README covering the architecture and the reasoning behind design decisions, and (where applicable) a demo recording.

Note: Claude Code is used throughout these projects as what I can best describe as a mentor. I'm performing the work, and using Claude to shorten the learning curve to expedite my transition from traditional network administration to cloud engineering. As AI becomes more prevalent in today's general tech stack, I think it's important to know how to use AI to help with work while maintaining the foundational and underlying knowledge to know work is done. Work with AI should not replace the work. Throughout this portfolio process, the prompting strictly reinforces the importance of me learning when things aren't already known, or if there is a knowledge gap that can be bridged through a discussion.

## Background

CompTIA Security+ and Cloud+ certified. Currently pursuing an AS in Network Systems Security at St. Petersburg College. Prior experience: network administration and VoIP/UCaaS engineering.

## Projects

### AWS

| # | Project | Status | Stack |
|---|---------|--------|-------|
| 1 | [Secure Multi-Tier VPC](./aws-01-vpc-terraform) | In progress | Terraform, AWS VPC/IAM |
| 2 | GuardDuty → EventBridge → Lambda Detection Pipeline | Planned | AWS GuardDuty, EventBridge, Lambda |
| 3 | IAM/SSO Implementation | Planned | Okta / Azure AD, AWS IAM |
| 4 | Wazuh SIEM on EC2 | Planned | Wazuh, EC2, CloudTrail |
| 5 | CIS AWS Foundations Benchmark Audit | Planned | Prowler |

### Azure

Built in a 5-day sprint against an expiring $200 Azure credit - same defense-in-depth arc as the AWS track (network → identity → detection → compliance), built fast and deliberately scoped to fit the time and budget constraint.

| # | Project | Status | Stack |
|---|---------|--------|-------|
| 1 | [Secure Network Foundation (VNet/NSGs)](./azure-01-network-terraform) | Complete | Terraform, Azure VNet/NSG, Network Watcher, Azure Bastion |
| 2 | Identity (Entra ID RBAC, Conditional Access, PIM) | Planned | Microsoft Entra ID |
| 3 | Detection & Response | Planned | Microsoft Sentinel, Log Analytics, Logic Apps |
| 4 | CIS Azure Foundations Benchmark Audit | Planned | Microsoft Defender for Cloud, Azure Policy |

See [docs/build-environment.md](./docs/build-environment.md) for how the local Terraform/AWS CLI environment itself is provisioned.

## Contact

Corey Creech — [LinkedIn](#) · [Email](mailto:corey.k.creech@gmail.com)
