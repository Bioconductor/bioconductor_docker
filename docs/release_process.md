# Release process of _bioconductor_docker_ images

Notes to capture the release process of the
_bioconductor/bioconductor_docker_ image for RELEASE_3_13.

## General

The image is based on `rocker/rstudio:4.1.0`, which is based on
`ubuntu 20.04`

The rockerdev project is located here,
https://hub.docker.com/r/rockerdev/rstudio/tags

Although the latest Dockerfile's are available, the images under
rocker's dockerhub repo are missing. To look at the Dockerfile(s),
follow the link
https://github.com/rocker-org/rocker-versioned2/tree/master/dockerfiles

## Steps to update *devel*

1. Before making any changes to the `master` branch, create a
   RELEASE_3_13 branch with

			 git branch RELEASE_3_13

1. *Update version number* of `BIOCONDUCTOR_DOCKER_VERSION` to latest
   `X.Y.Z`, where `X.Y` represent the Bioconductor version of devel.

	 - For Bioconductor 3.14, the `BIOCONDUCTOR_DOCKER_VERSION` will
       be `3.14.0`.

1. Change the `install.R` file to reflect the latest verison of
   Bioconductor in `BiocManager::install(version='3.14')`.

1. Try to rebuild the image with,

			  docker build -t bioconductor/bioconductor_docker:devel

	 There were a few issues with the system libraries,

	- The following libraries do not INSTALL in the main `apt-get
      install` block, but install in the subsequent block. This might
      be because of missing dependencies. But this is something I have
      to look further into.
		 - libmariadb-dev-compat
		 - libjpeg62-dev

1. Make sure the `docker-compose.yml` file has the correct values as well in both places.

2.  **Validity check**: The final step is installing all the packages
    and to triage which packages DO NOT install on the new devel
    image.

## Steps to update *RELEASE_3_13*

1. Checkout the RELEASE_3_13 branch, 

		`git checkout RELEASE_3_11`

1. The `BIOCONDUCTOR_DOCKER_VERSION` number of the branch just gets
   incremented in the **Z** by 1. Since it is the same Bioc version as
   the previous devel.
   
1. Make sure the correct rocker/rstudio:<version> is being used. If
   there are doubts about this check the
   http://bioconductor.org/checkResults/devel/bioc-LATEST/ (devel) and
   http://bioconductor.org/checkResults/release/bioc-LATEST/ (release)
   versions of R on the build machines. They should match.

1. Try to rebuild the image with

		   docker build -t bioconductor/bioconductor_docker:RELEASE_3_13 .

	 There were a few issues with the system libraries, (same as the
     above with devel

	- The following libraries do not INSTALL in the main `apt-get
      install` block, but install in the subsequent block. This might
      be because of missing dependencies. But this is something I have
      to look further into.
		 - libmariadb-dev-compat
		 - libjpeg62-dev

1. There are no changes in the `install.R` file, except to install
   BiocManager 3.13

1. Remove the following lines in the Dockerfile , i.e, no devel build
   variables in the RELEASE branch

		 # DEVEL: Add sys env variables to DEVEL image
		 RUN curl -O http://bioconductor.org/checkResults/devel/bioc-LATEST/Renviron.bioc \
				 && cat Renviron.bioc | grep -o '^[^#]*' | sed 's/export //g' >>/etc/environment \
				 && cat Renviron.bioc >> /usr/local/lib/R/etc/Renviron.site \
				 && rm -rf Renviron.bioc

1. **Validity check** : Install packages on the new image and triage
   which packages DO NOT install. Set `option(Ncpus=<more than
   default>)` for faster installation.

## Create singularity images as final step.

1. In the newly created RELEASE_X_Y branch, rename the file
   `Singularity` to `Singularity.RELEASE_X_Y`.

1. Inside the file, change the lines, `From:
   bioconductor/bioconductor_docker:devel` to `From:
   bioconductor/bioconductor_docker:RELEASE_X_Y`. Below is example for
   RELEASE_3_11.

		  Bootstrap: docker
		  From: bioconductor/bioconductor_docker:RELEASE_3_11

## Code to test installation of all packages

The following code should be run to install all packages (running on a
machine with 16 cores)

```
options(Ncpus=14)

installed <- rownames(installed.packages())
biocsoft <- available.packages(repos = BiocManager::repositories()[["BioCsoft"]])

## Packages which failed to install on docker image
to_install <- rownames(biocsoft)[!rownames(biocsoft) %in% installed]

BiocManager::install(to_install)
```

# Addendum - Github Actions

1. Github actions should be removed from the newly created
   `RELEASE_X_Y` branch. Dockerhub does the builds for the RELEASE_X_Y
   branches as they are "stable". Push to the image with an updated
   `BIOCONDUCTOR_DOCKER_VERSION` number will trigger build to the
   RELEASE_X_Y branch.

2. Under the current structure, the way we build the image for the
   `bioconductor/bioconductor_docker:devel` image is via Github
   actions. The action pulls the `rocker/r-ver:<tag>` image and the
   `rocker:rstudio:<tag>`, builds both of those images on an instance,
   then builds the `bioconductor/bioconductor_docker:devel` image on
   the latest version of those build images.

	 - The `devel` image is updated weekly at 3pm on Friday.

	 - To replace with the `rockerdev` image stack, we need to be able
       to get the github repos and Dockerfiles of the latest
       `rockerdev/r-ver` and `rockerdev/rstudio` images build on
       Ubuntu 18.04.

3. **TODO**: This github action needs to be edited to reflect the
   latest changes through rocker.

4. **Validity check**: To check validity of the weekly build, it'll be
   useful to temporarily set the CRON job on the scheduled github
   action to run every 3 hours to debug if needed and change back to
   the weekly cycle once it is done.

## Failing packages

