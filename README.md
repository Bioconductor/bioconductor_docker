# Docker containers for Bioconductor

[![Docker Build Status](https://img.shields.io/docker/cloud/build/bioconductor/bioconductor_docker.svg)](https://hub.docker.com/r/bioconductor/bioconductor_docker/builds/)

[Docker](https://www.docker.com) allows software to be packaged into
containers: self-contained environments that contain everything
needed to run the software. Containers can be run anywhere
(containers run in modern Linux kernels, but can be run
on Windows and Mac as well using a virtual machine called
[Docker](https://www.docker.com).

Containers can also be deployed in the cloud using
[Amazon Elastic Container Service](https://aws.amazon.com/ecs/)
or [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/).

<a name="top"></a>

- [Quickstart](#quickstart)
- [Why Use Containers](#intro)
  * [Goals for new containers](#goals)
- [Current Containers](#current)
- [Deprecation Notice](#deprecation)
  * [Legacy Containers](#legacy)
  * [Reason for deprecation](#reason)
  * [Reporting issues](#issues)
- [Using Containers](#usage)
  * [Running Containers](#running)
  * [Mounting Additional Volume](#mounting)
- [Modifying Image Container](#modify)
- [Singularity](#singularity)
- [Acknowledgements](#acknowledgements)

<a name="quickstart"></a>

## Quickstart

1. Install Docker

1. Run container with Bioconductor and RStudio

		docker run \
			-e PASSWORD=bioc \
			-p 8787:8787 \
			bioconductor/bioconductor_docker:devel

	This command will run the docker container
	`bioconductor/bioconductor_docker:devel` on your local machine.

	RStudio will be available on your web browser at
	`https://localhost:8787`. The USER is fixed to always being
	`bioc`. The password in the above command is given as `bioc` but
	it can be set to anything. `8787` is the port being mapped between
	the docker container and your host machine. NOTE: password cannot
	be `rstudio`.

	The user is logged into the `bioc` user by default.

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

* **Convenience**: Sometimes you just want a fresh R with
  no packages installed, in order to test something; or
  you typically don't have microarray packages installed
  but suddenly you need to do a microarray analysis.
  Containers make this easy.

Our aim is to provide up-to-date containers for the current release
and devel versions of Bioconductor, and some older
versions. Bioconductor’s Docker images are stored in Docker Hub; the
source Dockerfiles are in Github.

Our release images and devel images are based on the [Rocker Project](https://www.rocker-project.org/) -
[rocker/rstudio](https://github.com/rocker-org/rocker/tree/master/rstudio)
image and built when a Biocondcutor release occurs.

<a name="goals"></a>

### Goals for new container architecture

A few of our key goals to migrate to a new set of Docker containers are,

 - to keep the image size being shipped by the Bioconductor team at a
   manageble size.

 - easy to extend, so developers can just use a single image to
   inherit and build their docker image.

 - easy to maintain, by streamlining the docker inheritence chain.

 - Adapt a "best practices" outline so that new community contributed
   docker images get reviewed and follow standards.

 - Adapt a depreaction policy and life cycle for images similar to
   bioconductor packages.

 - Replicate the linux build machines (malbec2) on the
   `bioconductor/bioconductor_docker:devel` image as closely as
   possible. While this is not fully possible just yet, this image can
   be used by maintainers to reproduce the errors they see on the
   Bioconductor linux build machine and used as a helpful debugging
   tool.

<a name="current"></a>

## Current Containers

For each supported version of Bioconductor, we provide

- **bioconductor/bioconductor_docker:RELEASE_X_Y**

- **bioconductor/bioconductor_docker:devel**

Bioconductor's Docker images are stored in [Docker Hub](https://hub.docker.com/u/bioconductor/);
the source Dockerfiles are in [Github](https://github.com/Bioconductor/bioconductor_docker).

<a name="deprecation"></a>

## Deprecation Notice

For previous users of docker containers for bioconductor, please note
that we are deprecating the following images. These images were
maintained by Bioconductor Core, and also the community.

<a name="legacy"></a>

### Legacy Containers

These images are NO LONGER MAINTAINED and updated. They will however
be available to use should a user choose to use them. They are not
supported anymore by the bioconductor core team.

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

The new Bioconductor docker image `bioconductor/bioconductor_docker`
makes it possible to easily install any package the user chooses since
all the system dependencies are built in to this new image. The
previous images didn't have all the system dependencies built in to
the image. The new installation of packages can be done with,

	BiocManager::install(c("package_name", "package_name"))

Other reasons for deprecation:

 - the chain of inheritance of Docker images was too complex and hard
   to maintain.

 - Hard to extend because there were multiple flavors of images.

 - Naming convention was making things harder to use.

 - Unmaintained images were not deprecated.

<a name="issues"></a>

### Reporting Issues

Please report issues with the new set of images on [Github Issues](https://github.com/Bioconductor/bioconductor_docker/issues) or
the [bioc-devel](mailto:bioc-devel@r-project.org) mailing list.

These issues can be questions about anything related to this piece of
software like, usage, extending the docker images, enhancements, and
bug reports.

<a name="usage"></a>

## Using the containers

A well organized guide to popular docker commands can be found
[here](https://github.com/wsargent/docker-cheat-sheet). For
convenience, below are some commands to get you started. The following
examples use the `bioconductor/bioconductor_docker:devel` image.

**Note:** that you may need to prepend `sudo` to all `docker`
commands. But try without them first.

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
Bioconductor docker involves pulling the public image and running the
container.

##### Get a copy of public docker image

	docker pull bioconductor/bioconductor_docker:devel

##### To run RStudio Server:

	docker run -e PASSWORD=<pickYourPassword> \
		-p 8787:8787 \
		bioconductor/bioconductor_docker:devel

You can then open a web browser pointing to your docker host on
port 8787.  If you're on Linux and using default settings, the docker
host is `127.0.0.1` (or `localhost`, so the full URL to RStudio would
be `http://localhost:8787)`. If you are on Mac or Windows and running
`Docker Toolbox`, you can determine the docker host with the
`docker-machine ip default` command.

In the above command `-e PASSWORD=` is setting the rstudio password
and is required by the rstudio docker image. It can be whatever you
like except it cannot be `rstudio`.  Log in to RStudio with the
username `rstudio` and whatever password was specified.

If you want to run RStudio as a user on your host machine, in order to
read/write files in a host directory, please [read this](https://github.com/rocker-org/rocker/wiki/Sharing-files-with-host-machine).

NOTE: if you forget to add the tag `devel` or `RELEASE_X_Y` while
using the `bioconductor/bioconductor_docker` image, it will
automatically use the `latest` tag which points to the latest RELEASE
version of Bioconductor.

##### To run R from the command line:

	docker run -it --user bioc bioconductor/bioconductor_docker:devel R

##### To open a Bash shell on the container:

	docker run -it --user bioc bioconductor/bioconductor_docker:devel bash

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
			--user bioc \
			bioconductor/bioconductor_docker:devel

  without the `--user bioc` option, the container is started and
  logged in as the `root` user.

  The `-it` flag gives you an interactive tty (shell/terminal) to the
  docker container.

* Running it with RStudio interface

		docker run \
			-v /home/my-devel-library:/usr/local/lib/R/host-site-library \
			-e PASSWORD=password \
			-p 8787:8787 \
			bioconductor/bioconductor_docker:devel

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
  there. Since all docker images are linux enviroments, and this
  container is specificlly 'debian', I need some knowledge on how to
  install libraries on linux machines.

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

  This will let you use the docker image with tensorflow installed and
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


## Singularity

The latest `bioconductor/bioconductor_docker` images are available on
Singularity Hub as well. Singularity is a container runtime just like
docker, and Singularity Hub is the host registry for Singularity
containers.

You can find the Singularity containers collection on this link
https://singularity-hub.org/collections/3955.

These images are particularly useful on compute clusters where you
don't need admin access. You need to have the module `singularity`
installed https://singularity.lbl.gov/docs-installation (Contact your
IT department whn in doubt).

Some useful instructions, if you have singularity installed on your
machine or cluster are:

Inspect available modules

	module available

If singularity is available,

	module load singularity

As far as usage of the containers go, please check the link:
https://singularity-hub.org/collections/3955/usage, this will give
usage instructions relevant to the singularity containers.

## Acknowledgements

Thanks to the [rocker](https://github.com/rocker-org/rocker) project
for providing the R/RStudio Server containers upon which ours are
based.
