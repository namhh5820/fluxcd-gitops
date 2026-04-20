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
flux get hr podinfo --namespace default

# Stream logs for a specific HelmRelease
flux logs --kind=HelmRelease --name=podinfo --namespace=default

# View all logs from the helm-controller
flux logs --level=error --all-namespaces


#If you don't want to wait for the interval
flux reconcile source git flux-system
flux reconcile helmrelease python-web-app


