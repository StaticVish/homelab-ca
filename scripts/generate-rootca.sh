mkdir -p /data/keys/$TLD
export ROOT_TOKEN=`jq -c -r '.root_token' /data/keys.json`
vault login $ROOT_TOKEN

vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki
vault write -field=certificate pki/root/generate/internal common_name=$TLD ttl=87600h > /data/keys/$TLD/CA.crt
vault write pki/config/urls issuing_certificates="http://vault:8200/v1/pki/ca" crl_distribution_points="http://vault:8200/v1/pki/crl"
