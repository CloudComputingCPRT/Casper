# Project CASPER

### Members:

- Cyril Cuvelier
- Paul Marliot
- Thibaut Tournemaine
- Rémi Van Boxem

### Workflow
```mermaid
graph TD;
    A[feat/* or fix/* Branch] -->|Push| B[Feature Branch CI];
    B -->|Merge to release branch| C[Release Branch CI/CD];
    C -->|Merge to main branch| D[Main Branch CI/CD];
    D -->|Deploy| E[Production];
```
