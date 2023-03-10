#!/bin/bash


NFT_ID="$1"
NFT_URI="$2"
NFT_FLOW="$3"

if [ "$NFT_ID" = "" ] || [ "$NFT_URI" = "" ] || [ "$NFT_FLOW" = "" ]; then
echo "INPUT NFT_ID and NFT_URI"
exit
fi

source ./.set_vars_gon

JSON_MINT='{"github_username": "marcotradenet","discord_handle": "MarcR#1797","team_name": "Commercio.Network","community": "none"}'

$IRIS_BIN tx nft mint commnet001 $NFT_ID \
--name "Commercio.Network NFT for $NFT_FLOW" \
--uri "$NFT_URI" \
--uri-hash "" \
--data "$JSON_MINT" \
--recipient $IRIS_ADDRESS \
--gas auto \
--gas-adjustment 1.4 \
--fees 2000${IRIS_DENOM} \
--from GoN-Address \
--keyring-backend test \
--chain-id "$IRIS_CHAIN_ID" \
--node $IRIS_RPC -y
