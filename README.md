# Debian Webserver — Grundeinrichtung
Simple but useful maintenance scripts (useful at least on debian systems)

## configure locales (maybe that’s just an Host-Europe VServer issue)
```bash
dpkg-reconfigure locales
```

## SSH-User anlegen

```bash
# login to remote server
ssh root@server

# create a new user
adduser mynewuser

```

## (optional) sudo-rechte vergeben

```bash
# add to sudoers group
usermod -aG sudo mynewuser

# verify that the new account has sudo rights:
su - mynewuser
sudo whoami # should return "root"
```

## set users main group to www-data
```bash
usermod -g www-data mynewuser
```

## Root user für den remote zugriff sperren
Bevor dieser Schritt durchgeführt wird sollte sichergestellt werden, dass ein funktionierender Account mit SSH-Access besteht. Also vorsichtshalber mit `ssh mynewuser@server` die Zugriffsberechtigung verifizieren.

```bash
# edit ssh configuration
vim /etc/ssh/sshd_config
```

und darin `PermitRootLogin = no` setzen.
Anschließend muss der ssh-service neu gestartet werden:

```bash
# restart ssh service
/etc/init.d/ssh restart
```

## Passwortlosen Zugriff einrichten
(todo)

## certbot konfigurieren
(todo)

## Cronjobs und Backup einrichten
```bash
MAILTO=mail@address.abc

# db backup every day
18 5 * * * /root/scripts/backup_databases.sh

# files backup once a week 
0 5 * * 1 /root/scripts/backup_vhosts.sh

# check for certificate renewal once a week
0 0 * * MON /usr/bin/certbot renew
```
The given intervals are examples only. Intervals depend on requirements.
If you don't know the crontab interval syntax see https://crontab.guru for details.
