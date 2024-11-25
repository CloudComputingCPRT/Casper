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
        A[main Branch]:::prodRole --> A1[Production-Ready Code]
        B[releases/* Branch]:::releaseRole --> B1[Pre-Production Staging]
        C[feat/* Branch]:::featureRole --> C1[Feature Development]
        D[fix/* Branch]:::fixRole --> D1[Bug Fixes]
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
        F1[Test]:::ci --> F2[Lint]:::ci
        F2 --> F3[Static Analysis]:::ci
        F3 --> F4[Build]:::ci
        F4 --> F5[Docker Build (if applicable)]:::ci
        F5 --> F6[Deployment (on main)]:::ci
    end

    %% Connections
    A1 -.->|Deployments| W7
    B1 -.->|Staging| W4
    C1 -.->|Push to feature branch| W1
    D1 -.->|Push to fix branch| W1

    W2 --> F1
    W4 --> F1
    W6 --> F6

    %% Style Definitions
    classDef prodRole fill:#3CB371,stroke:#000,stroke-width:2,color:#FFF;
    classDef releaseRole fill:#87CEEB,stroke:#000,stroke-width:2,color:#FFF;
    classDef featureRole fill:#FFD700,stroke:#000,stroke-width:2,color:#000;
    classDef fixRole fill:#FF6347,stroke:#000,stroke-width:2,color:#FFF;
    classDef ci fill:#D3D3D3,stroke:#000,stroke-width:1,color:#000;


```
