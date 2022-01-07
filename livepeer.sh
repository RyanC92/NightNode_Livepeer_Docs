#! /bin/bash

ETH_URL="<YourEthURL>"
ETH_ACCT_ADDR="<YourETHADDR>"
SERVICE_ADDR="<OrchestratorServiceURL>"
PRICE_PER_UNIT=900
MAX_SESSIONS="<SessionCount>"
MAX_GAS_PRICE=60000000000
CLI_ADDR="<If you want to change your CLIADDR>"

/usr/local/bin/livepeer/livepeer \
    -network mainnet \
    -ethUrl $ETH_URL \
    -ethAcctAddr $ETH_ACCT_ADDR \
    -ethPassword <Example: /usr/local/bin/livepeer/pwd.txt> \
    -ethKeystorePath <Example: ~/.lpData/mainnet/keystore/> \
    -orchestrator \
#   -transcoder  \ #uncomment the line if you want to run and O/T 
    -cliAddr $CLI_ADDR \
    -orchSecret <Example: /usr/local/bin/livepeer/secret.txt> \
    -pricePerUnit $PRICE_PER_UNIT \
    -maxGasPrice $MAX_GAS_PRICE \
    -serviceAddr $SERVICE_ADDR \
    -monitor \
    -v 6 \
    -reward=false \
    -autoAdjustPrice=false \
    -maxSessions=$MAX_SESSIONS
