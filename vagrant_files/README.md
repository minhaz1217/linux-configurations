# Install vagrant inside wsl2

## run inside WSL 2
## check https://www.vagrantup.com/downloads for more info
`curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -`

`sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"`


`sudo apt-get update && sudo apt-get install vagrant`


## append those two lines into ~/.bashrc
`echo 'export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"' >> ~/.bashrc`

`echo 'export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox"' >> ~/.bashrc`

## now reload the ~/.bashrc file
source ~/.bashrc

## Run inside wsl2
`vagrant plugin install virtualbox_WSL2`


## 
## Go to Windows user's dir from WSL
`cd /mnt/c/Users/<my-user-name>/`

## Create a project dir
`mkdir -p projects/vagrant-demo`

`cd projects/vagrant-demo`

## Create a Vagrantfile using Vagrant CLI
`vagrant init hashicorp/bionic64`

`ls -l Vagrantfile`

## Start a VM using Vagrantfile
`vagrant up`

## Login to the VM
### (password is 'vagrant')
`vagrant ssh`
