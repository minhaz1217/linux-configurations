# got help from 
https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/#step-2-3-initialize-the-kubernetes-cluster-with-kubeadm-using-the-below-code-applicable-only-on-master-node

# 1. Test the connection
ansible -i hosts all -m ping

# 2. run for the master
ansible-playbook -i hosts master master-playbook.yml --extra-vars "node_ip=192.168.50.101"

# 3. Run for the workers
ansible-playbook -i hosts worker-playbook.yml --extra-vars "node_ip=192.168.50.103 target=worker1"
ansible-playbook -i hosts worker-playbook.yml --extra-vars "node_ip=192.168.50.104 target=worker2"

## ------------- Errors -----------
# if stops at |Initialize the Kubernetes cluster using kubeadm|
then login to the host and run this
sudo kubeadm init --apiserver-advertise-address="192.168.50.101" --apiserver-cert-extra-sans="192.168.50.101"  --node-name k8s-master --pod-network-cidr=192.168.0.0/16 --v=5

if this throws a error where it says *** file already exists
sudo rm /etc/kubernetes/manifests/kube-apiserver.yaml
sudo rm /etc/kubernetes/manifests/kube-controller-manager.yaml
sudo rm /etc/kubernetes/manifests/kube-scheduler.yaml
sudo rm /etc/kubernetes/manifests/etcd.yaml

then run the 
sudo kubeadm init --apiserver-advertise-address="192.168.50.101" --apiserver-cert-extra-sans="192.168.50.101"  --node-name k8s-master --pod-network-cidr=192.168.0.0/16 --v=5



# if running kubectl get nodes throws the *** server was refused connection
kubectl get nodes
sudo -i
swapoff -a
exit
strace -eopenat kubectl version


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