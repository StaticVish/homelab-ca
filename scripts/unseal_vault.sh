vault operator init -format=json -key-shares 5 -key-threshold 3 | sponge /data/keys.json
for I in `jq -c -r '.unseal_keys_b64[]' /data/keys.json | head -n 3`
do
  vault operator unseal $I
done
vault status -format=json | jq '.sealed'