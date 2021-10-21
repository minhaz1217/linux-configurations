# after running the setup bash file
sudo nano /etc/hosts
sudo kubeadm init \
  --pod-network-cidr=192.168.0.0/16 \
  --upload-certs \
  --control-plane-endpoint=kubernates-cluster.minhazul.com


journalctl -xeu kubelet