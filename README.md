# Project CASPER

## Members:

- Cyril Cuvelier
- Paul Marliot
- Thibaut Tournemaine
- Rémi Van Boxem

## How to Use

### Local Setup

Follow the instructions in the [HOWTO.md file](https://github.com/CloudComputingCPRT/Casper/blob/main/HOWTO.md) to set up the project locally.

### Configuration

Create a `terraform.tfvars` file in the `./infrastructure/` directory and populate it with the following variables:

```hcl
github_handle         = "<your GitHub account name>"
email_address         = "<your Azure email address>"
subscription_id       = "<your Azure subscription ID>"
database_name         = "<desired name for the database>"
database_username     = "<desired username for the database>"
new_relic_licence_key = "<your New Relic license key>"
```

---

## Workflow

Our CI/CD pipeline leverages reusable GitHub Actions for modularity and scalability, making the workflows adaptable to other teams or projects. While this approach is robust and reusable, it exceeds the complexity required for this project but serves as a demonstration of best practices for larger projects.

### Branch Management

- **Main Branch (`main`)**: Production-ready code.
- **Release Branches (`releases/*`)**: Pre-production staging.
- **Feature Branches (`feat/*`)**: Feature development.
- **Fix Branches (`fix/*`)**: Bug fixes.

### CI/CD Pipeline Overview

The pipeline ensures quality and reliability at every stage:

- **Feature Branches**: Linting, testing, code analysis, and build checks.
- **Release Branches**: Validation of pull requests, code analysis, and pre-release image builds.
- **Main Branch**: Validation of changes, code analysis, and production-ready image builds.

### Workflow Diagram

```mermaid
graph TD;
    %% Branch Roles
    subgraph Branch_Roles [Branch Roles]
        A[main Branch] --> A1[Production-Ready Code]
        B[releases/* Branch] --> B1[Pre-Production Staging]
        C[feat/* Branch] --> C1[Feature Development]
        D[fix/* Branch] --> D1[Bug Fixes]
    end

    %% Workflow
    subgraph Workflow [Workflow]
        W1[Push to feat/* or fix/*] --> W2[Feature Branch CI/CD]
        W2 --> W3[Merge to releases/*]
        W3 --> W4[Release Branch CI/CD]
        W4 --> W5[Merge to main]
        W5 --> W6[Main Branch CI/CD]
        W6 --> W7[Deploy to Production]
    end

    %% CI/CD Process
    subgraph CI_CD_Process [CI/CD Process]
        %% Feature/Fix Branches
        F1[Lint & Test] --> F2[Code Analysis]
        F2 --> F3[Build]

        %% Release Branches
        R1[Validate Changes] --> R2[Code Analysis]
        R2 --> R3[Build]
        R3 --> R4[Build Image - Pre Release]

        %% Main Branch
        M1[Validate Changes] --> M2[Code Analysis]
        M2 --> M3[Build]
        M3 --> M4[Build Image - Release]
    end

    %% Connections
    C1 -.->|Push to feature branch| W1
    D1 -.->|Push to fix branch| W1
    B1 -.->|Staging| W4
    A1 -.->|Deployments| W7

    %% CI/CD Connections
    W2 --> F1
    W4 --> R1
    W6 --> M1
```

---

## Troubleshooting

During the project, several issues were encountered. Below are the key challenges and their resolutions:

### Deployment

- **Issue**: Students' accounts lacked permissions to create credentials for GitHub Actions.
- **Solution**: Deployment with commented-out credentials in `build_image.yml` was attempted, but additional manual setup was required.

### Database

- **Issue**: Two database users were created, and the app's user lacked read/write permissions.
- **Identification**: Populated the database using Azure CLI and identified a misconfiguration.
- **Solution**: Forced password login and deactivated Entra ID login.

### Virtual Network

- **Issue**: Late-stage implementation of the virtual network caused significant delays and broke existing Terraform modules.
- **Identification**: Increased time consumption without functional gains.
- **Solution**: No resolution during the project. For future projects, virtual network setup should be a priority.

---
