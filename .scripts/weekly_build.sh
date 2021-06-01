set -e
echo "Build bioconductor_docker image"

###############################################
## Step 0: Set up variables and clone
## Rocker repo
ROCKER_REPO=https://github.com/rocker-org/rocker-versioned2

## git clone rocker
git clone --depth 1 $ROCKER_REPO

###############################################
## 1. docker build rocker r-ver: repo

cd rocker-versioned2/

#################################################################
## NOTE: This needs to change when it comes time for RELEASE_3_12
##
## The R_VERSION in the dockerfile for r-ver needs to be changed to
## 'ENV R_VERSION=patched' during this release cycle.
##
## This will be done with the help of "sed"

#sed -r -i 's/ENV R_VERSION=4.0.2/ENV R_VERSION=patched/g' dockerfiles/Dockerfile_r-ver_4.0.2


#################################################################

docker build -t rocker/r-ver:4.1.0 -f dockerfiles/Dockerfile_r-ver_4.1.0 .

###############################################
## 2. docker build rocker rstudio:devel

#cd $GITHUB_WORKSPACE; cd rocker-versioned2/#rstudio

echo "*** Building rocker/rstudio:4.1.0 *** \n"

docker build -t rocker/rstudio:4.1.0 -f dockerfiles/Dockerfile_rstudio_4.1.0 .

###############################################
## 3. docker build bioconductor_docker:devel

cd $GITHUB_WORKSPACE;

echo "*** Building bioconductor/bioconductor_docker *** \n"

## increment version number with sed
sed -r -i 's/(^ARG BIOCONDUCTOR_PATCH=)([0-9]+)$/echo "\1$((\2+1))"/ge' Dockerfile

## Git login
git config user.email "bioc-issue-bot@bioconductor.org"
git config user.name "bioc-docker-bot"

## Git commit
git commit -am "Weekly version bump and rebuild of bioconductor_docker:devel"

## docker build, login and push
docker build -t bioconductor/bioconductor_docker:devel .

docker login --username=$DOCKER_USERNAME --password=$DOCKER_PASSWORD

docker push bioconductor/bioconductor_docker:devel

## Finish
echo "Done"

