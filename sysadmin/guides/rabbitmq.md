# RabbitMQ installation

* Follow installation steps on [official docs](https://www.rabbitmq.com/download.html)
    * Recommended [Package Cloud Installation](https://www.rabbitmq.com/install-debian.html#apt-packagecloud)
         * 
         ```
        # import PackageCloud signing key
        wget -O - "https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey" | sudo apt-key add -
        ```
        * [Follow this](https://packagecloud.io/rabbitmq/rabbitmq-server/install)
            * `curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | sudo bash`
        * `apt install rabbitmq-server`

## Enable Management UI

**IMPORTANT: CHANGE DEFAULT PASSWORD OR HIDE IT BEHIND NGINX PROXY WITH WEB AUTH**

* [Official docs](https://www.rabbitmq.com/management.html)
* `rabbitmq-plugins enable rabbitmq_management`

## Securing RabbitMQ

* `/etc/rabbitmq` create files:

#### rabbit.config

```
[
        {rabbit, [
            {tcp_listeners, [{"127.0.0.1", 5672}]}
          ]},
    {rabbitmq_management, [
        {listener, [{port, 15672}, {ip, "127.0.0.1"}]}
    ]},
    {kernel, [
        {inet_dist_use_interface,{127,0,0,1}}
    ]}
].
```

#### rabbitmq-env.conf

```
export RABBITMQ_NODENAME=rabbit@localhost
export RABBITMQ_NODE_IP_ADDRESS=127.0.0.1
export ERL_EPMD_ADDRESS=127.0.0.1
export RABBITMQ_CONFIG_FILE="/etc/rabbitmq/rabbit"
```

* restart `service rabbitmq-server restart`
* EPMD need to be restarted manually/separately (e.g. reboot)
    * if you don't need any Federated nodes you **MUST** set EPMD ADDRESS to localhost too

### Useful links

* [How do I make RabbitMQ listen only to localhost?](https://serverfault.com/questions/235669/how-do-i-make-rabbitmq-listen-only-to-localhost)
* [rabbimq_on_localhost.txt](https://gist.github.com/marcinantkiewicz/e502f241c728533ce82f)


