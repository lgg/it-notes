# Kamailio installation

## Table of content

<!-- START doctoc -->
<!-- END doctoc -->

## Overview

//TODO: add kamailio description and usage examples

## Requirements

Recommended: 1gb ram VPS

* kamailio
* kamailio tls/mysql and other modules
* mysql-server
    * also you can use other database, [check modules list for your database support](https://kamailio.org/docs/modules/stable/)
* rtpproxy

## Installation

[Official wiki](https://www.kamailio.org/wiki/install/stable/debian)

* `apt install mysql-server rtpproxy kamailio kamailio-mysql-modules kamailio-extra-modules kamailio-mysql-modules kamailio-presence-modules kamailio-tls-modules`

* Install mysql-server
    * set mysql root password
* check that mysql is running: `netstat -lntup | grep mysql`
    * you should get: `tcp 0 0 127.0.0.1:3306 0.0.0.0:* LISTEN 20434/mysqld`

## Edit kamailio config

### Edit kamctl

* `vi /etc/kamailio/kamctlrc`
* Uncomment and set:
```
SIP_DOMAIN=yourhostORip
DBENGINE=MYSQL

## database host
DBHOST=localhost

## database name (for ORACLE this is TNS name)
DBNAME=kamailio

## database read/write user
DBRWUSER="kamailio"

## password for database read/write user
DBRWPW="kamailiorwsupersecretpass"

## database read only user
DBROUSER="kamailioro"

## password for database read only user
DBROPW="kamailiorosupersecretpass"

STORE_PLAINTEXT_PW=0
```
* initiate database for kamailio: `kamdbctl create`
    * `Install presence related tables? (y/n): y`
    * ```Install tables for imc cpl siptrace domainpolicy carrierroute
                       userblacklist htable purple uac pipelimit mtree sca mohqueue
                       rtpproxy? (y/n): y```
    * ```Install tables for uid_auth_db uid_avp_db uid_domain uid_gflags
                       uid_uri_db? (y/n): y```

### Edit kamailio.cfg

* vi `/etc/kamailio/kamailio.cfg`
* add to the top of file after `#!KAMAILIO`, so the top of your config will be look like:
```
#!KAMAILIO
#define WITH_DEBUG
#!define WITH_MYSQL
#!define WITH_AUTH
#!define WITH_USRLOCDB
#!define WITH_NAT
#!define WITH_TLS
```

* Explaining parameters:
    * `#define WITH_DEBUG` - snippet for easy turn on kamailio in debug mode
        * change it to `#!define WITH_DEBUG` and restart kamailio for debug mode
    * `#!define WITH_MYSQL` - enable mysql using
    * `#!define WITH_AUTH` - enable authentication
    * `#!define WITH_USRLOCDB` - enable persistent user location
    * `#!define WITH_NAT` - enables NAT traversal and rtpproxy, [read more here](https://www.kamailio.org/docs/modules/stable/modules/rtpproxy.html)
    * `#!define WITH_TLS` - enables TLS

### Change ports and define interfaces

I recommend to comment `#port=5060` and manually add ip:port to listen, e.g:
```
listen=tcp:YOURSERVEIP:55060
listen=udp:YOURSERVEIP:55060
listen=tls:YOURSERVEIP:55061
```

## Set RTPproxy

apt install rtpproxy

in `/etc/kamailio/kamailio.cfg` 
edit modparam("rtpproxy", "rtpproxy_sock", "unix:/var/run/rtpproxy/rtpproxy.sock")

https://richardskingdom.net/howto-kamailio-sip-proxy-nat-debian-wheezy


Make RTPProxy and Kamailio talk to each other

RTPProxy helps Kamailio work around Network Address Translators (NATs). Trouble is, RTPProxy is configured to listen on a Unix socket by default, whereas Kamailio expects to talk to a UDP port bound to the external IP address of your host. You can change either of these configurations to make the two speak to each other.

Using a Unix socket

In /etc/default/rtpproxy, add:

USER=kamailio
GROUP=kamailio

Running RTPProxy as the Kamailio user lets Kamailio talk to its scoket without permissions problems.

In /etc/kamailio/kamailio.cfg, comment out this line by putting a # as its first character, vis:

#modparam("rtpproxy", "rtpproxy_sock", "udp:127.0.0.1:7722")

and set this line just below it instead:

modparam("rtpproxy", "rtpproxy_sock", "unix:/var/run/rtpproxy/rtpproxy.sock")

Using a UDP port

This is what Kamailio expects by default. To make it happen, in /etc/default/rtpproxy, set:

CONTROL_SOCK=udp:127.0.0.1:7722
EXTRA_OPTS="-l <IP-address>"

Where <IP-address> is the external IP address of your host.

Either way should work. Don’t do both, obviously, or you’ll just have the same problem in reverse!

## Configure TLS

//TODO ADD

## Add users

kamctl add alice secret

## Add clients

//todo connect softphones

## Notes

### About debug

Pay attention that if `log_stderror=yes`
https://github.com/kamailio/kamailio/issues/1070

## Troubleshooting

### Kamailio failed to autostart on reboot with MySQL database

https://github.com/kamailio/kamailio/issues/925

### Passwords length

https://github.com/kamailio/kamailio/pull/779
* max size is 64
* how to increase them

### No sound / one way sound

* check packets on your port `tcpdump port 5060 -v -i eth0`
    * `5060` - your port
    * `eth0` - your network interface
* check NAT
* check firewall
* check codecs

## SoftPhones

//TODO: add softphones





PSTN

if (strempty($sel(cfg_get.pstn.gw_port))) {
                # I MODIFED THIS!!!
                $du = "sip:IPADDRHERE:5060;transport=tcp";
                forward();


                $ru = "sip:" + $rU + "@" + $sel(cfg_get.pstn.gw_ip);
        } else {
                $ru = "sip:" + $rU + "@" + $sel(cfg_get.pstn.gw_ip) + ":"
                                        + $sel(cfg_get.pstn.gw_port);
        }
