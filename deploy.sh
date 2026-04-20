flux create source git k-helm-charts \
  --url=https://github.com/namhh5820/k-helm-charts.git \
  --branch=main \
  --interval=1m \
  --export > ./clusters/k8s-cluster-qa/k-helm-charts-source.yaml



flux create hr python-app \
  --source=GitRepository/k-helm-charts.flux-system \
  --chart="./python-app-chart" \
  --interval=5m \
  --export > ./clusters/k8s-cluster-qa/python-app-hr.yaml


