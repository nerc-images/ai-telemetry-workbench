# ai-telemetry-workbench

An OpenShift AI Image running VSCode for Java and Go development.
- Based on the [IJava project by SpencerPark](https://github.com/SpencerPark/IJava) on GitHub for Jupyter Lab Notebook integration with OpenJDK.
- Also based on the [gophernotes project](https://github.com/gopherdata/gophernotes) on GitHub for Jupyter Lab Notebook integration with golang.
- Uses java-21-openjdk-devel and maven package support.

Base image: [quay.io/modh/codeserver:codeserver-ubi9-python-3.11-20250212](https://quay.io/repository/modh/codeserver?tab=tags&tag=codeserver-ubi9-python-3.11-20250212)

| Python packages | Description |
| --- | --- |
| jupyterlab | A web-based user interface to work with Jupyter notebooks, editors, terminals, and custom components |
| bash_kernel | A Jupyter kernel for bash |
| jinja2 | A templating language in Python, Java, and Ansible. |
| ansible | For running Ansible Playbooks from Jupyter Notebooks. |
| ansible-kernel | For running Ansible Playbooks from Jupyter Notebooks. |

| Downloaded packages | Description |
| --- | --- |
| IJava | We download IJava 1.3.0 with curl, unzip it, and install it with the provided install.py into /opt/app-root. |

| System packages | Description |
| --- | --- |
| java-21-openjdk-devel | We provide the full Java 21 OpenJDK SDK to run and compile Java applications cloned from git in the terminal and Java inline Jupyter Notebooks. |
| maven | Maven is provided for compiling, installing, and deploying Java packages to Maven Central. |
| jq | For formatting JSON output from curl commands. |
| gh | For submitting GitHub pull requests. |
| golang | The Go Programming Language. |

| Go packages | Description |
| --- | --- |
| goimports | Language tools for go formatting. |
| gophernotes | Jupyter Notebook support for golang. |
| dlv | A golang debugger. |
| gopls | A golang server. |
| prom-keycloak-proxy | The prom-keycloak-proxy project dependencies. |

### Build the container with podman

```bash
podman build -t nerc-images/ai-telemetry-workbench:latest .
```

### Run the container with podman

```bash
podman run --rm -p 8888:8888 nerc-images/ai-telemetry-workbench:latest
```

You will be able to access your new containerized VSCode workbench at: [http://localhost:8888/](http://localhost:8888/). 


You can pull the latest [ai-telemetry-workbench container image](https://github.com/nerc-images/ai-telemetry-workbench/pkgs/container/ai-telemetry-workbench) below:

```
podman pull quay.io/nerc-images/ai-telemetry-workbench:latest
```
