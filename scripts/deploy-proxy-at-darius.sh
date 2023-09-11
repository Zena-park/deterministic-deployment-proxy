#!/bin/sh

set -x

#JSON_RPC="http://localhost:1234"
# JSON_RPC="https://goerli.optimism.tokamak.network"
#JSON_RPC="https://rpc.titan.tokamak.network"
JSON_RPC="https://rpc.titan-goerli-nightly.tokamak.network"

# extract the variables we need from json output
ONE_TIME_SIGNER_ADDRESS="0x$(cat output/deployment.json | jq --raw-output '.signerAddress')"
GAS_COST="0x$(printf '%x' $(($(cat output/deployment.json | jq --raw-output '.gasPrice') * $(cat output/deployment.json | jq --raw-output '.gasLimit'))))"
TRANSACTION="0x$(cat output/deployment.json | jq --raw-output '.transaction')"
DEPLOYER_ADDRESS="0x$(cat output/deployment.json | jq --raw-output '.address')"

cat $DEPLOYER_ADDRESS
cat $TRANSACTION

# deploy the deployer contract
curl $JSON_RPC -X 'POST' -H 'Content-Type: application/json' --data "{\"jsonrpc\":\"2.0\", \"id\":1, \"method\": \"eth_sendRawTransaction\", \"params\": [\"$TRANSACTION\"]}"

