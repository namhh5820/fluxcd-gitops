# FluxCD GitOps Repository

This repository manages Kubernetes deployments using FluxCD following a GitOps approach.

## Deployment Architecture

The deployment follows a hierarchical structure:

1. **Cluster Bootstrap**: Flux is configured to sync with the `clusters/k8s-cluster-qa/flux-system` directory.
2. **Infrastructure Sync**: The `flux-system` Kustomization manages the core Flux components and cluster-wide configurations.
3. **Apps Orchestration**: The `clusters/k8s-cluster-qa/apps.yaml` file defines a Kustomization that watches the `./apps` directory.
4. **Application Definitions**: Each subdirectory in `./apps` (e.g., `python-app`) contains:
    - `GitRepository`: Defines the source of the Helm charts.
    - `HelmRelease`: Defines the application deployment configuration and value overrides.

## Steps to Deploy Applications

### 1. Bootstrap FluxCD (One-time setup)
To initialize FluxCD on your cluster and point it to this repository, run:

```bash
flux bootstrap github \
  --owner=<your-github-username> \
  --repository=fluxcd-gitops \
  --branch=main \
  --path=./clusters/k8s-cluster-qa \
  --personal
```

### 2. Add or Update an Application
To deploy a new application or update an existing one:

1. **Define the Source**: Create or update a `GitRepository` manifest in `apps/<app-name>/` to point to the repository containing your Helm charts.
2. **Define the Release**: Create or update a `HelmRelease` manifest in `apps/<app-name>/` with the desired configuration (image, replicas, resources, etc.).
3. **Commit Changes**: Push your changes to the `main` branch.

```bash
git add .
git commit -m "Deploy/Update <app-name>"
git push origin main
```

### 3. Verify Deployment
Flux will automatically detect the changes and apply them. You can monitor the progress with:

```bash
# Check Kustomizations
flux get kustomizations

# Check HelmReleases
flux get helmreleases

# Check Logs
flux logs --level=info
```

## Application Specifics

### Python App
The Python app is deployed using a Helm chart from an external repository.
- **Source**: `https://github.com/namhh5820/k-helm-charts.git`
- **Namespace**: `python-app-prod`
- **Current Image**: `nginx:latest`
