echo "Build bioconductor_docker image"

###############################################
## Step 0: Set up variables and clone
## Rocker repo
ROCKER_REPO=https://github.com/rocker-org/rocker-versioned

## git clone rocker
git clone --depth 1 $ROCKER_REPO

###############################################
## 1. docker build rocker r-ver:devel repo

cd rocker-versioned/r-ver/

docker build -t rocker/r-ver:devel -f  devel.Dockerfile .

###############################################
## 2. docker build rocker rstudio:devel

cd $GITHUB_WORKSPACE; cd rocker-versioned/rstudio

echo "*** Building rocker/rstudio *** \n"

docker build -t rocker/rstudio:devel -f  devel.Dockerfile .

###############################################
## 3. docker build bioconductor_docker:devel

cd $GITHUB_WORKSPACE;

echo "*** Building bioconductor/bioconductor_docker *** \n"

## increment version number with sed
sed -r -i 's/(^ARG BIOCONDUCTOR_DOCKER_VERSION=[0-9]+\.[0-9]+\.)([0-9]+)$/echo "\1$((\2+1))"/ge' Dockerfile

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

