mkdir -p /data/keys/$TLD
export ROOT_TOKEN=`jq -c -r '.root_token' /data/keys.json`
vault login $ROOT_TOKEN

vault secrets enable -path=pki_int pki
vault secrets tune -max-lease-ttl=43800h pki_int

vault write -format=json pki_int/intermediate/generate/internal common_name="$TLD Intermediate Authority" | jq -r '.data.csr' > /data/keys/$TLD/pki_intermediate.csr
vault write -format=json pki/root/sign-intermediate csr=\@/data/keys/$TLD/pki_intermediate.csr format=pem_bundle ttl="43800h" | jq -r '.data.certificate' > /data/keys/$TLD/intermediate.crt

vault write pki_int/intermediate/set-signed certificate=@/data/keys/$TLD/intermediate.crt
vault write pki_int/roles/$TLD allowed_domains="$TLD" allow_subdomains=true max_ttl="8760h"
vault write -format=json pki_int/issue/$TLD common_name="*.$TLD" ttl="8760h" > /data/keys/$TLD/wildcard_$TLD.json

cat /data/keys/$TLD/wildcard_$TLD.json | jq -r '.data.private_key' > /data/keys/$TLD/wildcard_$TLD.pem
cat /data/keys/$TLD/wildcard_$TLD.json | jq -r '.data.certificate' > /data/keys/$TLD/wildcard_$TLD.crt
