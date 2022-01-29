# aa-devcontainer

## reference

https://github.com/microsoft/vscode-dev-containers
https://hub.docker.com/_/microsoft-vscode-devcontainers
https://github.com/Azure/vscode-kubernetes-tools/blob/master/debug-on-kubernetes.md

## kubernetes

### image

#### nerdctl
```shell
nerdctl -n k8s.io build -f Dockerfile.devcontainer-focal -t mcr-devcontainer-focal-puppet .
```

#### moby
```shell
docker build -f Dockerfile.devcontainer-focal -t mcr-devcontainer-focal-puppet .
```
```shell
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
```

### namespace
```shell
kubectl create namespace devcontainers
```
```shell
kubectl config set-context $(kubectl config current-context) --namespace devcontainers
```

### secrets

#### create
```shell
op create document secret.ssh-egress.yaml --vault automation
```

#### get
```shell
op get document secret.ssh-egress.yaml --vault automation | kubectl apply -f - --namespace=devcontainers
```

### apply
```shell
kubectl apply -f deploy/pod-puppet.yml
```

## docker compose (deprecated)

### usage

./compose [semver]

example:
```shell
./compose v0.0.0
```

NOTE: if no tag/semver provided, resulting image(s) are tagged 'wip'
