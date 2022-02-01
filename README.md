# aa-devcontainer
Automation-centric devcontainers for use with VSCode
## reference links

| Link | Description |
| ----------- | ----------- |
| [Rancher Desktop](https://rancherdesktop.io)| Kubernetes and container management |
| [Microsoft repos](https://github.com/microsoft/vscode-dev-containers) | Microsoft devcontainer repos/documentation on GitHub |
| [Docker Hub images](https://hub.docker.com/_/microsoft-vscode-devcontainers) | Official images on Docker Hub |
| [Kubernetes Tools extension](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools) | Extension to interact with kubernetes within VSCode |
| [Remote Development extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) | Extension that allows remote development |
| [Puppet extension](https://marketplace.visualstudio.com/items?itemName=puppet.puppet-vscode) | Extension with Puppet linting, syntactic highlighting and other useful tidbits |
| [Kubernetes debugging](https://github.com/Azure/vscode-kubernetes-tools/blob/master/debug-on-kubernetes.md) | Debugging in VSCode on Kubernetes |
| []() | |

## kubernetes
### :sparkles: images
#### [containerd](https://containerd.io) - Linux/MacOS, Rancher Desktop
##### build+push base images
###### ubuntu
```shell
for OS_RELEASE in bionic focal jammy; do
  nerdctl -n k8s.io build --no-cache --build-arg OS_RELEASE=${OS_RELEASE} -f deploy/Dockerfile.devcontainer-base-ubuntu -t prolixalias/devcontainer-base-ubuntu:${OS_RELEASE} .
done
```
```shell
for OS_RELEASE in bionic focal jammy; do
  nerdctl -n k8s.io push prolixalias/devcontainer-base-ubuntu:${OS_RELEASE}
done
```
###### oracle linux
  > *NOTE: vscode remote container not supported on 6*
```shell
for OS_RELEASE in 7 8; do
  nerdctl -n k8s.io build --no-cache --build-arg OS_RELEASE=${OS_RELEASE} -f deploy/Dockerfile.devcontainer-base-oraclelinux -t prolixalias/devcontainer-base-oraclelinux:${OS_RELEASE} .
done
```
```shell
for OS_RELEASE in 7 8; do
  nerdctl -n k8s.io push prolixalias/devcontainer-base-oraclelinux:${OS_RELEASE}
done
```
##### build puppet images
###### ubuntu
```shell
for OS_RELEASE in bionic focal; do
  nerdctl -n k8s.io build --no-cache --build-arg OS_RELEASE=${OS_RELEASE} --build-arg PUPPET_RELEASE=7 -f deploy/Dockerfile.devcontainer-puppet-ubuntu -t devcontainer-puppet-ubuntu:${OS_RELEASE} .
done
```
  > *NOTE: `pdk` and `bolt` packages not implemented for bionic with AARCH64*

  > *NOTE: puppet-rolled packages for jammy expected mid-April 2022*
###### oracle linux
```shell
for OS_RELEASE in 7 8; do
  nerdctl -n k8s.io build --no-cache --build-arg OS_RELEASE=${OS_RELEASE} --build-arg PUPPET_RELEASE=7 -f deploy/Dockerfile.devcontainer-puppet-oraclelinux -t devcontainer-puppet-oraclelinux:${OS_RELEASE} .
done
```
  > *NOTE: `pdk` and `bolt` packages not implemented for [78] with AARCH64*
#### [moby](https://mobyproject.org) - Windows, Docker Desktop
##### build bionic
```shell
docker build --no-cache --build-arg OS_RELEASE=bionic -f ./deploy/Dockerfile.devcontainer-puppet-ubuntu -t devcontainer-puppet-ubuntu-bionic .
```
##### build focal
```shell
docker build --no-cache --build-arg OS_RELEASE=focal -f ./deploy/Dockerfile.devcontainer-puppet-ubuntu -t devcontainer-puppet-ubuntu-focal .
```
##### build jammy (future use, not implemented)
```shell
docker build --no-cache --build-arg OS_RELEASE=jammy -f ./deploy/Dockerfile.devcontainer-puppet-ubuntu -t devcontainer-puppet-ubuntu-jammy .
```
##### add local-path storage
```shell
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
```
### :sparkles: namespace creation
```shell
kubectl apply -f ./deploy/base/namespace.devcontainer.yaml
```
### :sparkles: switch context accordingly
```shell
kubectl config set-context $(kubectl config current-context) --namespace devcontainer
```
### :sparkles: configmap for r10k config
```shell
kubectl apply -f ./deploy/base/configmap.r10k-config.yaml
```
### :sparkles: secrets
#### prerequisite keypair
```shell
ssh-keygen -t ed25519 -a 100
```
> *NOTE: add resulting public key to GHE, etc*
#### create
```shell
/usr/local/bin/op create document secret.ssh-egress.yaml --vault automation
/usr/local/bin/op create document secret.eyaml-keys.yaml --vault automation
/usr/local/bin/op create document secret.r10k-deploy-key.yaml --vault automation
```
#### apply
```shell
/usr/local/bin/op get document secret.ssh-egress.yaml --vault automation | kubectl apply -f -
/usr/local/bin/op get document secret.eyaml-keys.yaml --vault automation | kubectl apply -f -
/usr/local/bin/op get document secret.r10k-deploy-key.yaml --vault automation | kubectl apply -f -
```
### :sparkles: kustomize
```shell
kubectl kustomize deploy/overlays/users/paul | kubectl apply -f -
```
### :sparkles: helm (future use with puppetserver)
#### add puppetserver chart
```shell
helm repo add puppet https://puppetlabs.github.io/puppetserver-helm-chart
```
#### install puppetserver (future use)
```shell
helm install puppetserver --namespace devcontainer puppet/puppetserver -f deploy/base/values.helm-puppetserver.yaml
```
## docker compose (deprecated)
### :sparkles: usage
`./compose/compose.sh [semver]`

example:
```shell
./compose/compose.sh v0.0.0
```
> *NOTE: if no tag/semver provided, resulting image(s) are tagged 'wip'*
## license
[BSD-2-Clause](https://opensource.org/licenses/BSD-2-Clause)
