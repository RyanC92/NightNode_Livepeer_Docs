# Overview

This guide will walk you through the Livepeer Orchestrator & Transcoder setup using Docker. The Livepeer team publishes containers to Docker Hub for all their respective services (Orchestrator, Transcoder, Broadcaster, Mist Server, Etc..).

Please review the Livepeer Architecture for a better understanding of the Livepeer Network.


TODO: put link to resource appendix heree 

# Prerequisites

This guide assumes you are familiar with installing software on unix based systems. You should be comfortable with command line syntax, networks, firewalls, and containerized environments (specifically docker). You dont have to be an expert, but troubleshooting skills will come in handy.

Lastly, You should be familiar with the Livepeer configuration, deployment, and running of an Orchestrator/Transcoder. I'd recommend reviewing the Linux and Windows installation guides prior to attempting to run Livepeer in Docker. 

Have the following configuration information ready:
- Livepeer ETH Account
- RPC Url for Arbitrum
  - Infura, Alchemy, Public or others

TODO: need to put community arb node here????

TODO: add anchor to reeource appenddix for Tutorials for Livepeer (Titan node youtube and NightNode Github)

# Verify Environment Prerequisites

In order to have a smooth transition to Livepeer on Docker, several key verification steps are needed. 

This guide was developed using:
- Ubuntu Linux 20.04
- Docker 20.10.14
- NVIDIA-SMI 510.60.02
  - Driver Version: 510.60.02
  - CUDA Version: 11.6  
- Livepeer 0.5.29

## Verification Steps 
Please run the following commands to make sure you Docker/Livepeer environment is ready for configuration.

If any of the following steps fail - YOU MUST STOP HERE! Please revisit the Livepeer resources to ensure a NON-docker enviroment can run on this server before proceeding. 

*If the version numbers don't match, you should be able to proceed assuming the Livepeer configuration works on this server without Docker.*

- **command**: docker -v 
  - **output** *Docker version 20.10.14, build a224086*
- **command**: docker info
  - Look for the **Runtimes** section and ensure you see the nvidia entry listed
  - **output** : *Runtimes: runc io.containerd.runc.v2 io.containerd.runtime.v1.linux **nvidia** .*
- **command**: nvidia-smi
  
  The NVIDIA-SMI output should contain:
  
  - *NVIDIA-SMI 510.60.02* 
  - *Driver Version: 510.60.02*
  - *CUDA Version: 11.6*
- **command**: sudo docker run --gpus all nvidia/cuda:11.0-base nvidia-smi
  - *output* same output as nvidia-smi
  - if this fails, please review your NVIDIA / Docker setup.

# Docker Volumes Setup

Inside the Docker container, Livepeer will store the various files on the /root/.lpData directory. We must create a docker volume to persist file changes when containers restart.

- **command**: docker volume create combinedLpData
- **command**: docker volume create orchLpData
- **command**: docker volume create transLpData
- **command**: docker volume list
  - *output*: \
            **DRIVER VOLUME NAME \
            local combinedLpData \
             local orchLpData \
             local transLpData**

# Livepeer Configuration

In this section, we will review the livepeer configuration file. I'd encourage you to review all the possible Livepeer configuration settings. For this guide, we will specifically configure 2 use cases:

1. Single Container combined Orchestrator/Transcoder
2. Separate Containers for Orchestrator and Separate Transcoder

**livepeer.conf** - for this guide, this file will be stored in one of the docker volume created above. 

On a linux host system, you can find all volumes in the following location: /var/lib/docker/volumes/VOLUME-NAME/_data


## Configure Combined Orchestrator/Transcoder

Next, create the livepeer.conf file

- create the livepeer.conf
  - **command**: touch /var/lib/docker/volumes/combinedLpData/_data/livepeer.conf
- modify the newly created file to include the following settings:

*ethUrl <YOUR ETH URL - Infura, Alchemy, Other>\
ethPassword /root/.lpData/eth_secret.txt\
serviceAddr <YOUR IP ADDR>:8935\
network arbitrum-one-mainnet \
orchestrator true\
transcoder true\
pricePerUnit 700\
monitor true\
v 6\
maxSessions 10\
autoAdjustPrice false*

### Start The container 

TODOD: describe foreground and background containers

 docker run -it -v combinedLpData:/root/.lpData/ livepeer/go-livepeer:0.5.29  -config=/root/.lpData/livepeer.conf

## Configure Standalone Orchestrator 

## Configure Standalon Transcoder 

### Start The containers

 *docker run -it -v orchLpData:/root/.lpData/ livepeer/go-livepeer:0.5.29  -config=/root/.lpData/livepeer.conf*

  *docker run -it -v transLpData:/root/.lpData/ livepeer/go-livepeer:0.5.29  -config=/root/.lpData/livepeer.conf*


# Monitoring Docker and Livepeer

# Handy Scripts

- Github location for all scripts
- create livepeer volumes and networks
- start and stop each docker container

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
