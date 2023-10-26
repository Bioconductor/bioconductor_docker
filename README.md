[![license](https://img.shields.io/badge/license-Artistic--2.0-blue)](https://opensource.org/licenses/Artistic-2.0)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Weekly devel build status](https://img.shields.io/github/workflow/status/bioconductor/bioconductor_docker/weekly-bioconductor-docker-devel-builder/master)](https://github.com/Bioconductor/bioconductor_docker/actions/workflows/weekly-devel-builder.yml)

# Docker containers for Bioconductor

[Docker](https:/docs.docker.com/engine/docker-overview/) packages software
into self-contained environments, called containers, that include necessary
dependencies to run. Containers can run on any operating system including
Windows and Mac (using modern Linux kernels) via the
[Docker engine](https://docs.docker.com/engine/).

Containers can also be deployed in the cloud using
[Amazon Elastic Container Service](https://aws.amazon.com/ecs/),
[Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/)
or [Microsoft Azure Container Instances](https://azure.microsoft.com/en-us/services/container-instances/)

<a name="top"></a>

- [Quick start](#quickstart)
- [Why Use Containers](#intro)
  * [Goals for new containers](#goals)
- [Current Containers](#current)
- [Using Containers](#usage)
  * [Running Containers](#running)
  * [Mounting Additional Volume](#mounting)
  * [Using docker-compose](#dockercompose)
- [Modifying Image Container](#modify)
- [Singularity](#singularity)
- [Microsoft Azure Container Instances](#msft)
  * [Use Azure Container Instances to run bioconductor images on-demand on Azure](#aci)
- [How to contribute](#contribute)
- [Deprecation Notice](#deprecation)
  * [Legacy Containers](#legacy)
  * [Reason for deprecation](#reason)
  * [Reporting issues](#issues)
- [Acknowledgements](#acknowledgements)

<a name="quickstart"></a>
## Quick start

1. Install Docker

1. Run container with Bioconductor and RStudio

		docker run \
			-e PASSWORD=bioc \
			-p 8787:8787 \
			bioconductor/bioconductor_docker:devel

	This command will run the docker container
	`bioconductor/bioconductor_docker:devel` on your local machine.

	RStudio will be available on your web browser at
	`http://localhost:8787`. The USER is fixed to always being
	`rstudio`. The password in the above command is given as `bioc` but
	it can be set to anything. `8787` is the port being mapped between
	the docker container and your host machine. NOTE: password cannot
	be `rstudio`.

	The user is logged into the `rstudio` user by default.

<a name="intro"></a>
## Why use Containers

With Bioconductor containers, we hope to enhance

* **Reproducibility**: If you run some code in a container today,
  you can run it again in the same container (with the same
  [tag](https://docs.docker.com/userguide/dockerimages/#setting-tags-on-an-image))
  years later and know that nothing in the container has changed.
  You should always take note of the tag you used if you think
  you might want to reproduce some work later.

* **Ease of use**: With one command, you can be running the
  latest release or devel Bioconductor. No need to worry
  about whether packages and system dependencies are
  installed.

* **Convenience**: Easily start a fresh R session with
  no packages installed for testing. Quickly run an analysis with package
  dependencies not typical of your workflow. Containers make this easy.

Our aim is to provide up-to-date containers for the current release
and devel versions of Bioconductor, and some older
versions. Bioconductor’s Docker images are stored in Docker Hub; the
source Dockerfile(s) are on Github.

Our release images and devel images are based on the [Rocker Project](https://www.rocker-project.org/) -
[rocker/rstudio](https://github.com/rocker-org/rocker/tree/master/rstudio)
image and built when a Bioconductor release occurs.

<a name="goals"></a>
### Goals for new container architecture

A few of our key goals to migrate to a new set of Docker containers are,

 - to keep the image size being shipped by the Bioconductor team at a
   manageable size.

 - easy to extend, so developers can just use a single image to
   inherit and build their docker image.

 - easy to maintain, by streamlining the docker inheritance chain.

 - Adopt a "best practices" outline so that new community contributed
   docker images get reviewed and follow standards.

 - Adopt a deprecation policy and life cycle for images similar to
   Bioconductor packages.

 - Replicate the Linux build machines (_malbec2_) on the
   `bioconductor/bioconductor_docker:devel` image as closely as
   possible. While this is not fully possible just yet, this image can
   be used by maintainers who wish to reproduce errors seen on the
   Bioconductor Linux build machine and as a helpful debugging tool.

- Make Bioconductor package binaries available to all users of the 
  this container. Users can now install Bioconductor packages as binaries
  by simply doing, `AnVIL::install(<character vector of packages>)`.
  This speeds up installation of Bioconductor packages by avoiding compilation.

  To see the latest status of the Bioconductor binary repository, check with
  `AnVIL:::repository_stats()`.

<a name="current"></a>
## Current Containers

For each supported version of Bioconductor, we provide

- **bioconductor/bioconductor_docker:RELEASE_X_Y**

- **bioconductor/bioconductor_docker:devel**

Bioconductor's Docker images are stored in [Docker Hub](https://hub.docker.com/u/bioconductor/);
the source Dockerfile(s) are in [Github](https://github.com/Bioconductor/bioconductor_docker).

<a name="usage"></a>
## Using the containers

A well organized guide to popular docker commands can be found
[here](https://github.com/wsargent/docker-cheat-sheet). For
convenience, below are some commands to get you started. The following
examples use the `bioconductor/bioconductor_docker:devel` image.

**Note:** that you may need to prepend `sudo` to all `docker`
commands. But try them without first.

**Prerequisites**: On Linux, you need Docker
[installed](https://docs.docker.com/installation/) and on
[Mac](http://docs.docker.com/installation/mac/) or
[Windows](http://docs.docker.com/installation/windows/) you need
Docker Toolbox installed and running.

##### List which docker machines are available locally

	docker images

##### List running containers

	docker ps

##### List all containers

	docker ps -a

##### Resume a stopped container

	docker start <CONTAINER ID>

##### Shell into a running container

	docker exec -it <CONTAINER ID> /bin/bash

##### Shutdown container

	docker stop <CONTAINER ID>

##### Delete container

	docker rm <CONTAINER ID>

##### Delete image

	docker rmi bioconductor/bioconductor_docker:devel

<a name="running"></a>
### Running the container

The above commands can be helpful but the real basics of running a
Bioconductor Docker involves pulling the public image and running the
container.

##### Get a copy of public docker image

	docker pull bioconductor/bioconductor_docker:devel

##### To run RStudio Server:

	docker run -e PASSWORD=<password> \
		-p 8787:8787 \
		bioconductor/bioconductor_docker:devel

You can then open a web browser pointing to your docker host on
port 8787.  If you're on Linux and using default settings, the docker
host is `127.0.0.1` (or `localhost`, so the full URL to RStudio would
be `http://localhost:8787)`. If you are on Mac or Windows and running
`Docker Toolbox`, you can determine the docker host with the
`docker-machine ip default` command.

In the above command, `-e PASSWORD=` is setting the RStudio password
and is required by the RStudio Docker image. It can be whatever you
like except it cannot be `rstudio`.  Log in to RStudio with the
username `rstudio` and whatever password was specified.

If you want to run RStudio as a user on your host machine, in order to
read/write files in a host directory, please [read this](https://github.com/rocker-org/rocker/wiki/Sharing-files-with-host-machine).

NOTE: If you forget to add the tag `devel` or `RELEASE_X_Y` while
using the `bioconductor/bioconductor_docker` image, it will
automatically use the `latest` tag which points to the latest RELEASE
version of Bioconductor.

##### To run R from the command line:

	docker run -it --user rstudio bioconductor/bioconductor_docker:devel R

##### To open a Bash shell on the container:

	docker run -it --user rstudio bioconductor/bioconductor_docker:devel bash

**Note**: The `docker run` command is very powerful and versatile.
For full documentation, type `docker run --help` or visit
the [help page](https://docs.docker.com/reference/run/).

<p class="back_to_top">[ <a href="#top">Back to top</a> ]</p>

<a name="mounting"></a>
### Mounting Additional Volume

One such option for `docker run` is `-v` to mount an additional volume
to the docker image. This might be useful for say mounting a local R
install directory for use on the docker. The path on the docker image
that should be mapped to a local R library directory is
`/usr/local/lib/R/host-site-library`.

The follow example would mount my locally installed packages to this
docker directory. In turn, that path is automatically loaded in the R
`.libPaths` on the docker image and all of my locally installed
package would be available for use.

* Running it interactively,

		docker run \
			-v /home/my-devel-library:/usr/local/lib/R/host-site-library \
			-it \
			--user rstudio \
			bioconductor/bioconductor_docker:devel

  without the `--user rstudio` option, the container is started and
  logged in as the `root` user.

  The `-it` flag gives you an interactive tty (shell/terminal) to the
  docker container.

* Running it with RStudio interface

		docker run \
			-v /home/my-devel-library:/usr/local/lib/R/host-site-library \
			-e PASSWORD=password \
			-p 8787:8787 \
			bioconductor/bioconductor_docker:devel

<a name="dockercompose"></a>

### Using docker-compose

To run the docker-compose file `docker-compose.yaml` from the same
directory,

```
docker-compose up
```

Using `docker-compose`, the user can launch the image with a single
command. The RStudio image is launched at `http://localhost:8787`.

The `docker-composer.yaml` includes settings so that the user doesn't
have to worry about setting the port, password (default is `bioc`), or
the volume to save libraries.

The library path, where all the packages are installed are
automatically configured to use the volume
`$HOME/R/bioconductor_docker/<bioconductor_version>`, in the case of
the Bioconductor version 3.14, it would be
`$HOME/R/bioconductor_docker/3.14`. This location is mounted on to the
path, `/usr/local/lib/R/host-site-library`, which is the first value
in your search path for packages if you check `.libPaths()`.

When the user starts the docker image using `docker-compose`, it will
recognize previously mounted libraries with the apprpriate
bioconductor version, and save users time reinstalling the previously
installed packages.

To add another volume for data, it's possible to modify the
`docker-compose.yml` to include another volume, so all the data is
stored in the same location as well.

```
volumes:
	- ${HOME}/R/bioconductor_docker/3.14:/usr/local/lib/R/host-site-library
	- ${HOME}/R/data:/home/rstudio
```


To run in the background, use the `-d` or `--detach` flag,

```
docker-compose up -d
```

If the image is run in a detached state, the `container-name` can be
used to exec into the terminal if the user wishes `root` access in a
terminal, without using RStudio.

Within the `root` user, additional system dependencies can be
installed to make the image fit the needs of the user.

```
docker exec -it bioc-3.14 bash
```

For more information on how to use `docker-compose`, use the
[official docker-compose reference](https://docs.docker.com/compose/reference/up/).

<p class="back_to_top">[ <a href="#top">Back to top</a> ]</p>

<a name="modify"></a>
## Modifying the images

There are two ways to modify these images:

1. Making changes in a running container and then committing them
   using the `docker commit` command.

		docker commit <CONTAINER ID> <name for new image>

2. Using a Dockerfile to declare the changes you want to make.

The second way is the recommended way. Both ways are
[documented here](https://docs.docker.com/userguide/dockerimages/#creating-our-own-images).

Example 1:

  My goal is to add a python package 'tensorflow' and to install a
  Bioconductor package called 'scAlign' on top of the base docker
  image i.e bioconductor/bioconductor_docker:devel.

  As a first step, my Dockerfile should inherit from the
  `bioconductor/bioconductor_docker:devel` image, and build from
  there. Since all docker images are Linux environments, and this
  container is specifically 'Debian', I need some knowledge on how to
  install libraries on Linux machines.

  In your new `Dockerfile`, you can have the following commands

	# Docker inheritance
	FROM bioconductor/bioconductor_docker:devel

	# Update apt-get
	RUN apt-get update \
		## Install the python package tensorflow
		&& pip install tensorflow		\
		## Remove packages in '/var/cache/' and 'var/lib'
		## to remove side-effects of apt-get update
		&& apt-get clean \
		&& rm -rf /var/lib/apt/lists/*

	# Install required Bioconductor package
	RUN R -e 'BiocManager::install("scAlign")'

  This `Dockerfile` can be built with the command, (note: you can name
  it however you want)

	docker build -t bioconductor_docker_tensorflow:devel .

  This will let you use the docker image with 'tensorflow' installed and
  also `scAlign` package.

	docker run -p 8787:8787 -e PASSWORD=bioc bioconductor_docker_tensorflow:devel

Example 2:

  My goal is to add all the required infrastructure to be able to
  compile vignettes and knit documents into pdf files. My `Dockerfile`
  will look like the following for this requirement,

	# This docker image has LaTeX to build the vignettes
	FROM bioconductor/bioconductor_docker:devel

	# Update apt-get
	RUN apt-get update \
		&& apt-get install -y --no-install-recommends apt-utils \
		&& apt-get install -y --no-install-recommends \
		texlive \
		texlive-latex-extra \
		texlive-fonts-extra \
		texlive-bibtex-extra \
		texlive-science \
		texi2html \
		texinfo \
		&& apt-get clean \
		&& rm -rf /var/lib/apt/lists/*

	## Install BiocStyle
	RUN R -e 'BiocManager::install("BiocStyle")'

  This `Dockerfile` can be built with the command,

	docker build -t bioconductor_docker_latex:devel .

  This will let you use the docker image as needed to build and
  compile vignettes for packages.

	docker run -p 8787:8787 -e PASSWORD=bioc bioconductor_docker_latex:devel

<p class="back_to_top">[ <a href="#top">Back to top</a> ]</p>

<a name="singularity"></a>
## Singularity

The latest `bioconductor/bioconductor_docker` images are available on
Singularity Hub as well. Singularity is a container runtime just like
Docker, and Singularity Hub is the host registry for Singularity
containers.

You can find the Singularity containers collection on this link
https://singularity-hub.org/collections/3955.

These images are particularly useful on compute clusters where you
don't need admin access. You need to have the module `singularity`
installed. See https://singularity.lbl.gov/docs-installation (contact your
IT department when in doubt).

If you have Singularity installed on your machine or cluster are:

Inspect available modules

	module available

If Singularity is available,

	module load singularity

Please check this link for specific usage instructions relevant to Singularity
containers and their usage https://www.rocker-project.org/use/singularity/.

<a name="msft"></a>
## Microsoft Azure Container Instances

If you are a Microsoft Azure user, you have an option to run your
containers using images hosted on Dockerhub.

<p class="back_to_top">[ <a href="#top">Back to top</a> ]</p>

<a name="aci"></a>
## Use Azure Container Instances to run bioconductor images on-demand on Azure

[Azure Container Instances or ACI](https://azure.microsoft.com/en-us/services/container-instances/#features)
provide a way to run Docker containers on-demand in a managed,
serverless Azure environment. To learn more, check out the
documentation
[here](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview).

### Run bioconductor images using ACI

**Prerequisites**:
1. [An Azure account and a
   subscription](https://docs.microsoft.com/en-us/azure/guides/developer/azure-developer-guide#understanding-accounts-subscriptions-and-billing)
   you can create resources in

2. [Azure
   CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

3. Create a [resource
   group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal)
   within your subscription

You can run [Azure CLI or "az cli"
commands](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)
to create, stop, restart or delete container instances running any
bioconductor image - either official images by bioconductor or images
available on [Microsoft Container
Registry](https://hub.docker.com/_/microsoft-bioconductor).  To get
started, ensure you have an Azure account and a subscription or
[create a free account](https://azure.microsoft.com/en-us/free/).

Follow [this
tutorial](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-quickstart)
to get familiar with Azure Container Instances.

To run the bioconductor image hosted on Dockerhub, create a new 
resource group in your Azure subscription. Then
run the following command using Azure CLI. You can customize any or
all of the inputs. This command is adapted to run on an Ubuntu
machine:

	az container create \
		--resource-group resourceGroupName \
		--name aci-bioconductor \
		--image bioconductor/bioconductor_docker \
		--cpu 2 \
		--memory 4 \
		--dns-name-label aci-bioconductor \
		--ports 8787 \
		--environment-variables 'PASSWORD'='bioc'

When completed, run this command to get the fully qualified domain name(FQDN):

	az container show \
		--resource-group resourceGroupName \
		--name aci-bioconductor \
		--query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" \
		--out table

Here we expose port `8787` on this publicly accessible FQDN. You may
have to choose a different "dns-name-label" to avoid conflicts. By
default, the username for RStudio is "rstudio" (similar to the
official bioconductor docker image). Here we set the password for
RStudio to 'bioc' in the environment variable configuration. The
`--cpu` and `--memory` (in GB) configurations can also be customized
to your needs. By default, ACI have 1 cpu core and 1.5GB of memory
assigned.

To learn more about what you can configure and customize when creating
an ACI, run:

	az container create --help

#### Mount Azure File Share to persist analysis data between sessions

To ensure that the data persists between different analysis sessions
when using Azure Container Instances, you can use the feature to
[mount Azure file share to your container instance](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-volume-azure-files). In this example, we will create
an ACI that mounts the "/home/rstudio" directory in RStudio to an
[Azure File Share](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-introduction).

**Prerequisites**:

1. [An Azure account and a subscription](https://docs.microsoft.com/en-us/azure/guides/developer/azure-developer-guide#understanding-accounts-subscriptions-and-billing) you can create resources in

2. [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

3. Create a [resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal)
   within your subscription

Now, run the following Azure CLI commands to:

1. Create an [Azure
   Storage](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&tabs=azure-cli)
   account

2. Create an [Azure file
   share](https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-cli)

3. Get the [storage account
   key](https://docs.microsoft.com/en-us/cli/azure/storage/account/keys?view=azure-cli-latest)

```
# Change these four parameters as needed
ACI_PERS_RESOURCE_GROUP=resourceGroupName
ACI_PERS_STORAGE_ACCOUNT_NAME=storageAccountName
ACI_PERS_LOCATION=eastus
ACI_PERS_SHARE_NAME=fileShareName

# Step1: Create the storage account with the parameters
az storage account create \
	--resource-group $ACI_PERS_RESOURCE_GROUP \
	--name $ACI_PERS_STORAGE_ACCOUNT_NAME \
	--location $ACI_PERS_LOCATION \
	--sku Standard_LRS

# Step2: Create the file share
az storage share create \
	--name $ACI_PERS_SHARE_NAME \
	--account-name $ACI_PERS_STORAGE_ACCOUNT_NAME

# Step3: Get the storage account key
STORAGE_KEY=$(az storage account keys list \
	--resource-group $ACI_PERS_RESOURCE_GROUP \
	--account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
	--query "[0].value" --output tsv)
echo $STORAGE_KEY
```

Here is an example command to mount an Azure file share to an ACI running bioconductor. This command is adapted to run on an Ubuntu machine:

	az container create \
		--resource-group resourceGroupName \
		--name aci-bioconductor-fs \
		--image bioconductor/bioconductor_docker \
		--dns-name-label aci-bioconductor-fs \
		--cpu 2 \
		--memory 4 \
		--ports 8787 \
		--environment-variables 'PASSWORD'='bioc' \
		--azure-file-volume-account-name storageAccountName \
		--azure-file-volume-account-key $STORAGE_KEY \
		--azure-file-volume-share-name fileShareName \
		--azure-file-volume-mount-path /home/rstudio

When completed, run this command to get the fully qualified domain name or FQDN:

	az container show \
		--resource-group resourceGroupName \
		--name aci-bioconductor-fs \
		--query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" \
		--out table

Here we expose port 8787 on this publicly accessible FQDN. You may
have to choose a different "dns-name-label" to avoid conflicts. By
default, the username for RStudio is "rstudio" (similar to the
official bioconductor docker image). Here we set the password for
RStudio to 'bioc' in the environment variable configuration. The
"--cpu" and "--memory" (in GB) configurations can also be customized
to your needs. By default, ACI have 1 cpu core and 1.5GB of memory
assigned. Here, we also mount RStudio "/home/rstudio" directory to a
persistent Azure file share named "fileShareName" in the storage
account specified. When you stop or restart an ACI, this data will not
be lost.

#### Stop, Start, Restart or Delete containers running on ACI

You can run Azure CLI commands to [stop, start,
restart](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-stop-start)
or
[delete](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-quickstart#clean-up-resources)
container instances on Azure. You can find all the commands and
options
[here](https://docs.microsoft.com/en-us/cli/azure/container?view=azure-cli-latest#commands).

Replace `containerName` and `resourceGroupName` in the following CLI commands.

##### Stop the container instance

	az container stop -n containerName -g resourceGroupName


##### Start the container instance

	az container start -n containerName -g resourceGroupName

##### Restart the container instance

	az container restart -n containerName -g resourceGroupName

##### Delete the container instance

	az container delete -n containerName -g resourceGroupName

To not be prompted for confirmation for deleting the ACI:

	az container delete -n containerName -g resourceGroupName -y

To troubleshoot any issues when using Azure Container Instances, try
out the recommendations
[here](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-troubleshooting). For
feedback or further issues, contact us via
[email](mailto:genomics@microsoft.com).

<p class="back_to_top">[ <a href="#top">Back to top</a> ]</p>

<a name="contribute"></a>
## How to Contribute

There is a comprehensive list of best practices and standards on how
community members can contribute images
[here](https://github.com/Bioconductor/bioconductor_docker/blob/master/best_practices.md).

link: https://github.com/Bioconductor/bioconductor_docker/blob/master/best_practices.md

<a name="deprecation"></a>
## Deprecation Notice

For previous users of docker containers for Bioconductor, please note
that we are deprecating the following images. These images were
maintained by Bioconductor Core, and also the community.

<a name="legacy"></a>
### Legacy Containers

These images are NO LONGER MAINTAINED and updated. They will however
be available to use should a user choose. They are not
supported anymore by the Bioconductor Core team.

Bioconductor Core Team: bioc-issue-bot@bioconductor.org

* [bioconductor/devel_base2](https://hub.docker.com/r/bioconductor/devel_base2/)
* [bioconductor/devel_core2](https://hub.docker.com/r/bioconductor/devel_core2/)
* [bioconductor/release_base2](https://hub.docker.com/r/bioconductor/release_base2/)
* [bioconductor/release_core2](https://hub.docker.com/r/bioconductor/release_core2/)

Steffen Neumann: sneumann@ipb-halle.de, Maintained as part of the "PhenoMeNal, funded by Horizon2020 grant 654241"

* [bioconductor/devel_protmetcore2](https://hub.docker.com/r/bioconductor/devel_protmetcore2/)
* [bioconductor/devel_metabolomics2](https://hub.docker.com/r/bioconductor/devel_metabolomics2/)
* [bioconductor/release_protmetcore2](https://hub.docker.com/r/bioconductor/release_protmetcore2/)
* [bioconductor/release_metabolomics2](https://hub.docker.com/r/bioconductor/release_metabolomics2/)

Laurent Gatto: lg390@cam.ac.uk

* [bioconductor/devel_mscore2](https://hub.docker.com/r/bioconductor/devel_mscore2/)
* [bioconductor/devel_protcore2](https://hub.docker.com/r/bioconductor/devel_protcore2/)
* [bioconductor/devel_proteomics2](https://hub.docker.com/r/bioconductor/devel_proteomics2/)
* [bioconductor/release_mscore2](https://hub.docker.com/r/bioconductor/release_mscore2/)
* [bioconductor/release_protcore2](https://hub.docker.com/r/bioconductor/release_protcore2/)
* [bioconductor/release_proteomics2](https://hub.docker.com/r/bioconductor/release_proteomics2/)

RGLab: wjiang2@fredhutch.org

* [bioconductor/devel_cytometry2](https://hub.docker.com/r/bioconductor/devel_cytometry2/)
* [bioconductor/release_cytometry2](https://hub.docker.com/r/bioconductor/release_cytometry2/)

First iteration containers

* bioconductor/devel_base
* bioconductor/devel_core
* bioconductor/devel_flow
* bioconductor/devel_microarray
* bioconductor/devel_proteomics
* bioconductor/devel_sequencing
* bioconductor/devel_metabolomics
* bioconductor/release_base
* bioconductor/release_core
* bioconductor/release_flow
* bioconductor/release_microarray
* bioconductor/release_proteomics
* bioconductor/release_sequencing
* bioconductor/release_metabolomics

<a name="reason"></a>
### Reason for deprecation

The new Bioconductor Docker image `bioconductor/bioconductor_docker`
makes it possible to easily install any package the user chooses since
all the system dependencies are built in to this new image. The
previous images did not have all the system dependencies built in to
the image. The new installation of packages can be done with,

	BiocManager::install(c("package_name", "package_name"))

Other reasons for deprecation:

 - the chain of inheritance of Docker images was too complex and hard
   to maintain.

 - Hard to extend because there were multiple flavors of images.

 - Naming convention was making things harder to use.

 - Images which were not maintained were not deprecated.

<a name="issues"></a>
### Reporting Issues

Please report issues with the new set of images on [GitHub Issues](https://github.com/Bioconductor/bioconductor_docker/issues) or
the [Bioc-devel](mailto:bioc-devel@r-project.org) mailing list.

These issues can be questions about anything related to this piece of
software such as, usage, extending Docker images, enhancements, and
bug reports.

<a name="acknowledgements"></a>
## Acknowledgements

Thanks to the [rocker](https://github.com/rocker-org/rocker) project
for providing the R/RStudio Server containers upon which ours are
based.
