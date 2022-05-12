# Overview

This guide will walk you through the Livepeer Orchestrator & Transcoder setup using Docker. The Livepeer team publishes containers to Docker Hub for all their respective services (Orchestrator, Transcoder, Broadcaster, Mist Server, Etc..).

Please review the Livepeer Architecture for a better understanding of the Livepeer Network.

LINK TO Docker Hub releases

LINK to Livepeer arch docs

# Prerequisites

- Docker Installed & Configured
- NVIDIA Driver Installed & Patched
  - nvidia-smi installed and tested
  - using a Livepeer compatible GPU
- Livepeer ETH Account Setup
- RPC Url for Arbitrum
  - Infura, Alchemy, or Public
# Demo Environment Setup Used
## Hardware Specs
## Software Version
  - Windows
  - Mac
  - Linux

# Nvidia Setup Testing

## nvidia-smi

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

# Contact the Author

## Twitter @MikeZupper

## Discord mikezupper#2551
