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


