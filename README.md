# **Jenkins Authentik Auth Demo**

This repository contains a docker compose file that starts up Jenkins backed by Authentik OAuth2 authentication. The Jenkins server uses JCasC plugin to configure Jenkins on startup.

This demo repo is created for testing purposes. The actual usage can be seen in [NIXKnight/Linux-Firewall-Gateway](https://github.com/NIXKnight/Linux-Firewall-Gateway).

Ensure that `/etc/hosts` file contains the following host mapping:
```text
127.0.0.1 authentik-server
```

Start up:
```console
docker compose up -d
```

And then apply Terraform/OpenTofu under the terraform directory.
