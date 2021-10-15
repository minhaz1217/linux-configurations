# got help from 
https://buildvirtual.net/deploy-a-kubernetes-cluster-using-ansible/

# 2. Test the connection
ansible -i hosts all -m ping

# 3. Generate ssh key keep the name id_rsa
ssh-keygen -b 4096

# 4. run this command to create user
ansible-playbook -i hosts create-users.yml

# 5. run this command to install kubernates
ansible-playbook -i hosts install-k8s-docker.yml

# 6. run this command to Creating a Kubernetes Cluster Master Node
ansible-playbook -i hosts master.yml

kubectl get nodes

# 7. 
ansible-playbook -i hosts join-workers.yml
kubectl get nodes

# https://computingforgeeks.com/deploy-kubernetes-cluster-on-ubuntu-with-kubeadm/