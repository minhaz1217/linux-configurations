# Test connection
ansible linux_hosts -m ping

# Run with verbose on
anible linux_hosts -vvvv -m ping

# pass in environment variables
ansible-playbook -i hosts github.yml -e "githubuser=arbabname" -e "githubpassword=xxxxxxx"