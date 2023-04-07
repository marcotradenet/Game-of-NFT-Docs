#!/usr/local/bin/bash


# {
#   "type": "individual race round",
#   "flow": "the flow id, check flow with flow-id on https://github.com/game-of-nfts/gon-testnets/blob/main/doc/flow-table.md",
#   "last_owner": "the ultimate owner of this NFT",
#   "start_height": "transfer before this height are considered invalid"
# }


source ./.set_vars_gon

JSON_SCHEMA='{"type": "1","flow": "f18","last_owner": "iaa1ufep2fr5rqpah33rg5durzpyekggthh5cl883j","start_height": "1234567"}'

$IRIS_BIN tx nft issue crace001 \
--name "CRaceTest NFT GoN" \
--uri "https://test.xxx" \
--data "$JSON_SCHEMA" \
--symbol "crace_symbol" \
--mint-restricted \
--update-restricted \
--from $WALLET_NAME \
--keyring-backend test \
--chain-id "$IRIS_CHAIN_ID" \
--gas auto \
--gas-adjustment 1.4 \
--fees 5000${IRIS_DENOM} \
--schema "" \
--node "$IRIS_RPC" -y

# E91453B8AF898CA913C9B85C1FAED894C1EC2AF4941966FF77B523E2D4FF2C21