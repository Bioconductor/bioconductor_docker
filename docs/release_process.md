# Release process of _bioconductor_docker_ images

Notes to capture the release process of the
_bioconductor/bioconductor_docker_ image for RELEASE_3_11.

## General

This release includes a major change in the base hierarchy of the
docker images for bioconductor. The *rocker* project is changing their
base image from `debain` to `ubuntu 18.04` and `ubuntu 20.04`.

To be more consistent with the linux build machine we made the choice
of going with the `rockerdev/rstudio:4.0.0-ubuntu18.04` image. Both
the docker image and the linux build machine will now be running on
ubuntu 18.04.

The rockerdev project is located here,
https://hub.docker.com/r/rockerdev/rstudio/tags

Although the latest Dockerfile's are available, the images under
rocker's dockerhub repo are still missing. To look at the
Dockerfile(s), follow the link
https://github.com/rocker-org/rocker-versioned2/tree/master/dockerfiles

## Issues with rocker images

There is a *permissions* issue with mounted libraries on
`rockerdev/rstudio:4.0.0-ubuntu18.04` image. The group id is given as
a "user" to the mounted volumes. This prevents the `rstudio` user from
getting access to the mounted volume. For bioconductor, this
specifically means that we do not have access to write mounted volumes
to `host-site-library`.

The issue is filed in the rocker github repo here,
https://github.com/rocker-org/rocker-versioned/issues/208.

## Steps to update *devel*

1. Before making any changes to the `master` branch, create a
   RELEASE_3_11 branch with

			 git branch RELEASE_3_11

1. *Update version number* of `BIOCONDUCTOR_DOCKER_VERSION` to latest
   `X.Y.Z`, where `X.Y` represent the Bioconductor version of devel.

	 - For Bioconductor 3.12, the `BIOCONDUCTOR_DOCKER_VERSION` will
       be `3.12.0`.

1. Change the `install.R` file to reflect the latest verison of
   Bioconductor in `BiocManager::install(version='3.12')`.

1. Try to rebuild the image with,

			  docker build -t bioconductor/bioconductor_docker:devel

	 There were a few issues with the system libraries,

	- The following libraries do not have presence in the Ubuntu 18.04
      repository.
		 - libexempi8

	- The following libraries do not INSTALL in the main `apt-get
      install` block, but install in the subsequent block. This might
      be because of missing dependencies. But this is something I have
      to look further into.
		 - libmariadb-dev-compat
		 - libjpeg62-dev

1.  **Validity check**: The final step is installing all the packages
    and to triage which packages DO NOT install on the new devel
    image.

## Steps to update *RELEASE_3_11*

1. Checkout the RELEASE_3_11 branch, `git checkout RELEASE_3_11`.

1. The `BIOCONDUCTOR_DOCKER_VERSION` number of the branch just gets
   incremented in the **Z** by 1. Since it is the same Bioc version as
   the previous devel.

1. Try to rebuild the image with

		   docker build -t bioconductor/bioconductor_docker:RELEASE_3_11 .

	 There were a few issues with the system libraries, (same as the
     above with devel

	- The following libraries do not have presence in the Ubuntu 18.04
      repository.
		 - libexempi8

	- The following libraries do not INSTALL in the main `apt-get
      install` block, but install in the subsequent block. This might
      be because of missing dependencies. But this is something I have
      to look further into.
		 - libmariadb-dev-compat
		 - libjpeg62-dev

1. There are no changes in the `install.R` file.

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

### RELEASE_3_11

List of package failures

- "BridgeDbR": ‘rJava’ is not available for package ‘BridgeDbR’

- "CAMTHC": ‘rJava’ is not available for package ‘CAMTHC’

- "ccfindR": ‘Rmpi’ is not available for package ‘ccfindR’

- "debCAM": ‘rJava’ is not available for package ‘debCAM’

- "ENVISIONQuery":  ‘rJava’ is not available for package ‘ENVISIONQuery’

- "gaggle": ‘rJava’ is not available for package ‘gaggle’

- "gpuMagic": No GPU available

/usr/bin/ld: cannot find -lOpenCL
collect2: error: ld returned 1 exit status
/usr/local/lib/R/share/make/shlib.mk:6: recipe for target 'gpuMagic.so' failed
make: *** [gpuMagic.so] Error 1

- "MSGFplus"

Warning in fun(libname, pkgname) : NAs introduced by coercion
Error: package or namespace load failed for ‘MSGFplus’:
 .onLoad failed in loadNamespace() for 'MSGFplus', details:
  call: if (as.numeric(sub(".*\"\\d\\.(\\d).*", "\\1", javaVersion[1])) <
  error: missing value where TRUE/FALSE needed
Error: loading failed
Execution halted
ERROR: loading failed
* removing ‘/usr/local/lib/R/site-library/MSGFplus’

"mzR"

"paxtoolsr":  ‘rJava’ is not available for package ‘paxtoolsr’

"ReQON": ‘rJava’ is not available for package 'ReQON'

"RGMQL": 'rJava' is not available for package

"rmelting": 'rJava' is not available for package

"sarks": 'rJava'

"SELEX": 'rJava'

"xps": Doesn't install

- "rjava":

Makefile.all:35: recipe for target 'libjri.so' failed
make[2]: *** [libjri.so] Error 1
make[2]: Leaving directory '/tmp/Rtmpjr0Jfo/R.INSTALL582562afe30e/rJava/jri/src'
Makefile.all:19: recipe for target 'src/JRI.jar' failed
make[1]: *** [src/JRI.jar] Error 2
make[1]: Leaving directory '/tmp/Rtmpjr0Jfo/R.INSTALL582562afe30e/rJava/jri'
Makevars:14: recipe for target 'jri' failed
make: *** [jri] Error 2
ERROR: compilation failed for package ‘rJava’

### DEVEL

* Mostly rJava issues

 [1] "BridgeDbR"     "ccfindR"       "debCAM"        "ENVISIONQuery"
 [5] "gaggle"        "gpuMagic"      "MSGFplus"      "paxtoolsr"
 [9] "ReQON"         "RGMQL"         "RMassBank"     "rmelting"
[13] "sarks"         "scAlign"       "SELEX"         "xps"
