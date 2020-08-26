# run a dev server:
docker run --cap-add=IPC_LOCK -d --rm --name=dev-vault -e 'VAULT_ADDR=http://127.0.0.1:8200' -e 'VAULT_DEV_ROOT_TOKEN_ID=mytoken' -e 'VAULT_TOKEN=mytoken' vault server -dev

# now we can make requests directly to the keyvault container like:
docker exec dev-vault vault kv put secret/hello foo=world