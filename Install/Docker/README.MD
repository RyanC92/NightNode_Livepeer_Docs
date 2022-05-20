# Overview

This guide will walk you through the Livepeer Orchestrator & Transcoder setup using Docker. The installation will be based on Ubuntu Linux and includes the following steps:

1. Docker
2. NVIDIA Drivers
3. NVIDA Patch
4. NVIDIA Container Runtime
5. Livepeer Setup
6. Multiple Modes to Run Livepeer
7. Prometheus Monitoring for Livepeer
8. Grafana Reporting for Livepeer

All docker images used in this guide are published to Docker Hub. 

Please review the Livepeer Architecture for a better understanding of the Livepeer Network [links](#Reference+Documentation).

# Prerequisites

This guide assumes you are familiar with installing software on unix-based systems. You should be comfortable with command-line syntax, Networking, Firewalls, and containerized environments. You dont have to be an expert, but troubleshooting skills will come in handy.

Lastly, You should be familiar with the Livepeer configuration, deployment, and running of an Orchestrator/Transcoder. I'd recommend reviewing the Linux and Windows installation guides prior to attempting to run Livepeer in Docker. 

Have access to an Arbitrum RPC URL. This is required to run Livepeer. You can use any RPC URL, but some of the commonly used services are Infura, Alchemy, or Self Hosted.

TODO: need to put community arb node here????

# Install Docker

This section covers the docker installation. On Ubuntu Linux, we will follow the docker prescribed steps found on [docker.com](https://docs.docker.com/engine/install/ubuntu/)

remove older version of docker:

```
sudo apt-get remove docker docker-engine docker.io containerd runc
```

install the docker reepo for ubuntu

```
sudo apt-get update

sudo apt-get install ca-certificates curl net-tools gnupg lsb-release
```

TODO: some linux installs have these keyrings... what to do?????

````
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

sudo echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo systemctl --now enable docker
```

allow a non-root user to run docker containers

``` useradd -g docker YOUR_LINUX_USER ```

# Install NVIDIA Docker

https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html

```
sudo distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker

```

# Verify Environment Prerequisites

This guide was developed using:
- Ubuntu Linux 20.04
- Docker 20.10.14
- NVIDIA-SMI 510.60.02
  - Driver Version: 510.60.02
  - CUDA Version: 11.6  
- Livepeer 0.5.29


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
  - **output** : *Runtimes: runc io.containerd.runc.v2 io.containerd.runtime.v1.linux **nvidia** .*

``` nvidia-smi```
  
  The NVIDIA-SMI output should contain:
  
  - *NVIDIA-SMI 510.60.02* 
  - *Driver Version: 510.60.02*
  - *CUDA Version: 11.6*

```sudo docker run --gpus all nvidia/cuda:11.0-base ```

  - *output* same as nvidia-smi
  - if this fails, please review your NVIDIA / Docker setup.


# Create Livepeer User

``` mkdir /home/livepeer
useradd -g docker livepeer
chown -Rf livepeer.docker /home/livepeer
usermod -d /home/livepeer livepeer
usermod -s /bin/bash livepeer
```
# Livepeer Configuration

In this section, we will review the livepeer configuration file. I'd encourage you to review all the possible Livepeer configuration settings. For this guide, we will specifically configure 2 use cases:

1. Single Container combined Orchestrator/Transcoder
2. Separate Containers for Orchestrator and Separate Transcoder

## Livepeer Configuration Prep

All configuration for livepeer will be stored in one folder. The livepeer.conf file, ETH keystore/secret, and arbitrum files will stored in this configuration folder. 

*****PROTECT THESE FILES AND FOLDER!!!!*****

*****THEY CONTAIN SENSTIVE INFO!!!*****

First, create the configuration directory that will contain your livepeer files.

```mkdir -p /home/livepeer/orch/```

Create the eth_secret.txt file.

``` touch /home/livepeer/orch/eth_secret.txt```

**make sure you modify this file and store your ETH account passphrase** 

This is the password I used:

``` LivePeerEthSecret! ```

Create the kestore and copy your ETH private key.

```mkdir -p /home/livepeer/orch/arbitrum/keystore```

- copy your ETH Json keyfile to keystore directory

```cp key.json /home/livepeer/orch/arbitrum/keystore/```

### (Optional) Create a ETH Account via Livepeer

Run this command to generate the ETH account JSON file.

this step will prompt you 3 times. you are creating a new ETH account addr, keystore, and passphrase

a file should be created /

```
mkdir livepeer-eth-acct

cd livepeer-eth-acct

docker run --rm -it -v $(pwd):/root/.lpData/ livepeer/go-livepeer:0.5.29 -orchestrator=true \
-orchSecret=LivePeerRocks! -network=arbitrum-mainnet -ethUrl=https://rpc.ankr.com/arbitrum \
-ethPassword=LivePeerRocks! -v=6

```

It will attempt to start the Orchestrator. It will prompt you for the ETH Account Password (stored in eth_secret.txt). 

In this example I used: ```LivePeerRocks!```

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
```
chown -Rf livepeer.docker /home/livepeer

```
ls arbitrum-mainnet/keystore/*
```

You will see output like this:

```
arbitrum-mainnet/keystore/UTC--2022-05-13T13-38-48.305596618Z--1483c047d9fe54a26356b82fcac79209f4c793ec
```

The file name starting with UTC--[DATE]--[ETH ACCOUNT ADDR]

```
1483c047d9fe54a26356b82fcac79209f4c793ec
```

the ETH Account should be saved for your Livepeer configuration. 

The ETH Account will be as follows. 
*Take note of the 0x that was appended to the front of the account.*
```
0x1483c047d9fe54a26356b82fcac79209f4c793ec
```

neeed to copy the files to the right folder

```
cp /home/livepeer/orch/livepeer-eth-acct/arbitrum-mainnet/keystore/YOUR_UTC_FILE.json /home/livepeer/orch/arbitrum/keystore/

ls -al /home/livepeer/orch/*
```

## Configure Combined Orchestrator/Transcoder

Choose the template file that matches your Livepeer use case. 

For our first use case, we will use the combined Orchestrator / Transcoder Template.

Download [livepeer_orchestratorcombo.conf](https://github.com/NightWolf92/NightNode_Livepeer_Docs/blob/main/Install/Linux/livepeer_orchestratorcombo.conf) to use as a starting point.

- rename the template file to *livepeer.conf*
- modify the file to include your environment settings.

These are the settings I used:

```
orchestrator true
transcoder true
network arbitrum-one-mainnet
ethUrl arb1.arbitrum.io/rpc
ethPassword /root/.lpData/eth_secret.txt
serviceAddr <IP:PORT>
cliAddr <IP:PORT>
maxGasPrice 5000000000
pricePerUnit 900
nvidia all
maxSessions 10
monitor
v 6
```

# Run The Orchestrator/Transcoder!

``` docker run --rm --gpus all --name livepeer-orch-trans -p 8935:8935 -p 7935:7935 -d -v /home/livepeer/orch/:/root/.lpData/ livepeer/go-livepeer:0.5.29 -config=/root/.lpData/livepeer.conf ```

### View container logs

```docker logs livepeer-orch-trans -f```

### Stop The container 

```docker stop livepeer-orch-trans```

## Configure Standalone Orchestrator 

[livepeer_orchestrator.conf](https://github.com/NightWolf92/NightNode_Livepeer_Docs/blob/main/Install/Linux/livepeer_orchestrator.conf) 

## Configure Standalon Transcoder 

[livepeer_transcoder.conf](https://github.com/NightWolf92/NightNode_Livepeer_Docs/blob/main/Install/Linux/livepeer_transcoder.conf) 


## Run The Standalone Orchestrator!

 ```docker run --rm  --name livepeer-orch -p 8935:8935 -p 7935:7935 -d -v /home/livepeer/orch-orch/:/root/.lpData/ livepeer/go-livepeer:0.5.29 -config=/root/.lpData/livepeer.conf```

## Run The Standalone Transcoder!

 ```docker run --rm --gpus all --name livepeer-trans -p 8935:8935 -p 7935:7935 -d -v /home/livepeer/orch-trans/:/root/.lpData/ livepeer/go-livepeer:0.5.29  -config=/root/.lpData/livepeer.conf```

# Monitoring Livepeer

 ```docker run --rm --gpus all --name livepeer-trans -p 8935:8935 -p 7935:7935  -d -v /home/livepeer/orch-trans/:/root/.lpData/ livepeer/go-livepeer:0.5.29  -config=/root/.lpData/livepeer.conf```

  ```docker run --rm --gpus all --name livepeer-trans -p 8935:8935 -p 7935:7935 -d -v /home/livepeer/orch-trans/:/root/.lpData/ livepeer/go-livepeer:0.5.29  -config=/root/.lpData/livepeer.conf```

# Reference Documentation

- Livepeer.org
- Livepeer.com
- Mist Server
- Discord
- Curated Livepeer Links (https://livepeer.tools)
- NVIDIA docker setup
  - https://docs.nvidia.com/ai-enterprise/deployment-guide/dg-docker.html

# Contact the Author
## Twitter @MikeZupper
## Discord mikezupper#2551