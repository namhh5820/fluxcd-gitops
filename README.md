# FluxCD GitOps Repository

This repository manages Kubernetes deployments using FluxCD following a GitOps approach.

## Deployment Architecture

The deployment follows a hierarchical structure:

1. **Cluster Bootstrap**: Flux is configured to sync with the `clusters/k8s-cluster-qa/flux-system` directory.
2. **Infrastructure Sync**: The `flux-system` Kustomization manages the core Flux components.
3. **Apps Orchestration**: The `clusters/k8s-cluster-qa/apps.yaml` file defines a Kustomization that watches the `./apps` directory.
4. **Application Layout**:
    - `apps/kustomization.yaml`: The entry point for all applications.
    - `apps/<app-name>/`: A dedicated directory for each application containing:
        - `kustomization.yaml`: Bundles the application's manifests.
        - `python-app-source.yaml`: Defines the `GitRepository` for Helm charts.
        - `python-app-release.yaml`: Defines the `HelmRelease` configuration and values.

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

1. **Create Directory**: Create a new folder under `apps/` (e.g., `apps/my-new-app/`).
2. **Define Manifests**: Add `GitRepository`, `HelmRelease`, and a `kustomization.yaml` in the new folder.
3. **Register App**: Add the new directory to `apps/kustomization.yaml`.
4. **Commit Changes**:
   ```bash
   git add .
   git commit -m "Add/Update application"
   git push origin main
   ```

### 3. Verify Deployment
Flux will automatically detect the changes. Monitor the status with:

```bash
# Check status of Kustomizations (apps and flux-system)
flux get kustomizations

# Check status of HelmReleases
flux get helmreleases
```

## Application Specifics

### Python App
- **Source**: `https://github.com/namhh5820/k-helm-charts.git`
- **Namespace**: `python-app-prod`
- **Image**: `nginx:latest`
- **Location**: `apps/python-app/`
