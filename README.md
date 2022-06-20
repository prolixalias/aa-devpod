# aa-devpod
Automation-centric devpod for use with VSCode
## reference links

| Link | Description |
| ----------- | ----------- |
| [Rancher Desktop](https://rancherdesktop.io)| Kubernetes and container management |
| [Microsoft repos](https://github.com/microsoft/vscode-dev-containers) | Microsoft repos/documentation on GitHub |
| [Docker Hub images](https://hub.docker.com/_/microsoft-vscode-devcontainers) | Official images on Docker Hub |
| [Kubernetes Tools extension](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools) | Extension to interact with kubernetes within VSCode |
| [Remote Development extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) | Extension that allows remote development |
| [Puppet extension](https://marketplace.visualstudio.com/items?itemName=puppet.puppet-vscode) | Extension with Puppet linting, syntactic highlighting and other useful tidbits |
| [Kubernetes debugging](https://github.com/Azure/vscode-kubernetes-tools/blob/master/debug-on-kubernetes.md) | Debugging in VSCode on Kubernetes |
| []() | |

## kubernetes
### :sparkles: images
#### [containerd](https://containerd.io) - Linux/MacOS, Rancher Desktop
##### build base images (push manually with auth from k8s)
###### ubuntu
```shell
for OS_RELEASE in bionic focal jammy; do
  nerdctl -n k8s.io build --no-cache --build-arg OS_RELEASE=${OS_RELEASE} -f deploy/build/Dockerfile.devpod-base-ubuntu -t prolixalias/devpod-base-ubuntu:${OS_RELEASE} .
done
```
###### oracle linux
```shell
for OS_RELEASE in 7 8; do
  nerdctl -n k8s.io build --no-cache --build-arg OS_RELEASE=${OS_RELEASE} -f deploy/build/Dockerfile.devpod-base-oraclelinux -t prolixalias/devpod-base-oraclelinux:${OS_RELEASE} .
done
```
  > *NOTE: vscode remote container not supported on 6*
##### build puppet images
###### ubuntu
```shell
for OS_RELEASE in bionic focal; do
  nerdctl -n k8s.io build --no-cache --build-arg OS_RELEASE=${OS_RELEASE} --build-arg PUPPET_RELEASE=7 -f deploy/build/Dockerfile.devpod-puppet-ubuntu -t devpod-puppet-ubuntu:${OS_RELEASE} .
done
```
  > *NOTE: `pdk` and `bolt` packages not implemented for bionic with AARCH64*

  > *NOTE: puppet-rolled packages for jammy expected mid-April 2022*
###### oracle linux
```shell
for OS_RELEASE in 7 8; do
  nerdctl -n k8s.io build --no-cache --build-arg OS_RELEASE=${OS_RELEASE} --build-arg PUPPET_RELEASE=7 -f deploy/build/Dockerfile.devpod-puppet-oraclelinux -t devpod-puppet-oraclelinux:${OS_RELEASE} .
done
```
  > *NOTE: `pdk` and `bolt` packages not implemented for [78] with AARCH64*
#### [moby](https://mobyproject.org) - Windows, Docker Desktop (deprecated)
##### build bionic
```shell
docker build --no-cache --build-arg OS_RELEASE=bionic -f ./deploy/Dockerfile.devpod-puppet-ubuntu -t devpod-puppet-ubuntu-bionic .
```
##### build focal
```shell
docker build --no-cache --build-arg OS_RELEASE=focal -f ./deploy/Dockerfile.devpod-puppet-ubuntu -t devpod-puppet-ubuntu-focal .
```
##### build jammy (future use, not implemented)
```shell
docker build --no-cache --build-arg OS_RELEASE=jammy -f ./deploy/Dockerfile.devpod-puppet-ubuntu -t devpod-puppet-ubuntu-jammy .
```
##### add local-path storage
```shell
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
```
### :sparkles: dashboard
```shell
curl -sSL https://git.io/kube-dashboard | sed "s|image:.*|image: luxas/kubernetes-dashboard:v1.6.3|" | kubectl apply -f -
```
### :sparkles: namespaces
## create
```shell
kubectl apply -f deploy/base/namespace.devpod.yaml
```
## switch context accordingly
```shell
kubectl config set-context $(kubectl config current-context) --namespace devpod
```
### :sparkles: secrets
#### prerequisite keypair
```shell
ssh-keygen -t ed25519 -a 100
```
> *NOTE: add resulting public key to GHE, etc*
#### create
```shell
/usr/local/bin/op document create work/secret.ssh-egress.yaml --vault automation
/usr/local/bin/op document create work/secret.eyaml-keys.yaml --vault automation
/usr/local/bin/op document create work/secret.r10k-deploy-key.yaml --vault automation
/usr/local/bin/op document create work/secret.git-remotes.yaml --vault automation
/usr/local/bin/op document create work/secret.ngrok-config.yaml --vault automation
/usr/local/bin/op document create work/secret.aws-credentials.yaml --vault automation
```
#### apply
```shell
/usr/local/bin/op document get secret.ssh-egress.yaml --vault automation | kubectl apply -f -
/usr/local/bin/op document get secret.eyaml-keys.yaml --vault automation | kubectl apply -f -
/usr/local/bin/op document get secret.r10k-deploy-key.yaml --vault automation | kubectl apply -f -
/usr/local/bin/op document get secret.git-remotes.yaml --vault automation | kubectl apply -f -
/usr/local/bin/op document get secret.ngrok-config.yaml --vault automation | kubectl apply -f -
/usr/local/bin/op document get secret.aws-credentials.yaml --vault automation | kubectl apply -f -
```
### :sparkles: kustomize
```shell
kubectl kustomize deploy/overlays/users/paul | kubectl apply -f -
```
### :sparkles: helm (future use with puppetserver)
#### add jetstack repo (for cert-manager)
```shell
helm repo add jetstack https://charts.jetstack.io
```
#### add puppet repo
```shell
helm repo add puppet https://puppetlabs.github.io/puppetserver-helm-chart
```
#### update repo cache
```shell
helm repo update
```
#### install CRDs (customresourcedefinition)
```shell
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.crds.yaml
```
#### install cert-manager
```shell
helm install \
  cert-manager jetstack/cert-manager \
  --namespace kube-system \
  --version v1.7.1 \
  --set ingressShim.defaultIssuerName=letsencrypt-staging \
  --set ingressShim.defaultIssuerKind=ClusterIssuer \
  --set ingressShim.defaultIssuerGroup=cert-manager.io
```
#### apply cluster issuer for letsencrypt (currently needs help, don't run as-is)
```shell
kubectl apply -f deploy/base/clusterissuer.letsencrypt.yaml
```

#### install puppetserver (future use)
```shell
helm install \
  puppetserver puppet/puppetserver \
  --namespace devpod \
  -f deploy/base/values.helm-puppetserver.yaml
```
### :sparkles: tmux tricks
#### pane - top status
```shell
tmux set -g pane-border-status top
```
#### pane - bottom status
```shell
tmux set -g pane-border-status bottom
```
#### pane - synchronize
```shell
setw synchronize-panes on
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
