FROM oraclelinux:8 AS base

LABEL image-name="devcontainer/puppet-oraclelinux8"
LABEL maintainer="prolixalias@gmail.com"

ARG USER_NAME=puppet
ARG USER_UID=12000
ARG USER_GID=12000
ARG OS_PACKAGES="curl git langpacks-en glibc-langpack-en sudo vim"
ARG PUPPET_PACKAGES="puppet-bolt puppet-agent hiera pdk"
ARG GEMS="puppet-lint puppet-strings r10k yard"

RUN /usr/bin/dnf update -y && \
    /usr/bin/dnf install -y ${OS_PACKAGES} && \
    # localectl set-locale LANG=en_US.UTF-8 && \
    /usr/bin/curl -O https://yum.puppet.com/puppet-tools-release-el-8.noarch.rpm && \
    /usr/bin/curl -O https://yum.puppet.com/puppet7-release-el-8.noarch.rpm && \
    /bin/rpm -i puppet-tools-release-el-8.noarch.rpm && \
    /bin/rpm -i puppet7-release-el-8.noarch.rpm && \
    /bin/rm -f puppet7-release-el-8.noarch.rpm puppet-tools-release-el-8.noarch.rpm && \
    /usr/bin/dnf update -y && \
    /usr/bin/dnf install -y ${PUPPET_PACKAGES} && \
    /bin/ln -s /opt/puppetlabs/bin/puppet /usr/local/bin/puppet && \
    /bin/ln -s /opt/puppetlabs/puppet/bin/r10k /usr/local/bin/r10k && \
    /usr/sbin/groupadd --gid ${USER_GID} ${USER_NAME} && \
    /usr/sbin/useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USER_NAME} && \
    /bin/echo $USER_NAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER_NAME} && \
    /bin/chmod 0440 /etc/sudoers.d/${USER_NAME} && \
    /opt/puppetlabs/puppet/bin/gem install ${GEMS} && \
    /bin/rm -rf /root/.gem/specs /var/lib/gems/*/cache && \
    /usr/bin/dnf clean all && \
    /bin/rm -rf /var/cache/yum
    # /bin/rm -f /var/lib/rpm/__db* && \
    # /usr/bin/rpmdb --rebuilddb
    # /bin/rpm -vv --rebuilddb

FROM base AS user

USER ${USER_NAME}

# setup vim with color scheme, pathogen and plugins 
RUN /bin/mkdir -p ~/.ssh ~/.config/puppet ~/.vim/autoload ~/.vim/bundle ~/.vim/colors && \
    /usr/bin/printf "---\ndisabled: true\n" > ~/.config/puppet/analytics.yml && \
    /usr/bin/ssh-keyscan -H github.com > ~/.ssh/known_hosts && \
    /usr/bin/curl -LSso ~/.vim/colors/zenburn.vim https://raw.githubusercontent.com/jnurmine/Zenburn/master/colors/zenburn.vim && \
    /usr/bin/curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && \
    /usr/bin/git clone --depth 1 https://github.com/rodjek/vim-puppet.git ~/.vim/bundle/puppet && \
    /usr/bin/git clone --depth 1 https://github.com/vim-syntastic/syntastic.git ~/.vim/bundle/syntastic

COPY ../../common/.vimrc /home/${USER_NAME}/.vimrc
COPY ../../common/.bashrc /home/${USER_NAME}/.bashrc

ENTRYPOINT /usr/bin/bash
