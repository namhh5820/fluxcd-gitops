# To install the CLI with Homebrew run:
brew install fluxcd/tap/flux


# Export your GitHub personal access token and username:
export GITHUB_TOKEN=<your-token>
export GITHUB_USER=<your-username>

# Check you have everything needed to run Flux by running the following command:
flux check --pre

# Install Flux onto your cluster
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=fluxcd-gitops \
  --branch=main \
  --path=./clusters/k8s-cluster-qa \
  --personal



flux create source git helm-github-io \
  --url=https://github.com/helm/examples.git \
  --branch=main \
  --interval=1m \
  --export > ./clusters/k8s-cluster-qa/helm-github-io-source.yaml


flux create hr hello-world \
  --source=GitRepository/helm-github-io.flux-system \
  --chart="./charts/hello-world" \
  --interval=5m \
  --export > ./clusters/k8s-cluster-qa/hello-world-hr.yaml


# List all HelmReleases in all namespaces
flux get hr -A

# Get details of a specific release
flux get hr hello-world --namespace default

# Stream logs for a specific HelmRelease
flux logs --kind=HelmRelease --name=hello-world --namespace=default

# View all logs from the helm-controller
flux logs --level=error --all-namespaces

#If you don't want to wait for the interval
flux reconcile source git flux-system
flux reconcile helmrelease hello-world --namespace default




### PODINFO
flux create source git helm-podinfo \
--url=https://stefanprodan.github.io/podinfo \
--branch=master \
--interval=1m \
--export > ./clusters/k8s-cluster-qa/podinfo-source.yaml

flux create hr podinfo \
  --source=GitRepository/helm-podinfo.flux-system \
  --chart="./charts/podinfo" \
  --interval=5m \
  --export > ./clusters/k8s-cluster-qa/podinfo-hr.yaml