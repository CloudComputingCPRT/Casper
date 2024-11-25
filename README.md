# Project CASPER

### Members:

- Cyril Cuvelier
- Paul Marliot
- Thibaut Tournemaine
- Rémi Van Boxem

### Workflow
```mermaid
graph TD;
    %% Branch Roles
    subgraph Branch Roles [Branch Roles]
        A[main Branch] --> A1[Production-Ready Code]
        B[releases/* Branch] --> B1[Pre-Production Staging]
        C[feat/* Branch] --> C1[Feature Development]
        D[fix/* Branch] --> D1[Bug Fixes]
    end

    %% Workflow
    subgraph Workflow [Workflow]
        W1[Push to feat/* or fix/*] --> W2[Feature Branch CI]
        W2 --> W3[Merge to releases/*]
        W3 --> W4[Release Branch CI/CD]
        W4 --> W5[Merge to main]
        W5 --> W6[Main Branch CI/CD]
        W6 --> W7[Deploy to Production]
    end

    %% CI/CD Process
    subgraph CI/CD Process [CI/CD Process]
        F1[Test] --> F2[Lint]
        F2 --> F3[Static Analysis]
        F3 --> F4[Build]
        F4 --> F5[Docker Build]
        F5 --> F6[Deployment (on main)]
    end

    %% Connections
    A1 -.->|Deployments| W7
    B1 -.->|Staging| W4
    C1 -.->|Push to feature branch| W1
    D1 -.->|Push to fix branch| W1

    W2 --> F1
    W4 --> F1
    W6 --> F6
```
