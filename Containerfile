FROM quay.io/modh/codeserver:codeserver-ubi9-python-3.11-20250212

ENV IJAVA_VERSION=1.3.0 \
  JAVA_HOME=/usr/lib/jvm/java-21-openjdk \
  GOPATH=/usr/local/src/go

USER root

# Install pip dependencies
RUN pip install \
  jupyterlab \
  bash_kernel \
  jinja2 \
  ansible \
  ansible-kernel
# Install helm
RUN install -d /usr/local/bin/ /usr/local/src
RUN curl -fsSL -o /usr/local/bin/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
RUN chmod 700 /usr/local/bin/get_helm.sh
RUN env HELM_INSTALL_DIR=/usr/local/bin /usr/local/bin/get_helm.sh --no-sudo
RUN python -m bash_kernel.install
RUN python -m ansible_kernel.install
# Install IJava Kernel
WORKDIR /usr/local/opt/ijava
RUN install -d /usr/local/opt/ijava \
  && curl -L https://github.com/SpencerPark/IJava/releases/download/v$IJAVA_VERSION/ijava-$IJAVA_VERSION.zip -o /tmp/ijava-$IJAVA_VERSION.zip \
  && unzip -n /tmp/ijava-$IJAVA_VERSION.zip -d /usr/local/opt/ijava \
  && python3 install.py --prefix /opt/app-root \
  && jupyter kernelspec install /opt/app-root/share/jupyter/kernels/java
# Install java 21 and maven
RUN dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
RUN dnf install -y java-21-openjdk-devel maven jq gh \
  && alternatives --set java java-21-openjdk.x86_64 \
  && alternatives --set javac java-21-openjdk.x86_64
# Install golang dependencies for Jupyter
RUN dnf install -y golang
RUN go install golang.org/x/tools/cmd/goimports@latest
RUN go install github.com/gopherdata/gophernotes@v0.7.5
RUN go install -v github.com/go-delve/delve/cmd/dlv@latest
RUN go install -v golang.org/x/tools/gopls@latest
RUN mkdir -p /opt/app-root/share/jupyter/kernels/gophernotes
RUN rsync -r "/usr/local/src/go/pkg/mod/github.com/gopherdata/gophernotes@v0.7.5/kernel/" /opt/app-root/share/jupyter/kernels/gophernotes/
RUN sed -i -e "s|"'"'"gophernotes"'"'"|"'"'"/usr/local/src/go/bin/gophernotes"'"'"|" /opt/app-root/share/jupyter/kernels/gophernotes/kernel.json
RUN jupyter kernelspec install /opt/app-root/share/jupyter/kernels/gophernotes --name go --prefix /opt/app-root
RUN rm -rf /opt/app-root/share/jupyter/kernels/gophernotes
RUN git clone https://github.com/nerc-images/prom-keycloak-proxy.git /tmp/prom-keycloak-proxy/
WORKDIR /tmp/prom-keycloak-proxy
RUN go build
WORKDIR /opt/app-root/src
RUN rm -rf /tmp/prom-keycloak-proxy

RUN chown -R 1001 /opt/app-root/src

USER 1001
