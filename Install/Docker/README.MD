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

# Docker Volumes / Networks Setup

# Livepeer Configuration

livepeer.conf

ethUrl <YOUR ETH URL - Infura, Alchemy, Other>
ethPassword /root/.lpData/eth_secret.txt
serviceAddr <YOUR IP ADDR>:8935
network arbitrum-one-mainnet 
orchestrator true
transcoder true
pricePerUnit 700
monitor true
v 6
maxSessions 10
autoAdjustPrice false

## Docker Environment Variables (Optional)

## Standalone Orchestrator / Transcoder

 docker run -it -v /Users/mazup/Desktop/livepeer_stuff/docker-livepeer/:/root/.lpData/ livepeer/go-livepeer:0.5.29  -config=/root/.lpData/livepeer.conf


## Separate Orchestrator / Separate Transcoder

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
