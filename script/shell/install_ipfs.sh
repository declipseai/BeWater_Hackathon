$bash

wget https://dist.ipfs.tech/kubo/v0.28.0/kubo_v0.28.0_linux-amd64.tar.gz
tar -xvzf kubo_v0.28.0_linux-amd64.tar.gz
cd kubo
sudo bash install.sh
cd ..
rm kubo_v0.28.0_linux-amd64.tar.gz
rm -rf kubo

ipfs --version
IPFS_PATH=ipfs-data ipfs init