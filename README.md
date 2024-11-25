# Project CASPER

### Members:

- Cyril Cuvelier
- Paul Marliot
- Thibaut Tournemaine
- Rémi Van Boxem

### How to use it 

Please refer to this [file](https://github.com/CloudComputingCPRT/Casper/blob/main/HOWTO.md)

### Workflow
We used github reusable actions for more adaptability. It's overkill for the actual project but a good example of how it should work for a bigger project. 

- For the working branches we added a linter (flake8), used the provided tests, a code analysis and a build check.  
- For the releases and main branches, we first validate the changes comming from the pullrequest and then use the same workflow without the lient & test, and adding a build docker image action to create our packages.


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
