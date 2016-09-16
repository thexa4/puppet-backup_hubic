#Backup Hubic
Configures (thexa4/backup)[https://forge.puppet.com/thexa4/backup] to backup to Hubic. Uses [secrets_server](https://forge.puppet.com/thexa4/secrets_server) to fetch credentials so you don't need to store hubic credentials on your vps.

##Setup
You can set the following properties.

* `$client_id`
* `$client_secret`
* `$secret_host`
* `$ca = '/etc/ssl/certs/host-ca.crt'`
* `$cert = '/etc/ssl/certs/host.crt'`
* `$key = '/etc/ssl/private/host.key'`

You can get a client_id and client_secret by going to your Hubic account manager and registering an application with a redirect url of for example https://www.example.com/local. The redirect url can be changed in the share/hubic file. If everything works correctly no request should be made to the redirect url, the token should be intercepted before that.

You need a configured [secrets_server](https://forge.puppet.com/thexa4/secrets_server) with the hubic module. You can find this module in share/hubic. Please change the top four values before use.

##Usage
This module will fetch an authentication token from the secrets_server. Please configure secrets_server to allow regeneration of hubic secrets by adding "hubic" to the allow_regen setting.

##Disaster recovery
If you've lost your machine, follow the following instructions:

1. Rebuild the machine using puppet
2. Run `duply default restore /root/backup` to restore the previous backup to /root/backup
3. Place everything where it belongs and remove the /root/backup folder when you're done to prevent it from recursively backing itself up.

If you're using this to back up the secrets_server, make sure you copy the gpg key in `/etc/duply/default/gpg.<fqdn>.*.asc` to a safe location like a password manager. You can then use the backup of the secrets server to get back the gpg keys of other hosts.
