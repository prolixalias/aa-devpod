# aa-devcontainer
## reference

| Link      | Description |
| ----------- | ----------- |
| [Microsoft repos](https://github.com/microsoft/vscode-dev-containers) | Microsoft devcontainer repos/documentation on GitHub |
| [Docker Hub images](https://hub.docker.com/_/microsoft-vscode-devcontainers) | Official images on Docker Hub |
| [Kubernetes debugging](https://github.com/Azure/vscode-kubernetes-tools/blob/master/debug-on-kubernetes.md) | Debugging in VSCode on Kubernetes |
| [Kubernetes Tools extension for VSCode](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools) | Extension to interact with kubernetes within VSCode |

## kubernetes
### image
#### nerdctl
```shell
/usr/local/bin/nerdctl -n k8s.io build -f ./deploy/Dockerfile.devcontainer-puppet-focal -t mcr-devcontainer-puppet-focal .
```
#### moby
```shell
/usr/local/bin/docker build -f ./deploy/Dockerfile.devcontainer-puppet-focal -t mcr-devcontainer-puppet-focal .
/usr/local/bin/kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
```
### namespace
```shell
/usr/local/bin/kubectl apply -f deploy/base/namespace-devcontainers.yaml
```

```shell
/usr/local/bin/kubectl config set-context $(kubectl config current-context) --namespace devcontainers
```
### configmap
```shell
/usr/local/bin/kubectl apply -f deploy/base/configmap-r10k-config.yaml
```
### secrets
#### prerequisite key(s)
```shell
/usr/bin/ssh-keygen -t ed25519 -a 100
```
*NOTE:* [a thoughtful article on the topic of key generation](https://stribika.github.io/2015/01/04/secure-secure-shell.html)
#### create
```shell
/usr/local/bin/op create document secret.ssh-egress.yaml --vault automation
/usr/local/bin/op create document secret.eyaml-keys.yaml --vault automation
```
#### get
```shell
/usr/local/bin/op get document secret.ssh-egress.yaml --vault automation | kubectl apply -f -
/usr/local/bin/op get document secret.eyaml-keys.yaml --vault automation | kubectl apply -f -
```
### apply
```shell
/usr/local/bin/kubectl kustomize deploy/overlays/paul | /usr/local/bin/kubectl apply -f -
```
## docker compose (deprecated)
### usage

./compose/compose.sh [semver]

example:
```shell
./compose/compose.sh v0.0.0
```

NOTE: if no tag/semver provided, resulting image(s) are tagged 'wip'
