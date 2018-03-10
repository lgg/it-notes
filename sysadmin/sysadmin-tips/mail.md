# Mail

## Content

* [Email-forwarding](#email-forwarding)
* [Answering from your mail through GMAIL](#answering-from-your-mail-through-gmail)

## Email-forwarding

### Configuring DNS on Digital Ocean
Understanding how to properly configure the DNS entries in the panel could be a bit tricky if it’s not your daily bread. In particular there is a Digital Ocean configuration that assumes certain things about your droplet, so it’s better to configure it properly.

For example the droplet name should not be casual, but it should match your domain name: I initially called my host “andreagrandi” and I had to rename it to “andreagrandi.it” to have the proper PTR values.

You will need to create at least a “mail” record, pointing to your IP and an “MX” record pointing to mail.yourdomain.com. (please note the dot at the end of the domain name). Here is the configuration of my own droplet (you will notice also a CNAME record. You need it if you want www.yourdomain.com to correctly point to your ip.

![Dns on DO](/files/email-forwarding-dns-do.jpg)

### Configuring Postfix
In my case I only needed some aliases that I use to forward emails to my GMail account, so the configuration is quite easy. First you need to install Postfix:

``` sudo apt-get install postfix ```

Then you need to edit **/etc/postfix/main.cf** customizing myhostname with your domain name and add **virtual_alias_maps** and **virtual_alias_domains** parameters. 
Please also check that **mynetworks** is configured exactly as I did, or you will make your mail server vulnerable to spam bots. 
You can see my complete configuration here:

```
myhostname = andreagrandi.it
smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no

# TLS parameters
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_use_tls=yes
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

# See /usr/share/doc/postfix/TLS_README.gz in the postfix-doc package for
# information on enabling SSL in the smtp client.

smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_una
uth_destination
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
virtual_alias_domains = andreagrandi.it
virtual_alias_maps = hash:/etc/postfix/virtual
myorigin = /etc/mailname
mydestination = andreagrandi, localhost.localdomain, localhost
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
```

Add your email aliases

Edit **/etc/postfix/virtual** file and add your aliases, one per line, like in this example:

```
info@yourdomain.com youremail@gmail.com
sales@yourdomain.com youremail@gmail.com
```

At this point update the alias map and reload Postfix configuration:

```
sudo postmap /etc/postfix/virtual
sudo /etc/init.d/postfix reload
```

### To set multiply domains just:
* vim main.cf and add domains **virtual_alias_domains=domain2.com, domain3.com**
* vim virtual and add new domains
* sudo postmap /etc/postfix/virtual
* sudo /etc/init.d/postfix reload


Original posts: 
[1](https://www.andreagrandi.it/2014/08/31/getting-started-with-digital-ocean-vps-configuring-dns-and-postfix-for-email-forwarding/) and
[2](http://techslides.com/mail-server-for-multiple-domains-with-postfix)

===

## Answering from your mail through GMAIL

1. Go to GMAIL->Settings->Accounts and import
2. In "Send mail as:" click "Add another email address you own"
3. In opened popup input:
	* name: yourmail@yourdomain.com
	* Email address: yourmail@yourdomain.com
	* uncheck "Treat as an alias"
4. On the next step fill:
	* SMTP Server: smtp.gmail.com
	* Username: enter your full @gmail address(e.g myawesomeemail@gmail.com)
	* Password: enter your password !IMPORTANT! if you have enabled 2-step verification, than you need to input your code from code-generator app or from [Google App Passwords setting](https://security.google.com/settings/security/apppasswords)
5. Close window
6. Wait for email(usually 1-3 minutes), follow the link in it, confirm access to use your email as "From"
7. Optional:
	* Create label for this mail
	* Add filter to this mail for markering it with label. [Read more here](https://support.google.com/mail/answer/6579)
	
Used materials from [this answers](http://webapps.stackexchange.com/questions/66228/add-new-alias-to-gmail-without-smtp-forwarding-only-address)