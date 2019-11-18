# bosh-lite

As the name implies, this is for a local virtualbox-based bosh-lite

[An article on leveraging git submodules](https://chrisjean.com/git-submodules-adding-using-removing-and-updating/)

[BOSH doc on bosh-lite](https://bosh.io/docs/bosh-lite/)

## login

```sh
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=`bosh int ./creds.yml --path /admin_password`
bosh alias-env vbox -e 192.168.50.6 --ca-cert <(bosh int ./creds.yml --path /director_ssl/ca)
```
