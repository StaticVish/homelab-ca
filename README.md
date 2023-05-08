# Self Hosted CA with Vault + Consul and Docker.

This is a Self hosted CA. 

1. Spin the infrastruture with  `docker-compose`
2. If you do not have the Vault cli in your machine then build the `Dockerfile` in `setup` folder.
3. Run the Client Image to trigger the scripts.
4. Remember to mount external filesystem under `/data `


## Known Bugs
1. The scripts do not run inside the container there is some issue with the escaping of @ charecters
2. Workaround will be to run the commands manually.



## Refrence
- https://holdmybeersecurity.com/2020/07/09/install-setup-vault-for-pki-nginx-docker-becoming-your-own-ca/