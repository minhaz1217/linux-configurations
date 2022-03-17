# This playbook installs dotnet 3.1 in the connected hosts


## Run the playbook using.
`sudo ansible-playbook -i hosts -e 'ansible_ssh_private_key_file="/mnt/c/Users/HA HA/amazon_key"'  dotnet_install_and_setup.yml`