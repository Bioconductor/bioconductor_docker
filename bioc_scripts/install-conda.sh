wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -b -p /opt/conda \
    && rm -f ~/miniconda.sh

## https://docs.anaconda.com/anaconda/install/multi-user/ -
## Multi user conda installation -
## Install conda for both rstudio user and root -
## make sure the "env" is available to both users
groupadd condausers
chgrp -R condausers /opt/conda
chmod 770 -R /opt/conda

## Add rstudio to condausers group
adduser rstudio condausers

## Make sure conda works on "rstudio" user as well
cat <<"EOF">>/etc/bash.bashrc
PATH=/opt/conda/bin:$PATH
EOF
