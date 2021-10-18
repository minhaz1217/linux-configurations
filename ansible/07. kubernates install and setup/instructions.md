# got help from 
https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/#step-2-3-initialize-the-kubernetes-cluster-with-kubeadm-using-the-below-code-applicable-only-on-master-node

# 1. Test the connection
ansible -i hosts all -m ping

# 2. run for the master
ansible-playbook -i master master-playbook.yml --extra-vars "node_ip=192.168.50.101"

# 3. Run for the workers
ansible-playbook -i worker1 worker-playbook.yml --extra-vars "node_ip=192.168.50.103"
ansible-playbook -i worker2 worker-playbook.yml --extra-vars "node_ip=192.168.50.104"









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