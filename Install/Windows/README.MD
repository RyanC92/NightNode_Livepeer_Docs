# Documentation

* Additional documentation for the  can be found [Here](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Documentation) 
* Developer documentation (i.e. if you are interested in developing go-livepeer) can be found in the [docs](https://github.com/livepeer/go-livepeer/blob/master/doc) folder
* Protocol information can be found in the [protocol](https://github.com/livepeer/protocol) repo
* Other project information can be found in the [wiki](https://github.com/livepeer/wiki/wiki)
* Official Livepeer [Documentation and Guides](https://livepeer.com/docs/guides) 

#### Table of Contents

- [Installation - Part 1 - Livepeer](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Windows#installation-part-1-livepeer)
- [Modifications - Livepeer](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Windows#modifications)
  - [For Orchestrators](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Windows#for-orchestrators)
  - [For Orchestrator/Transcoder Combo](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Windows#for-orchestratortranscoder-combo)
  - [For Transcoders](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Windows#for-transcoders)
  - [Livepeer Flags](https://github.com/NightWolf92/NightNode_Livepeer_Docs/blob/main/Install/Windows/README.MD#livepeer-flags)
- [Installation - Part 2 - Grafana](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Windows#installation-part-2-grafana)
- [Installation - Part 3 - Prometheus](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Windows#installation-part-3-prometheus)
- [Running Livepeer, Grafana, Prometheus](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Windows#running-livepeer-grafana-prometheus)
- [How to Uninstall]()
- [Feedback](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Windows#feedback)  
  
# Installation (Part 1: Livepeer)

Note: Please Note this guide is not a one and done solutions, assumes the user has some knowledge of livepeer and its software and requires limited modification of configuration files to work, these configuration files are located in the install directory chosen during install. Please reference Livepeers official documentation if needed.

https://livepeer.com/docs/guides

Note 2: Follow the config files guidance. The below configs will look similar to the text below, replace the field that are encapuslated with < text >, removing the brackets <> (See the #Arbitrum RPC ethURL for how it should look.) Also, remove the #'s which will uncomment the lines and make them applicable to the livepeer program. 

### Windows

Download the latest release located [Here](https://github.com/NightWolf92/NightNode_Livepeer_Docs/releases/tag/Latest)

The Livepeer_Setup.exe file will prompt if you want to install this for yourself, or all users. Livepeer will install to ```C:\Livepeer\``` by default.

The installer will install the files to the stated install directory, providing default templates, config files and launch batch files that would require minimal modification to get started. It will also download the latest livepeer release from https://github.com/livepeer/go-livepeer

# Modifications 

### Windows

What to do:

Navigate to the install directory that was selected, by default it is ```"C:\Livepeer\"```. Inside the folder are a list of files that can be modified, please do so to fit your setup specifications.

```
livepeer_orchestrator.conf (This will just run the O)
livepeer_orchestratorcombo.conf (If you're going to run the O and the T Together in one window)
livepeer_transcoder - GPU ALL.conf (Runs all GPUs for livepeer)
livepeer_transcoder - GPU 0.conf  (Runs just GPU 0 - if you have 1 GPU, it starts at 0)
livepeer_transcoder - GPU 1.conf (Runs just GPU 1 - This would be your second GPU)
```

Once you modify the files, there are corresponding batch files for each launcher. If you would like to simplify it, modify the ```LaunchScript.bat``` to include the batch files you would like to launch all at once and it will launch them together.

# For Orchestrators

### livepeer_orchestrator.conf (For Standalone Orchestrators - No Transcoders connected)

```
##############################################
#Uncomment the flags if you want to use them.#
##############################################
#                Settings                    #
##############################################

orchestrator
#transcoder
network arbitrum-one-mainnet

##############################################
#              RPC Providers                 #
##############################################

#Alchemy
#ethUrl <RPC URL>

#Infura
#ethUrl <RPC URl>

#Arbnode
#ethUrl <RPC URL>

#Arbitrum RPC
ethUrl arb1.arbitrum.io/rpc

##############################################
#                Configs                     #
#             Key management                 #
##############################################

ethKeystorePath <Path to Keystore>
datadir <Path to Data Directory>
ethPassword <Wallet password>

##############################################
#      Redeemer Info (if applicable)         #
##############################################
#ethOrchAddr <Eth Address>
#redeemerAddr <IP:PORT>

##############################################
#        Orchestrator Management             #
##############################################

serviceAddr <IP:PORT>
cliAddr <IP:PORT>
orchSecret <string or path to secret file> #if you're using remote transcoders
maxGasPrice 5000000000 #only processes transactions when its under .5 gwei
pricePerUnit <900-1200 recommended>
nvidia all #<all,0,1,2,3 etc>
maxSessions <#>
monitor
v 6

#####################################
#            End File               #
#####################################
```

# For Orchestrator/Transcoder Combo:

This is basically the same thing, however it just has ```transcoder``` uncommented and orchSecret is not needed since it will be local. 

### livepeer_orchestratorcombo.conf

```
##############################################
#Uncomment the flags if you want to use them.#
##############################################
#                Settings                    #
##############################################

orchestrator
transcoder
network arbitrum-one-mainnet

##############################################
#              RPC Providers                 #
##############################################

#Alchemy
#ethUrl <RPC URL>

#Infura
#ethUrl <RPC URl>

#Arbnode
#ethUrl <RPC URL>

#Arbitrum RPC
ethUrl arb1.arbitrum.io/rpc

##############################################
#                Configs                     #
#             Key management                 #
##############################################

ethKeystorePath <Path to Keystore>
datadir <Path to Data Directory>
ethPassword <Wallet password>

##############################################
#      Redeemer Info (if applicable)         #
##############################################
#ethOrchAddr <Eth Address>
#redeemerAddr <IP:PORT>

##############################################
#        Orchestrator Management             #
##############################################

serviceAddr <IP:PORT>
cliAddr <IP:PORT>
#orchSecret <string or path to secret file> #if you're using remote transcoders
maxGasPrice 5000000000 #only processes transactions when its under .5 gwei
pricePerUnit <900-1200 recommended>
nvidia all #<all,0,1,2,3 etc>
maxSessions <#>
monitor
v 6

#####################################
#            End File               #
#####################################

```

Note: running an O/T Combo in the same process will not allow remote Transcoders to connect to this node, if you want to have remote Transcoders, run the two processes separately. 

# For Transcoders:

### livepeer_transcoder - GPU ALL.conf
### livepeer_transcoder - GPU0.conf
### livepeer_transcoder - GPU1.conf

This is for local transcoders or remote transcoders, change the IP for the orchAddr to point to their IP address if necessary, if its on the same machine, you can keep it as 127.0.0.1.

This will also use all GPU's on the machine. If you want to change this for GPU 1,2,3,4,5 etc. put the corresponding number next to ```nvidia``` replacing ```all``` with the number. 

The files ```livepeer_transcoder - GPU0.conf``` and ```livepeer_transcoder - GPU1.conf``` are already configured to utilize those GPUs individually. you can also add gpus specifically by doing ```nvidia 1,3,5``` and it will run GPU 2,4,5 in your computer. (numbering starts at 0)

```
##############################################
#                Settings                    #
##############################################

transcoder

##############################################
#        Transcoder Management               #
##############################################

orchAddr 127.0.0.1:8935 #If your orchestrator is on a VPS or off site location, change the orch address to that servers IP.
cliAddr 127.0.0.1:7925
orchSecret <string or path to secret file> #if you're using remote transcoders
nvidia all
maxSessions <#>
monitor
v 6

#####################################
#            End File               #
#####################################
```

# Livepeer Flags


``` 
Usage of livepeer:
  authWebhookUrl string
        RTMP authentication webhook URL
  autoAdjustPrice
        Enable/disable automatic price adjustments based on the overhead for redeeming tickets (default true)
  blockPollingInterval int
        Interval in seconds at which different blockchain event services poll for blocks (default 5)
  broadcaster
        Set to true to be a broadcaster
  cliAddr string
        Address to bind for  CLI commands (default "127.0.0.1:7935")
  config string
        Config file in the format 'key value', flags and env vars take precedence over the config file
  currentManifest
        Expose the currently active ManifestID as "/stream/current.m3u8"
  datadir string
        Directory that data is stored in
  depositMultiplier int
        The deposit multiplier used to determine max acceptable faceValue for PM tickets (default 1)
  detectionWebhookUrl string
        (Experimental) Detection results callback URL
  ethAcctAddr string
        Existing Eth account address
  ethController string
        Protocol smart contract address
  ethKeystorePath string
        Path for the Eth Key
  ethOrchAddr string
        ETH address of an onchain registered orchestrator
  ethPassword string
        Password for existing Eth account address
  ethUrl string
        Ethereum node JSONRPC URL
  gasLimit int
        Gas limit for ETH transactions
  httpAddr string
        Address to bind for HTTP commands
  httpIngest
        Set to true to enable HTTP ingest (default true)
  initializeRound
        Set to true if running as a transcoder and the node should automatically initialize new rounds
  j    Print application info as json
  localVerify
        Set to true to enable local verification i.e. pixel count and signature verification. (default true)
  maxAttempts int
        Maximum transcode attempts (default 3)
  maxGasPrice int
        Maximum gas price (priority fee + base fee) for ETH transactions in wei, 40 Gwei = 40000000000
  maxPricePerUnit int
        The maximum transcoding price (in wei) per 'pixelsPerUnit' a broadcaster is willing to accept. If not set explicitly, broadcaster is willing to accept ANY price
  maxSessions int
        Maximum number of concurrent transcoding sessions for Orchestrator, maximum number or RTMP streams for Broadcaster, or maximum capacity for transcoder (default 10)
  maxTicketEV string
        The maximum acceptable expected value for PM tickets (default "3000000000000")
  maxTransactionReplacements int
        Number of times to automatically replace pending Ethereum transactions (default 1)
  metadataAmqpExchange string
        Name of AMQP exchange to send operation metadata (default "lp_golivepeer_metadata")
  metadataPublishTimeout duration
        Max time to wait in background for publishing operation metadata events (default 1s)
  metadataQueueUri string
        URI for message broker to send operation metadata
  metricsClientIP
        Set to true to expose client's IP in metrics
  metricsPerStream
        Set to true to group performance metrics per stream
  minGasPrice int
        Minimum gas price (priority fee + base fee) for ETH transactions in wei, 10 Gwei = 10000000000
  monitor
        Set to true to send performance metrics
  network string
        Network to connect to (default "offchain")
  nvidia string
        Comma-separated list of Nvidia GPU device IDs (or "all" for all available devices)
  objectStore string
        url of primary object store
  orchAddr string
        Comma-separated list of orchestrators to connect to
  orchSecret string
        Shared secret with the orchestrator as a standalone transcoder
  orchWebhookUrl string
        Orchestrator discovery callback URL
  orchestrator
        Set to true to be an orchestrator
  pixelsPerUnit int
        Amount of pixels per unit. Set to '> 1' to have smaller price granularity than 1 wei / pixel (default 1)
  pricePerUnit int
        The price per 'pixelsPerUnit' amount pixels
  recordStore string
        url of object store for recordings
  redeemer
        Set to true to run a ticket redemption service
  redeemerAddr string
        URL of the ticket redemption service to use
  reward
        Set to true to run a reward service
  rtmpAddr string
        Address to bind for RTMP commands (default "127.0.0.1:1935")
  sceneClassificationModelPath string
        Path to scene classification model
  selectRandFreq float
        Frequency to randomly select unknown orchestrators (on-chain mode only) (default 0.3)
  serviceAddr string
        Orchestrator only. Overrides the on-chain serviceURI that broadcasters can use to contact this node; may be an IP or hostname.
  testTranscoder
        Test Nvidia GPU transcoding at startup (default true)
  ticketEV string
        The expected value for PM tickets (default "1000000000000")
  transactionTimeout duration
        Amount of time to wait for an Ethereum transaction to confirm before timing out (default 5m0s)
  transcoder
        Set to true to be a transcoder
  transcodingOptions string
        Transcoding options for broadcast job, or path to json config (default "P240p30fps16x9,P360p30fps16x9")
  v string
        Log verbosity.  {4|5|6}
  verifierPath string
        Path to verifier shared volume
  verifierUrl string
        URL of the verifier to use
  version
        Print out the version
```


# Installation (Part 2: Grafana)

Included in the installer for livepeer is the installer for Grafana for Windows. This will install as part of the process of the installer. 

The default location for the Grafana Installation is ```C:\Program Files\GrafanaLabs\```

After grafana is installed navigate to ```localhost:3000``` to verify that grafana has been installed properly. 


# Installation (Part 3: Prometheus)

Included as well in the install for livepeer, the installer will go to prometheus and download the zip and extract it. The files get extracted to the install directory of Livepeer.

The batch file within the livepeer installer folder is set to point to this. Please utilize the the ```prometheus.yml``` file located in the livepeer install folder. 

Please make sure to modify the ```prometheus.yml``` file in the livepeer folder to fit your ports/IPs.

*The prometheus and GPU localhost IPs can be modified to be your external IP and as such will make it externally accessible.*

```# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

scrape_configs:

  # The prometheus and GPU localhost IPs can be modified to be your external IP and as such will make it externally accessible.
  
  - job_name: 'prometheus'
    
    static_configs:
    
    - targets: ['localhost:9090']
  
  - job_name: 'gpu'
    
    static_configs:
    
    - targets: ['localhost:9101']
  
  - job_name: 'livepeer'
    
    metrics_path: /metrics
    
    static_configs:
    
    - targets: ['localhost:7935']
```

# Running Livepeer, Grafana, Prometheus

Now that you have modified the files necessary to run these programs (Livepeer .conf files, Prometheus.yml file).

You can either run the individual launch batch files for Livepeer and Prometheus or run the ```LaunchScript.Bat``` file. *Please note, you may need to modify the batch file to point it to the specific launch files you want to run. For Example: ```Orchestrator.bat```,```Transcoder - GPU 1.bat``` and ```prometheus.bat```)*.

![image](https://user-images.githubusercontent.com/15055337/168826285-2aaa3738-39bb-407c-ae92-e82f115ee4cb.png)

Grafana will launch automatically and run in the background as a service after the install is complete.

You can connect to the interface by using ```localhost:3000``` in your browser to start. 

# How to Uninstall

Located in the install directory is an uninstaller executable that will remove and delete all of the files within the install directory.

You may also uninstall via "Add and remove programs".

# Feedback

### Please feel free to submit feedback using the link below which will create a github issue
https://forms.gle/ASZeodPwp3uQntzC8
