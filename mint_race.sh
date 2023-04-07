#!/usr/local/bin/bash


NFT_ID="$1"
NFT_URI="$2"
NFT_FLOW="$3"
NFT_DENOM="$4"

if [ "$NFT_ID" = "" ] || [ "$NFT_URI" = "" ] || [ "$NFT_FLOW" = "" ] || [ "$NFT_DENOM" = "" ]; then
echo "INPUT NFT_ID, NFT_URI, NFT_FLOW and NFT_DENOM"
exit
fi

source ./.set_vars_gon

DEFAULT_FLAGS="--gas auto --gas-adjustment 1.4 --fees 2000${IRIS_DENOM} --from $WALLET_NAME --keyring-backend test --output json "

JSON_MINT='{"purpose": "race","test": "1","flow": "'$NFT_FLOW'","target": "the sky and beyond"}'

$IRIS_BIN tx nft mint $NFT_DENOM $NFT_ID \
--name "Commercio.Network NFT for $NFT_FLOW" \
--uri "$NFT_URI" \
--uri-hash "" \
--data "$JSON_MINT" \
--recipient $IRIS_ADDRESS \
$DEFAULT_FLAGS \
--chain-id "$IRIS_CHAIN_ID" \
--node $IRIS_RPC -y
