# Share WiFi to Ethernet Ubuntu

* if you can - flush/reset iptables rules [check script](./reset_iptables.sh)
* wireless interface: `wlp4s0`
* ethernet interface: `enx00e04c36131b`

* install dhcp server: `sudo apt install isc-dhcp-server`
* edit config: `sudo vi /etc/dhcp/dhcpd.conf`
    * add this: 
    ```
     subnet 10.0.0.0 netmask 255.255.255.0 {
     range 10.0.0.10 10.0.0.20;
      default-lease-time 600;
      max-lease-time 7200;
      option routers 10.0.0.11;
    }
    ```
* edit config: `sudo vi /etc/default/isc-dhcp-server`
    * `INTERFACESv4="enx00e04c36131b"`
* assign ip `sudo ifconfig enx00e04c36131b 10.0.0.11 netmask 255.255.255.0 up`
* run service: `sudo systemctl restart isc-dhcp-server`
* check service running: `sudo systemctl status isc-dhcp-server`
* run command `sudo iptables -t nat -A POSTROUTING -o wlp4s0 -j MASQUERADE`
* replug SLAVE device, now you can connect to it through SSH, check `sudo systemctl status isc-dhcp-server` to see ip and device connection
* network config on SLAVE device: dhcp
    * ```
    auto eth0
        allow-hotplug eth0
        iface eth0 inet dhcp
    ```
* also check that `route -n` on SLAVE device have `10.0.0.11` gateway route
    * `sudo route del -net 0.0.0.0 gw 10.0.0.1 netmask 0.0.0.0 dev eth0`
    * `sudo route add default gw 10.0.0.11`
    
### Reconnection

* `sudo ifconfig enx00e04c36131b 10.0.0.11 netmask 255.255.255.0 up && sudo systemctl restart isc-dhcp-server && sudo systemctl status isc-dhcp-server`
* replug SLAVE device
    
### Usefull links

* https://serverfault.com/questions/181094/how-do-i-delete-a-route-from-linux-routing-table
* https://stackoverflow.com/questions/48500779/isc-dhcp-server-not-starting-error-not-configured-to-listen-to-any-interfaces
* https://ixnfo.com/ustanovka-i-nastroyka-isc-dhcp-server-v-ubuntu.html
