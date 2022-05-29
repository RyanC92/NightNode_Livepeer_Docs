# Overview

This guide will walk you through the Livepeer Orchestrator & Transcoder setup using Docker. The installation will be based on Ubuntu Linux and includes the following steps:

1. Docker
2. NVIDIA Drivers
3. NVIDA Driver Patch
4. NVIDIA Container Runtime
5. Livepeer Setup
6. Multiple Modes to Run Livepeer
7. Prometheus Monitoring for Livepeer
8. Grafana Reporting for Livepeer

All docker images used in this guide are published to Docker Hub. 

Please review the Livepeer Architecture for a better understanding of the Livepeer Network [links](#Reference+Documentation).

# Prerequisites

This guide assumes you are familiar with installing software on unix-based systems. You should be comfortable with command-line syntax, Networking, Firewalls, and containerized environments. You dont have to be an expert, but troubleshooting skills will come in handy.

This guide was developed using:
- Ubuntu Linux 20.04
- Docker 20.10.14
- NVIDIA-SMI 510.60.02
  - Driver Version: 510.60.02
  - CUDA Version: 11.6  
- Livepeer 0.5.29

Have access to an Arbitrum RPC URL. This is required to run Livepeer. You can use any RPC URL, but some of the commonly used services are Infura, Alchemy, or Self Hosted.

Lastly, You should be familiar with the Livepeer configuration, deployment, and running of an Orchestrator/Transcoder. I'd recommend reviewing the Linux and Windows installation guides prior to attempting to run Livepeer in Docker. 


# STEP 1: Install Docker

We will follow the prescribed steps found on [docker.com](https://docs.docker.com/engine/install/ubuntu/). All of the steps in this section will require root access. I'd advise logging in as root, but the use of sudo is sufficient.

remove older version of docker

As the root user (or sudo), run the following:
```
apt-get remove docker docker-engine docker.io containerd runc
```

install the Docker repo for Ubuntu

As the root user (or sudo), run the following:
```
apt-get update

apt-get install ca-certificates curl wget net-tools net-tools sysstat gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Once the repo is installed... update the repo, install docker, enable docker to autostart on boot

As the root user (or sudo), run the following:
```
apt-get update

apt-get install docker-ce docker-ce-cli containerd.io

systemctl --now enable docker
```

This document is *NOT* meant to be a guide on Linux or Securing Linux applications. Having said that, I would advise running the docker containers as a non-root user. 

To enable this, we will need to create a new user and assign it to the docker group. For this installation, we will use the user: livepeer

As the root user (or sudo), run the following:
``` 
mkdir /home/livepeer
useradd -g docker livepeer
chown -Rf livepeer.docker /home/livepeer
usermod -d /home/livepeer livepeer
usermod -s /bin/bash livepeer
```

#  STEP 2: Install NVIDIA Docker

This section walks through the steps needed to install NVIDIA Drivers on Ubuntu and ensure X11 graphics mode is off by default (optional).

As the root user (or sudo), run the following:
```
apt-get install -y nvidia-driver-510

# Optional Step
systemctl set-default multi-user
```

#  STEP 3: Patch NVIDIA Driver

This step will download the NVIDA patches required to run Livepeer. You can read more about it on [Github](https://raw.githubusercontent.com/keylase/nvidia-patch).


As the root user (or sudo), run the following:
```
wget https://raw.githubusercontent.com/keylase/nvidia-patch/master/patch.sh
chmod a+x ./patch.sh
./patch.sh

wget https://raw.githubusercontent.com/keylase/nvidia-patch/master/patch-fbc.sh
chmod a+x ./patch-fbc.sh
./patch-fbc.sh

```

#  STEP 4: Install NVIDIA Container Runtime

This section walks through the steps needed to install NVIDIA Docker Runtime. The steps required are: install the NVIDIA Docker repo, update the repo, install nvidia-docker2, restart docker, and run the docker NVIDIA-SMI test container.

As the root user (or sudo), run the following:
```
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)       && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg       && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list |             sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |             sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
apt-get update
apt-get install -y nvidia-docker2
systemctl restart docker
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

## Verification Steps 

In order to have a smooth transition to Livepeer on Docker, several key verification steps are needed. 

Please run the following commands to make sure you Docker/Livepeer environment meets the environment requirements.

If any of the following steps fail - YOU MUST STOP HERE! Please revisit the Livepeer resources to ensure a NON-docker enviroment can run on this server before proceeding. 

*If the version numbers don't match, you should be able to proceed assuming the Livepeer configuration works on this server without Docker.*

This detects the docker version. This value may not be exact. If it does not match, you can proceed. The older the version, the more likely to have problems.

``` docker -v ```

  - **output** *Docker version 20.10.14, build a224086*

``` docker info```

  - Look for the **Runtimes** section and ensure you see the nvidia entry listed
  - *Runtimes: runc io.containerd.runc.v2 io.containerd.runtime.v1.linux **nvidia** .*

``` nvidia-smi```
  
  The NVIDIA-SMI output should contain:
  
  - *NVIDIA-SMI 510.60.02* 
  - *Driver Version: 510.60.02*
  - *CUDA Version: 11.6*

```sudo docker run --gpus all nvidia/cuda:11.0-base ```

  - should have the same output as nvidia-smi
  - if this fails, please review your NVIDIA / Docker setup.

#  STEP 5: Livepeer Setup

In this section, we will review the livepeer configuration file. I'd encourage you to review all the possible Livepeer configuration settings. For this guide, we will specifically configure 2 use cases:

1. Single Container combined Orchestrator/Transcoder
2. One Container for Standalone Orchestrator and One Container for Remote Transcoder

## Livepeer Configuration Prep

All configuration for livepeer will be stored in one folder. The livepeer.conf file, ETH keystore/secret, and arbitrum files will stored in this configuration folder, and the necessary files to run Grafana,Prometheus, and Nvidia GO Exporter. 

The final folder structure will look like this:

```
/home/livepeer/
 |-combined
 |-docker_volumes
 |---combined
 |-----arbitrum-one-mainnet
 |-------keystore
 |---eth-acct-creation
 |-----arbitrum-mainnet
 |-------keystore
 |---monitor
 |-----grafana
 |-----nvidia
 |-----prometheus
 |-------config
 |-------data
 |---standalone
 |-----orch
 |-------arbitrum-one-mainnet
 |---------keystore
 |-----trans
 |-------offchain
 |-monitor
 |-standalone
 |---orch
 |---trans
```

*****PROTECT THESE FILES AND FOLDER!!!!*****

*****THEY CONTAIN SENSTIVE INFO!!!*****

First, create all the directories

```
# Store the files to run Docker - Eth account creation
mkdir -p /home/livepeer/eth-acct-creation/

# Store the files to run Docker Use Case 1
mkdir -p /home/livepeer/combined/

# Store the files to run Docker Use Case 2
mkdir -p /home/livepeer/standalone/

# Store the files to run Docker Monitoring (both use cases)
mkdir -p /home/livepeer/monitor/

# Store all container data files after restarts.
mkdir -p /home/livepeer/docker_volumes/eth-acct-creation/arbitrum-mainnet/keystore/
mkdir -p /home/livepeer/docker_volumes/grafana
mkdir -p /home/livepeer/docker_volumes/prometheus/config
mkdir -p /home/livepeer/docker_volumes/prometheus/data
mkdir -p /home/livepeer/docker_volumes/standalone/trans/offchain
```

## Create a ETH Account via Livepeer

Run this command to generate the ETH account JSON file.

Please note: step will prompt you for a passphrase 3 times. Promt 1 & 2 are for your ETH account passphrase. The 3 prompt is for your keystore passphrase. 

In this example I used: ```LivePeerRocks!``` For ALL 3 prompts. You should NOT do this in a production environment.

Save the passphrase because they are needed for the Livepeer configuration.

As the root user:
```
cd /home/livepeer/eth-acct-creation/
touch create_eth_acct.sh
chmod a+x create_eth_acct.sh
```

Edit the create_eth_acct.sh and put the following contents:

```
docker run --rm -it -v /home/livepeer/docker_volumes/eth-acct-creation:/root/.lpData/ livepeer/go-livepeer:0.5.29 -orchestrator=true -orchSecret=LivePeerRocks! -network=arbitrum-one-mainnet -ethUrl=https://arb1.arbitrum.io/rpc -ethPassword=LivePeerRocks! -v=6
```

As the root user - run this command to create the eth account and follow the steps to generate the account.

```
./create_eth_acct.sh

```
The output will look like this:

```
I0513 13:38:36.198424       1 livepeer.go:274] ***Livepeer is running on the arbitrum-mainnet network***
I0513 13:38:36.198959       1 livepeer.go:287] Creating data dir: /root/.lpData/arbitrum-mainnet
I0513 13:38:36.210318       1 db.go:377] Initialized DB node
I0513 13:38:36.779685       1 accountmanager.go:51] No Ethereum account found. Creating a new account
I0513 13:38:36.780276       1 accountmanager.go:52] This process will create a new Ethereum account for this Livepeer node
I0513 13:38:36.780596       1 accountmanager.go:53] Please enter a passphrase to encrypt the Private Keystore file for the Ethereum account.
I0513 13:38:36.780897       1 accountmanager.go:54] This process will ask for this passphrase every time it is launched
I0513 13:38:36.781209       1 accountmanager.go:55] (no characters will appear in Terminal when the passphrase is entered)
Passphrase: 
Repeat passphrase: 
I0513 13:38:50.252913       1 accountmanager.go:72] Using Ethereum account: 0x1483C047d9fE54a26356B82fcAc79209f4c793Ec
I0513 13:38:51.010233       1 accountmanager.go:106] Unlocked ETH account: 0x1483C047d9fE54a26356B82fcAc79209f4c793Ec
I0513 13:38:51.013278       1 client.go:195] Controller: 0x0000000000000000000000000000000000000000
E0513 13:38:52.049777       1 client.go:199] Error getting LivepeerToken address: execution reverted
E0513 13:38:52.050790       1 livepeer.go:510] Failed to set gas info on Livepeer Ethereum Client: execution reverted
I0513 13:38:52.051839       1 db.go:382] Closing DB
```

Verify the ETH account JSON was created.

As the root user:
```
ls /home/livepeer/docker_volumes/arbitrum-one-mainnet/keystore/*
```

You will see output like this:

```
/home/livepeer/docker_volumes/arbitrum-one-mainnet/keystore/UTC--2022-05-13T13-38-48.305596618Z--1483c047d9fe54a26356b82fcac79209f4c793ec
```

The file name starting with UTC--[DATE]--[ETH ACCOUNT ADDR]

```
1483c047d9fe54a26356b82fcac79209f4c793ec
```

This will be the ETH Account saved for your Livepeer configuration. 

The ETH Account will be as follows. 
*Take note of the 0x that was appended to the front of the account.*

```
0x1483c047d9fe54a26356b82fcac79209f4c793ec
```

Copy the ETH account JSON file to the combined and standalone orchestrator docker_volume folders. We will be using this ETH account address for Use Case 1 and 2 Orchestrator configuration.

```
cp /home/livepeer/docker_volumes/eth-acct-creation/arbitrum-mainnet/keystore/YOUR_UTC_FILE.json /home/livepeer/docker_volumes/combined/arbitrum-mainnet/keystore

ls -al /home/livepeer/docker_volumes/combined/arbitrum-mainnet/keystore/*

cp /home/livepeer/docker_volumes/eth-acct-creation/arbitrum-mainnet/keystore/YOUR_UTC_FILE.json /home/livepeer/docker_volumes/standalone/orch/arbitrum-mainnet/keystore

ls -al /home/livepeer/docker_volumes/standalone/orch/arbitrum-mainnet/keystore/*
```

#  STEP 5: Multiple Modes to Run Livepeer  

## Configure Combined Orchestrator/Transcoder

For our first use case, we will create the combined Orchestrator / Transcoder livepeer.conf file.
```
touch /home/livepeer/docker_volumes/combined/livepeer.conf
```

modify the livepeer.conf and add the follow settings:

```
v 6
monitor true
orchestrator true
transcoder true 
network arbitrum-one-mainnet
ethUrl https://arb1.arbitrum.io/rpc
ethPassword /root/.lpData/eth_secret.txt

# Modify this to your ETH account. looks like: 0x5210d3c241ff6096cafbe673c303ee556b2af884
ethAcctAddr <YOUR ETH ACCOUNT ADDRESS> 

# Modify this for your server IP. I used 0.0.0.0
cliAddr <YOUR SERVER IP>:7935

# Modify this for your server IP. I used 0.0.0.0
serviceAddr <YOUR SERVER IP>:8935

orchSecret /root/.lpData/orch_secret.txt
nvidia all
pricePerUnit 900
maxSessions 10
autoAdjustPrice false
```

## Run The Orchestrator/Transcoder!

create a run_livepeer.sh and stop_livepeer.sh script

```
touch /home/livepeer/combinded/run_livepeer.sh 

touch /home/livepeer/combinded/stop_livepeer.sh 
```

Modify the run_livepeer.sh file and add the following:

```
docker run --rm --gpus all --name combined-orchestrator --network livepeer -p 8935:8935 -p 7935:7935 -d -v /home/livepeer/docker_volumes/combined/:/root/.lpData/ livepeer/go-livepeer:0.5.29 -config=/root/.lpData/livepeer.conf
```

Modify the stop_livepeer.sh file and add the following:

```
docker stop combined-orchestrator

```

Change ownership and permissions

```
chown -Rf livepeer.docker /home/livepeer
chmod a+x /home/livepeer/combinded/*.sh

```

Run the run_livepeer.sh file

```
sudo su - livepeer
cd /home/livepeer/combinded/
./run_livepeer.sh
```
### View container logs

```docker logs combineded-orchestrator -f```

### Stop The container 

```docker stop comdineded-orchestrator```

## Configure Standalone Orchestrator 

[livepeer_orchestrator.conf](https://github.com/NightWolf92/NightNode_Livepeer_Docs/blob/main/Install/Linux/livepeer_orchestrator.conf) 

## Configure Standalone Transcoder 

[livepeer_transcoder.conf](https://github.com/NightWolf92/NightNode_Livepeer_Docs/blob/main/Install/Linux/livepeer_transcoder.conf) 


## Run The Standalone Orchestrator!

 ```docker run --rm  --name livepeer-orch -p 8935:8935 -p 7935:7935 -d -v /home/livepeer/orch-orch/:/root/.lpData/ livepeer/go-livepeer:0.5.29 -config=/root/.lpData/livepeer.conf```

## Run The Standalone Transcoder!

 ```docker run --rm --gpus all --name livepeer-trans -p 8935:8935 -p 7935:7935 -d -v /home/livepeer/orch-trans/:/root/.lpData/ livepeer/go-livepeer:0.5.29  -config=/root/.lpData/livepeer.conf```

# STEP 7: Prometheus Monitoring for Livepeer

 ```docker run --rm --gpus all --name livepeer-trans -p 8935:8935 -p 7935:7935  -d -v /home/livepeer/orch-trans/:/root/.lpData/ livepeer/go-livepeer:0.5.29  -config=/root/.lpData/livepeer.conf```

# STEP 8: Grafana Reporting for Livepeer Monitoring Livepeer

  ```docker run --rm --gpus all --name livepeer-trans -p 8935:8935 -p 7935:7935 -d -v /home/livepeer/orch-trans/:/root/.lpData/ livepeer/go-livepeer:0.5.29  -config=/root/.lpData/livepeer.conf```

# Reference Documentation
- [Livepeer.org](https://livepeer.org)
- [Monitoring Livepeer Forum](https://forum.livepeer.org/t/guide-transcoder-monitoring-with-prometheus-grafana/1225)
  - Monitoring Example Files
    - [Prometheus Config](https://github.com/0xVires/livepeer-grafana-monitoring/blob/main/prometheus.yml)
    - [NVIDIA Exporter](https://raw.githubusercontent.com/0xVires/livepeer-grafana-monitoring/main/nvidia_exporter.go)
    - [Grafana Dashboards](https://github.com/0xVires/livepeer-grafana-monitoring/tree/main/Dashboards)
- NVIDIA Reference Links
  - [Docker Nividia Install](https://docs.nvidia.com/ai-enterprise/deployment-guide/dg-docker.html)
  - [Container Runtine Install](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

# Contact the Author
## Twitter @MikeZupper
## Discord mikezupper#2551