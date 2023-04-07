#!/usr/local/bin/bash

DENOM=$1
NFT_ID=$2
SRC_CHAIN=$3
CHAN_NUMB=$4
DST_CHAIN=$5
PROD_MODE=$6

if [[ ! -n $DENOM ]] || [[ ! -n $NFT_ID ]] || [[ ! -n $SRC_CHAIN ]] || [[ ! -n $CHAN_NUMB ]] || [[ ! -n $DST_CHAIN ]]; then
    echo "[ERROR]: use ./echo_path2.sh DENOM NFT_ID SRC_CHAIN CHANNEL DST_CHAIN"
    exit 1
fi

source ./.set_vars_gon

SRC_DENOM=${DENOM_MATRIX[$SRC_CHAIN]}
DEFAULT_FLAGS="--gas auto --gas-adjustment 1.4 --fees 5000${SRC_DENOM} --from $WALLET_NAME --keyring-backend test --output json "

APP_TO_USE=${APP_MATRIX[$SRC_CHAIN]}
DST_ADDRESS=${ADDRESS_MATRIX[$DST_CHAIN]}
DST_CHANNEL=${CHANNEL_MATRIX[$SRC_CHAIN$CHAN_NUMB$DST_CHAIN]}
SRC_PORT=${PORT_MATRIX[$SRC_CHAIN]}
CHAIN_ID=${CHAINID_MATRIX[$SRC_CHAIN]}
RPC=${RPC_MATRIX[$SRC_CHAIN]}

CHAIN_TYPE=${TYPE_MATRIX[$SRC_CHAIN]}
if [[ $CHAIN_TYPE = "c" ]]; then
	TIMESTAMP=$(date +%s --date="+120 seconds")

   
    if [[ ! -n $PROD_MODE ]]; then
        echo $APP_TO_USE \
            tx nft-transfer transfer \
            $SRC_PORT \
            $DST_CHANNEL \
            $DST_ADDRESS \
            $DENOM \
            $NFT_ID \
            $DEFAULT_FLAGS \
            --packet-timeout-timestamp ${TIMESTAMP}000000000 \
            --chain-id $CHAIN_ID \
            --node $RPC -y
        RESULT_JSON='{"code":"0","txhash":"E3A2CCE7D5B244F779FC98F4B44FDD6898FDCFDBF87E09D64C5633D0911B40B1"}'
    else
    
        RESULT_JSON=$($APP_TO_USE \
            tx nft-transfer transfer \
            $SRC_PORT \
            $DST_CHANNEL \
            $DST_ADDRESS \
            $DENOM \
            $NFT_ID \
            $DEFAULT_FLAGS \
            --packet-timeout-timestamp ${TIMESTAMP}000000000 \
            --chain-id $CHAIN_ID \
            --node $RPC -y)
        CODE=$?
        if [[ $CODE -gt 0 ]]; then
            exit 1
        fi
    fi
fi

if [[ $CHAIN_TYPE = "w" ]]; then
	TIMESTAMP=$(date +%s --date="+120 seconds")
	#TIMESTAMP=$(($TIMESTAMP+60))
	#TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S%:z" --date="+60 seconds")
	#	TIMESTAMP=60
    #MSG_BASE64=$(echo '{"receiver": "'$DST_ADDRESS'","channel_id":"'$DST_CHANNEL'","timeout": {"block": {"revision": 6,"height": 4697141}}}' | base64 | tr -d "\n")
    MSG_BASE64=$(echo '{"receiver": "'$DST_ADDRESS'","channel_id":"'$DST_CHANNEL'","timeout": {"timestamp": "'$TIMESTAMP'000000000"}}' | base64 | tr -d "\n")
    

    JSON_MSG='{"send_nft": {"contract": "'$SRC_PORT'", "token_id": "'$NFT_ID'", "msg": "'$MSG_BASE64'"}}'

    if [[ ! -n $PROD_MODE ]]; then
        echo $APP_TO_USE tx wasm execute $DENOM \
            "$JSON_MSG" \
            $DEFAULT_FLAGS \
            --chain-id $CHAIN_ID \
            --node $RPC -y
        RESULT_JSON='{"code":"0","txhash":"E3A2CCE7D5B244F779FC98F4B44FDD6898FDCFDBF87E09D64C5633D0911B40B1"}'

    else
        RESULT_JSON=$($APP_TO_USE tx wasm execute $DENOM \
            "$JSON_MSG" \
            $DEFAULT_FLAGS \
            --chain-id $CHAIN_ID \
            --node $RPC -y)
        CODE=$?
        if [[ $CODE -gt 0 ]]; then
            exit 1
        fi
    fi

fi

CODE_RESULT=$(echo $RESULT_JSON | jq -r '.code')
TXHASH=$(echo $RESULT_JSON | jq -r '.txhash')

if [[ $CODE_RESULT -gt 0 ]]; then
    exit 1
fi

echo $TXHASH
exit
