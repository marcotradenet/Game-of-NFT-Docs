#!/usr/local/bin/bash


NFT_ID="$1"
NFT_URI="$2"
NFT_FLOW="$3"
NFT_DENOM="$4"

if [ "$NFT_ID" = "" ] || [ "$NFT_URI" = "" ] || [ "$NFT_FLOW" = "" ] || [ "$NFT_DENOM" = "" ]; then
echo "INPUT NFT_ID and NFT_URI"
exit
fi

source ./.set_vars_gon

JSON_MINT='{"github_username": "marcotradenet","discord_handle": "MarcR#1797","team_name": "Commercio.Network","community": "none"}'

$IRIS_BIN tx nft mint $NFT_DENOM $NFT_ID \
--name "CRACE NFT for $NFT_FLOW" \
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
