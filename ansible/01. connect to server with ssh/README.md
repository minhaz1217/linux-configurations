# Conenct with .ppk file
## Remember to make the sure permission of the "public_key.ppk" file 

<br>

## if you want to make it read only by you

`chmod 400 keys/public_key.ppk`

<br> 

## if you want to make it read and write only by you
`chmod 600 keys/public_key.ppk`

## And check permission with 
`ls -l keys`

## test the connection to the server with
`ansible all -m ping`

# Connect with public file for amazon ec2
## Add the ip in the hosts file using
`nano hosts`


## use this command to ping with machine
`ansible -i hosts  -e 'ansible_ssh_private_key_file="/mnt/c/Users/HA HA/i-00f3bae76656f2a63-65.1.134.139"' amazon -m ping`

### Here my key was passed with the environment variable `ansible_ssh_private_key_file` and the host is selected by `amazon` we use a module named `ping` to check that our connection is ok.

### If any problem occurs like even after changing the file's permission to 400, then try removing the extension of the private key file or use `sudo` to connect

## If successful it should look like this
![Successful ping](https://raw.githubusercontent.com/minhaz1217/linux-configurations/master/ansible/01.%20connect%20to%20server%20with%20ssh/images/successful_ping_request.png)