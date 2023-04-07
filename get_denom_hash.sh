#!/usr/local/bin/bash

NFT_ID=$1
DST_CHAIN=$2
NFT_PATH=$3
PROD_MODE=$4
NO_CHECK=$5

if [[ ! -n $NFT_ID ]] || [[ ! -n $DST_CHAIN ]] || [[ ! -n $NFT_PATH ]]; then
    echo "[ERROR]: use ./echo_path2.sh NFT_ID DST_CHAIN NFT_PATH"
    exit 1
fi

source ./.set_vars_gon

CHAIN_TYPE=${TYPE_MATRIX[$DST_CHAIN]}

NFT_PORT=${PORT_MATRIX[$DST_CHAIN]}
NFT_RPC=${RPC_MATRIX[$DST_CHAIN]}
NFT_APP=${APP_MATRIX[$DST_CHAIN]}
NFT_ADDRESS=${ADDRESS_MATRIX[$DST_CHAIN]}

if [[ ! -n $PROD_MODE ]]; then
    if [[ $CHAIN_TYPE = "w" ]]; then
        echo $NFT_APP q wasm contract-state smart $NFT_PORT \
            '{"nft_contract": {"class_id" : "'$NFT_PATH'"}}' --node $NFT_RPC --output json '|' jq -r '.data'
        echo $NFT_APP q wasm contract-state smart $HASH \
            '{"all_nft_info":{"token_id": "'$NFT_ID'"}}' \
            --node $NFT_RPC --output json '|' jq -r '.data.access.owner'
    fi
    if [[ $CHAIN_TYPE = "c" ]]; then
        echo $NFT_APP query nft-transfer class-hash \
            "$NFT_PATH" \
            --node $NFT_RPC --output json '|' jq -r '.hash'
        if [[ "$DST_CHAIN" = "i" ]]; then
            echo $NFT_APP query nft token \
                $DENOM $NFT_ID \
                --node $NFT_RPC -o json '|' jq -r '.owner'
        fi
        if [[ "$DST_CHAIN" = "o" ]]; then
            echo $NFT_APP query onft asset \
                $DENOM $NFT_ID \
                --node $NFT_RPC -o json '|' jq -r '.owner'
        fi
        if [[ "$DST_CHAIN" = "u" ]]; then
            echo $NFT_APP query collection collection $DENOM \
                --node $NFT_RPC -o json \
                '|' jq -r '.collection.nfts[] | select(.id=="'$NFT_ID'") | .owner'
        fi

    fi
else
    if [[ $CHAIN_TYPE = "w" ]]; then
        HASH=$($NFT_APP q wasm contract-state smart $NFT_PORT \
            '{"nft_contract": {"class_id" : "'$NFT_PATH'"}}' --node $NFT_RPC --output json | jq -r '.data')
        if [[ ! -n $HASH ]] || [[ "$HASH" = "null" ]]; then
            exit 1
        fi
        NFT_OWNER=$($NFT_APP q wasm contract-state smart $HASH \
            '{"all_nft_info":{"token_id": "'$NFT_ID'"}}' \
            --node $NFT_RPC --output json | jq -r '.data.access.owner')

        if [ "$NFT_OWNER" = "$NFT_ADDRESS" ]; then
            echo $HASH
        else
            exit 1
        fi
    fi
    if [[ $CHAIN_TYPE = "c" ]]; then

        HASH=$($NFT_APP query nft-transfer class-hash \
            "$NFT_PATH" \
            --node $NFT_RPC --output json | jq -r '.hash')
        if [[ ! -n $HASH ]]; then
            exit 1
        fi
        DENOM="ibc/$HASH"
        if [[ "$DST_CHAIN" = "i" ]]; then
            NFT_OWNER=$($NFT_APP query nft token \
                $DENOM $NFT_ID \
                --node $NFT_RPC -o json | jq -r '.owner')

            if [ "$NFT_OWNER" = "$NFT_ADDRESS" ]; then
                echo $DENOM
            else
                exit 1
            fi
        fi
        if [[ "$DST_CHAIN" = "o" ]]; then
            NFT_OWNER=$($NFT_APP query onft asset \
                "$DENOM" "$NFT_ID" \
                --node $NFT_RPC -o json | jq -r '.owner')

            if [ "$NFT_OWNER" = "$NFT_ADDRESS" ]; then
                echo $DENOM
            else
                exit 1
            fi
        fi
        if [[ "$DST_CHAIN" = "u" ]]; then
            NFT_OWNER=$($NFT_APP query collection collection "$DENOM" \
                --node $NFT_RPC -o json \
                | jq -r '.collection.nfts[] | select(.id=="'$NFT_ID'") | .owner')
            if [ "$NFT_OWNER" = "$NFT_ADDRESS" ]; then
                echo $DENOM
            else
                exit 1
            fi
        fi
    fi
fi
