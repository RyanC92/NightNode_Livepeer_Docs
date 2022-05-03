# Documentation

* Additional documentation for the  can be found [Here](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Documentation) 
* Developer documentation (i.e. if you are interested in developing go-livepeer) can be found in the [docs](https://github.com/livepeer/go-livepeer/blob/master/doc) folder
* Protocol information can be found in the [protocol](https://github.com/livepeer/protocol) repo
* Other project information can be found in the [wiki](https://github.com/livepeer/wiki/wiki)

# Installation

### Windows

Download the latest release located [Here](https://github.com/NightWolf92/NightNode_Livepeer_Docs/releases/tag/Latest)

The Livepeer_Setup.exe file will prompt if you want to install this for yourself, or all users. (If you choose for yourself, it installs it into appData, all users would be ```C:\Program Files(x86)\``` by default)

The installer will install the files to the stated install directory, providing default templates, config files and launch batch files that would require minimal modification to get started. It will also download the latest livepeer release from https://github.com/livepeer/go-livepeer

# Modifications 

### Windows

Navigate to the install directory that was selected, by default it is ```"C:\Program Files(x86)\Livepeer\"```. Inside the folder are a list of files that can be modified, please do so to fit your setup specifications.

```
livepeer_orchestrator.conf (This will just run the O)
livepeer_orchestratorcombo.conf (If you're going to run the O and the T Together in one window)
livepeer_transcoder - GPU ALL.conf (Runs all GPUs for livepeer)
livepeer_transcoder - GPU0.conf  (Runs just GPU0 - if you have 1 GPU, it starts at 0)
livepeer_transcoder - GPU1.conf (Runs just GPU1 - This would be your second GPU)
```

Once you modify the files, there are corresponding batch files for each launcher. If you would like to simplify it, modify the ```LaunchScript.bat``` to include the batch files you would like to launch all at once and it will launch them together.

# For Orchestrators

Follow the config file guidance The below configs will look similar to the text below, replace the field that are encapuslated with < text >, removing the brackets <> (See the #Arbitrum RPC ethURL for how it should look.)

## livepeer_orchestrator.conf (For Standalone Orchestrators - No Transcoders connected)

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
