# Linux Network
Linux networks configuration on virtual machines.
## Contents
1. [ipcalc tool](#part-1-ipcalc-tool) 
2. [Static routing between two machines](#part-2-static-routing-between-two-machines) 
3. [iperf3 utility](#part-3-iperf3-utility) 
4. [Network firewall](#part-4-network-firewall) 
5. [Static network routing](#part-5-static-network-routing) 
6. [Dynamic IP configuration using DHCP](#part-6-dynamic-ip-configuration-using-dhcp) 
7. [NAT](#part-7-nat) 
8. [Introduction to SSH Tunnels](#part-8-introduction-to-ssh-tunnels)

## Part 1. **ipcalc** tool
So, let's start our dive into the wonderful world of networks by getting to know IP addresses. And for that we will use **ipcalc** tool.
#### 1.1. Networks and Masks
- Network address of 192.167.38.54/13 &mdash; **192.160.0.0**, can be defined by the command:
  `ipcalc <ipv4_address[/netmask]>`
  Output sample for the entry *192.167.38.54/13*:
  ```bash
  Address:   192.167.38.54        11000000.10100 111.00100110.00110110
  Netmask:   255.248.0.0 = 13     11111111.11111 000.00000000.00000000
  Wildcard:  0.7.255.255          00000000.00000 111.11111111.11111111
  =>
  Network:   192.160.0.0/13       11000000.10100 000.00000000.00000000
  HostMin:   192.160.0.1          11000000.10100 000.00000000.00000001
  HostMax:   192.167.255.254      11000000.10100 111.11111111.11111110
  Broadcast: 192.167.255.255      11000000.10100 111.11111111.11111111
  Hosts/Net: 524286                Class C
  ```
- Conversion of the mask: 
  ```txt
  * 255.255.255.0:
      prefix: 24
      binary: 11111111.11111111.11111111. 00000000
  
  * /15:
      normal: 255.254.0.0
      binary: 11111111.1111111 0.00000000.00000000
  
  * 11111111.11111111.11111111.11110000:
      prefix: 28
      normal: 255.255.255.240
  ```
- Minimum and maximum host in *12.167.38.4* network with masks: 
  ```txt
  Network:   12.0.0.0/8           00001100. 00000000.00000000.00000000
  
  * /8:
  HostMin:   12.0.0.1             00001100. 00000000.00000000.00000001
  HostMax:   12.255.255.254       00001100. 11111111.11111111.11111110
  
  * 11111111.11111111.00000000.00000000
  HostMin:   12.167.0.1           00001100.10100111. 00000000.00000001
  HostMax:   12.167.255.254       00001100.10100111. 11111111.11111110
  
  * 255.255.254.0
  HostMin:   12.167.38.1          00001100.10100111.0010011 0.00000001
  HostMax:   12.167.39.254        00001100.10100111.0010011 1.11111110
  
  * /4:
  HostMin:   0.0.0.1              0000 0000.00000000.00000000.00000001
  HostMax:   15.255.255.254       0000 1111.11111111.11111111.11111110
  ```
#### 1.2. localhost
- There are classifications of IP addresses as "private" and "public". The following ranges of addresses are reserved for private (aka LAN) networks:
  - *10.0.0.0* — *10.255.255.255* (*10.0.0.0/8*),
  - *172.16.0.0* — *172.31.255.255* (*172.16.0.0/12*),
  - *192.168.0.0* — *192.168.255.255* (*192.168.0.0/16*).
  - *127.0.0.0* — *127.255.255.255* (Reserved for loopback interfaces (not used for communication between network nodes), so called localhost)
- So, an application running on localhost can be accessed with examples of the following IPs: 
  - *127.0.0.2*
  - *127.1.0.1*
- And can't be accessed with: 
  - *194.34.23.100*
  - *128.0.0.1*
#### 1.3. Network ranges and segments
- There are examples of the addresses that can be used:
  - only as private: 
    - *10.0.0.45* 
    - *192.168.4.2* 
    - *172.20.250.4* 
    - *172.16.255.255* 
    - *10.10.10.10* 
  - as public and as private:
    - *134.43.0.2* 
    - *172.0.2.1* 
    - *192.172.0.1* 
    - *172.68.0.2* 
    - *192.169.168.1* 
- Examples of possible / not possible gateway IP addresses for *10.10.0.0/18* network: 
  - possible:
    - *10.0.0.1* 
    - *10.10.0.2*
    - *10.10.10.10*
    - *10.10.1.255*
  - not possible:
    - *10.10.100.1*

## Part 2. Static routing between two machines
Now let's figure out how to connect two machines using static routing.
- View existing network interfaces with the `ip a` command:
  - **ws1** and **ws2** have the same output:
    ```bash
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
          valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host 
          valid_lft forever preferred_lft forever
    2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        link/ether 08:00:27:15:61:62 brd ff:ff:ff:ff:ff:ff
        inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
          valid_lft 86355sec preferred_lft 86355sec
        inet6 fe80::a00:27ff:fe15:6162/64 scope link 
          valid_lft forever preferred_lft forever
    3: enp0s8: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
        link/ether 08:00:27:cf:50:d0 brd ff:ff:ff:ff:ff:ff
    ```
- Description of the network interfaces corrsesponding to the internal network on both machines:
  - lo: loopback interface
  - enp0s3: Ethernet interface, PCI location 0, hot plug slot 3
- Set the following addresses and masks: 
  - ws1 - *192.168.100.10*, mask */16*:
    ```yaml
    network:
      ethernets:
        enp0s3:
          dhcp4: true
        enp0s8:
          dhcp4: false
          addresses: [192.168.100.10/16]
      version: 2
    ```
  - ws2 - *172.24.116.8*, mask */12*:
    ```yaml
    network:
      ethernets:
        enp0s3:
          dhcp4: true
        enp0s8:
          dhcp4: false
          addresses: [172.24.116.8/12]
      version: 2    
    ```
- Run the `netplan apply` command to restart the network service.
  There should be no errors.
#### 2.1. Adding a static route manually
- Add a static route from one machine to another and back via:
  `ip r add <ip_address> via <gateway> dev <interface>`
- Ping the connection between the machines
  - ws1:
    ```txt
    mark@ws1:~$ netstat -rn
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
    0.0.0.0         10.0.2.2        0.0.0.0         UG        0 0          0 enp0s3
    10.0.2.0        0.0.0.0         255.255.255.0   U         0 0          0 enp0s3
    10.0.2.2        0.0.0.0         255.255.255.255 UH        0 0          0 enp0s3
    192.168.0.0     0.0.0.0         255.255.0.0     U         0 0          0 enp0s8
    
    mark@ws1:~$ sudo ip route add 172.24.116.8 via 192.168.100.10 dev enp0s8
    mark@ws1:~$ netstat -rn
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
    0.0.0.0         10.0.2.2        0.0.0.0         UG        0 0          0 enp0s3
    10.0.2.0        0.0.0.0         255.255.255.0   U         0 0          0 enp0s3
    10.0.2.2        0.0.0.0         255.255.255.255 UH        0 0          0 enp0s3
    172.24.116.8    192.168.100.10  255.255.255.255 UGH       0 0          0 enp0s8
    192.168.0.0     0.0.0.0         255.255.0.0     U         0 0          0 enp0s8
    
    mark@ws1:~$ ping -c 3 172.24.116.8
    PING 172.24.116.8 (172.24.116.8) 56(84) bytes of data.
    64 bytes from 172.24.116.8: icmp_seq=1 ttl=64 time=0.989 ms
    64 bytes from 172.24.116.8: icmp_seq=2 ttl=64 time=1.11 ms
    64 bytes from 172.24.116.8: icmp_seq=3 ttl=64 time=1.16 ms
    
    --- 172.24.116.8 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2012ms
    rtt min/avg/max/mdev = 0.989/1.083/1.155/0.069 ms
    ```
  - ws2:
    ```txt
    mark@ws2:~$ netstat -rn
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
    0.0.0.0         10.0.2.2        0.0.0.0         UG        0 0          0 enp0s3
    10.0.2.0        0.0.0.0         255.255.255.0   U         0 0          0 enp0s3
    10.0.2.2        0.0.0.0         255.255.255.255 UH        0 0          0 enp0s3
    172.16.0.0      0.0.0.0         255.240.0.0     U         0 0          0 enp0s8
    
    mark@ws2:~$ sudo ip route add 192.168.100.10 via 172.24.116.8 dev enp0s8
    mark@ws2:~$ netstat -rn
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
    0.0.0.0         10.0.2.2        0.0.0.0         UG        0 0          0 enp0s3
    10.0.2.0        0.0.0.0         255.255.255.0   U         0 0          0 enp0s3
    10.0.2.2        0.0.0.0         255.255.255.255 UH        0 0          0 enp0s3
    172.16.0.0      0.0.0.0         255.240.0.0     U         0 0          0 enp0s8
    192.168.100.10  172.24.116.8    255.255.255.255 UGH       0 0          0 enp0s8
    
    mark@ws2:~$ ping -c 3 192.168.100.10
    PING 192.168.100.10 (192.168.100.10) 56(84) bytes of data.
    64 bytes from 192.168.100.10: icmp_seq=1 ttl=64 time=1.06 ms
    64 bytes from 192.168.100.10: icmp_seq=2 ttl=64 time=1.00 ms
    64 bytes from 192.168.100.10: icmp_seq=3 ttl=64 time=1.14 ms
    
    --- 192.168.100.10 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2017ms
    rtt min/avg/max/mdev = 1.001/1.068/1.141/0.057 ms
    ```
But connection, created by this command will disappear after network or system restart.
#### 2.2. Adding a static route with saving
- To do a clean experiment, restart the machines
- Adding static route from one machine to another using *etc/netplan/00-installer-config.yaml* file
  - ws1:
    ```yaml
    network:
      ethernets:
        enp0s3:
          dhcp4: true
        enp0s8:
          dhcp4: false
          addresses: [192.168.100.10/16]
          routes:
            - to:  172.24.116.8
              via: 192.168.100.10
      version: 2
    ```
  - ws2:
    ```yaml
    network:
      ethernets:
        enp0s3:
          dhcp4: true
        enp0s8:
          dhcp4: false
          addresses: [172.24.116.8/12]
          routes:
            - to:  192.168.100.10
              via: 172.24.116.8
      version: 2 
    ```
- Ping the connection between the machines
  - ws1:
    ```txt
    mark@ws1:~$ sudo vim /etc/netplan/00-installer-config.yaml 
    mark@ws1:~$ sudo netplan apply
    mark@ws1:~$ ping -c 3 172.24.116.8
    PING 172.24.116.8 (172.24.116.8) 56(84) bytes of data.
    64 bytes from 172.24.116.8: icmp_seq=1 ttl=64 time=2.44 ms
    64 bytes from 172.24.116.8: icmp_seq=2 ttl=64 time=1.16 ms
    64 bytes from 172.24.116.8: icmp_seq=3 ttl=64 time=0.465 ms
    
    --- 172.24.116.8 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2004ms
    rtt min/avg/max/mdev = 0.465/1.353/2.436/0.816 ms
    ```
  - ws2:
    ```txt
    mark@ws2:~$ sudo vim /etc/netplan/00-installer-config.yaml 
    mark@ws2:~$ sudo netplan apply
    mark@ws2:~$ ping -c 3 192.168.100.10
    PING 192.168.100.10 (192.168.100.10) 56(84) bytes of data.
    64 bytes from 192.168.100.10: icmp_seq=1 ttl=64 time=1.97 ms
    64 bytes from 192.168.100.10: icmp_seq=2 ttl=64 time=1.08 ms
    64 bytes from 192.168.100.10: icmp_seq=3 ttl=64 time=1.07 ms

    --- 192.168.100.10 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2100ms
    rtt min/avg/max/mdev = 1.067/1.372/1.966/0.420 ms
    ```

## Part 3. **iperf3** utility
The most important thing about transferring information between machines is the connection speed. 
We’ll check it with **iperf3** utility.
#### 3.1. Connection speed
- Conversion samples: 
  - 8 Mbps to MB/s: 8 Mbps/ 8 = **1 MB/s**
  - 100 MB/s to Kbps: 100 MB/s * 1000 * 8 = **800000 Kbps**
  - 1 Gbps to Mbps: 1 Gbps * 1000 = **1000 Mbps**

#### 3.2. **iperf3** utility
- Measure connection speed between ws1 and ws2
  The iperf3 executable contains both client and server functionality. 
  So, we have to establish connection between a machine that we define as a server and another one which we define as a client
  - **ws1** we choose as a server, which is indicated by passing the `-s` parameter:
    `iperf3 -s -f <unit_of_measure_for_speed>`
    ```txt
    mark@ws1:~$ iperf3 -s -f M
    -----------------------------------------------------------
    Server listening on 5201
    -----------------------------------------------------------
    ```
  - **ws2**, a client:
    `iperf3 -c <ip_address_of_the_server>`
    ```txt
    mark@ws2:~$ iperf3 -c 192.168.100.10
    Connecting to host 192.168.100.10, port 5201
    [  5] local 172.24.116.8 port 59606 connected to 192.168.100.10 port 5201
    [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
    [  5]   0.00-1.00   sec   398 MBytes  3.33 Gbits/sec  2250    177 KBytes       
    [  5]   1.00-2.00   sec   431 MBytes  3.63 Gbits/sec  2494    191 KBytes       
    [  5]   2.00-3.00   sec   418 MBytes  3.50 Gbits/sec  2881    187 KBytes       
    [  5]   3.00-4.00   sec   421 MBytes  3.53 Gbits/sec  2250    182 KBytes       
    [  5]   4.00-5.00   sec   448 MBytes  3.76 Gbits/sec  2960    230 KBytes       
    [  5]   5.00-6.00   sec   463 MBytes  3.89 Gbits/sec  3193    222 KBytes       
    [  5]   6.00-7.00   sec   430 MBytes  3.61 Gbits/sec  3068    191 KBytes       
    [  5]   7.00-8.00   sec   455 MBytes  3.81 Gbits/sec  3150    215 KBytes       
    [  5]   8.00-9.00   sec   410 MBytes  3.44 Gbits/sec  2033    221 KBytes       
    [  5]   9.00-10.00  sec   398 MBytes  3.33 Gbits/sec  2312    177 KBytes       
    - - - - - - - - - - - - - - - - - - - - - - - - -
    [ ID] Interval           Transfer     Bitrate         Retr
    [  5]   0.00-10.00  sec  4.17 GBytes  3.58 Gbits/sec  26591             sender
    [  5]   0.00-10.00  sec  4.17 GBytes  3.58 Gbits/sec                  receiver
    
    iperf Done.
    ```
  - ws1:
    ```txt
    Accepted connection from 172.24.116.8, port 59594
    [  5] local 192.168.100.10 port 5201 connected to 172.24.116.8 port 59606
    [ ID] Interval           Transfer     Bitrate
    [  5]   0.00-1.00   sec   396 MBytes   396 MBytes/sec                  
    [  5]   1.00-2.00   sec   431 MBytes   431 MBytes/sec                  
    [  5]   2.00-3.00   sec   417 MBytes   417 MBytes/sec                  
    [  5]   3.00-4.00   sec   421 MBytes   421 MBytes/sec                  
    [  5]   4.00-5.00   sec   449 MBytes   449 MBytes/sec                  
    [  5]   5.00-6.00   sec   462 MBytes   462 MBytes/sec                  
    [  5]   6.00-7.00   sec   431 MBytes   431 MBytes/sec                  
    [  5]   7.00-8.00   sec   454 MBytes   454 MBytes/sec                  
    [  5]   8.00-9.00   sec   410 MBytes   410 MBytes/sec                  
    [  5]   9.00-10.00  sec   398 MBytes   398 MBytes/sec                  
    - - - - - - - - - - - - - - - - - - - - - - - - -
    [ ID] Interval           Transfer     Bitrate
    [  5]   0.00-10.00  sec  4.17 GBytes   427 MBytes/sec                  receiver
    -----------------------------------------------------------
    Server listening on 5201
    -----------------------------------------------------------
    ```

## Part 4. Network firewall
After connecting the machines, the next our task is to control the information flowing over the connection. For that we use firewalls.
#### 4.1. **iptables** utility
##### Create a */etc/firewall.sh* file simulating the firewall on ws1 and ws2:
```shell
#!/bin/sh

# Deleting all the rules in the "filter" table (default).
iptables -F
iptables -X
```
- We add the following rules:
  - Open access on the machines for port 22 (ssh) and port 80 (http):
    ```
    iptables -A INPUT -p tcp --dport ssh  -j ACCEPT
    iptables -A INPUT -p tcp --dport http -j ACCEPT
    ```
  - Allow *echo reply* :
    `iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT`
  - Reject *echo reply* :
    `iptables -A OUTPUT -p icmp --icmp-type echo-reply -j REJECT`\
  
  On **ws1** the deny rule comes before the allow, on **ws2** &mdash; vice versa.
- There should be no errors after running the script:
  - ![](screenshots/4.1.png)
  - ![](screenshots/4.2.png)
- In a case of consecutive rules acting on `echo-reply` only a first is applied.
#### 4.2. **nmap** utility
- So, the first machine can't be pinged, but at the same time, by using, **nmap** utility we can show that the machine host is up
  ```
  mark@ws2:~$ nmap 192.168.100.10
  Starting Nmap 7.80 ( https://nmap.org ) at 2023-07-11 03:26 +07
  Nmap scan report for 192.168.100.10
  Host is up (0.00035s latency).
  Not shown: 999 closed ports
  PORT   STATE SERVICE
  22/tcp open  ssh
  
  Nmap done: 1 IP address (1 host up) scanned in 0.08 seconds
  mark@ws2:~$ ping 192.168.100.10
  PING 192.168.100.10 (192.168.100.10) 56(84) bytes of data.
  
  --- 192.168.100.10 ping statistics ---
  10 packets transmitted, 0 received, 100% packet loss, time 9266ms
  ```
- Save dumps of the virtual machine images

## Part 5. Static network routing
So far we have only connected two machines, but now it's time for static routing of the whole network.
We will be configuring a network according to the picture:
![part5_network](../task/misc/images/part5_network.png)

VM internal network setup will look like this:
| net | hosts with direct connection |
| --- | ---------------------------- |
| r1p | ws11, r1                     |
| rsh | r1, r2                       |
| r2p | ws21, ws22, r2               |

where **p** stands for *private* and **sh** for *shared*
- Start five virtual machines (3 workstations (ws11, ws21, ws22) and 2 routers (r1, r2))
- Add to them additional network adapters attached to internal network, while leaving the one already existing as NAT to be able to connect to the machines through ssh so that we are not limited to VM VB terminal possibilites
- For the convenience we can set IP-hostname mapping in */etc/hosts* file for each of the host machines:
  - ws11:
    ```
    10.20.0.10  ws21
    10.20.0.20  ws22
    10.100.0.12 r2
    10.10.0.01  r1
    ```
  - ws21:
    ```
    10.10.0.2   ws11
    10.20.0.20  ws22
    10.20.0.1   r2
    10.100.0.11 r1
    ```
  - ws22:
    ```
    10.10.0.2   ws11
    10.20.0.10  ws21
    10.20.0.1   r2
    10.100.0.11 r1
    ```
  - r1:
    ```
    10.10.0.2   ws11
    10.20.0.10  ws21
    10.20.0.20  ws22
    10.100.0.12 r2
    ```
  - r2:
    ```
    10.10.0.2   ws11
    10.20.0.10  ws21
    10.20.0.20  ws22
    10.100.0.11 r1
    ```
#### 5.1. Configuration of machine addresses
- Set up the machine configurations in *etc/netplan/00-installer-config.yaml* according to the network in the picture.
  - ws11:  
    ```
    network:
      version: 2
      ethernets:
        enp0s3:
          dhcp4: true
        enp0s8:
          match:
            macaddress: 08:00:27:00:b7:a9
          set-name: eth0
          addresses: [10.10.0.2/18]
    ```
  - ws21:
    ```
    network:
      version: 2 
      ethernets:
        enp0s3:
          dhcp4: true
        enp0s8:
          match:
            macaddress: 08:00:27:cf:50:d0
          set-name: eth0
          addresses: [10.20.0.20/26]
    ```
  - ws22:
    ```
    network:
      version: 2
      ethernets:
        enp0s3:
          dhcp4: true
        enp0s8:
          match:
            macaddress: 08:00:27:32:97:cf  
          set-name: eth0
          addresses: [10.20.0.10/26]
    ```
  - r1:
    ```txt
    network:
      version: 2
      ethernets:
        enp0s3:
          dhcp4: true
        enp0s8:
          match:
            macaddress: 08:00:27:01:5f:9a
          set-name: eth0
          addresses: [10.10.0.1/18]
        enp0s9:
          match:
            macaddress: 08:00:27:73:bc:91
          set-name: eth1
          addresses: [10.100.0.11/16]
    ```
  - r2:
    ```
    network:
      version: 2
      ethernets:
        enp0s3:
          dhcp4: true
        enp0s8:
          match:
            macaddress: 08:00:27:b5:31:09
          set-name: eth0 
          addresses: [10.100.0.12/16]
        enp0s9:
          match:
            macaddress: 08:00:27:94:7c:34 
          set-name: eth1
            addresses: [10.20.0.1/26]
      
    ```
- Check that there is no errors:
  - Restart the network service. 
  - If there are no errors, check that the machine address is correct with the `ip a | grep <inteface>` command:
    - ws11:
      ```
      mark@ws11:~$ ip a | grep eth0
      3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
          inet 10.10.0.2/18 brd 10.10.63.255 scope global eth0
      ```
    - ws21:
      ```
      mark@ws21:~$ ip a | grep eth0
      3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
          inet 10.20.0.10/26 brd 10.20.0.63 scope global eth0
      ```
    - ws22:
      ```
      mark@ws22:~$ ip a | grep eth0
      3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
          inet 10.20.0.20/26 brd 10.20.0.63 scope global eth0
      ```
    - r1:
      ```
      mark@r1:~$ ip a | grep 'eth[0,1]'
      3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
          inet 10.10.0.1/18 brd 10.10.63.255 scope global eth0
      4: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
          inet 10.100.0.11/16 brd 10.100.255.255 scope global eth1
      ```
    - r2:
      ```
      mark@r2:~$ ip a | grep 'eth[0,1]'
      3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
          inet 10.100.0.12/16 brd 10.100.255.255 scope global eth0
      4: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
          inet 10.20.0.1/26 brd 10.20.0.63 scope global eth1
      ```
  - Ping **ws22** from **ws21**:
    ```txt
    mark@ws21:~$ ping -c3 ws22
    PING ws22 (10.20.0.20) 56(84) bytes of data.
    64 bytes from ws22 (10.20.0.20): icmp_seq=1 ttl=64 time=1.91 ms
    64 bytes from ws22 (10.20.0.20): icmp_seq=2 ttl=64 time=0.618 ms
    64 bytes from ws22 (10.20.0.20): icmp_seq=3 ttl=64 time=1.09 ms
    
    --- ws22 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2019ms
    rtt min/avg/max/mdev = 0.618/1.204/1.906/0.532 ms
    ```
  - Ping **r1** from **ws11**:
    ```txt
    mark@ws11:~$ ping -c3 r1
    PING r1 (10.10.0.1) 56(84) bytes of data.
    64 bytes from r1 (10.10.0.1): icmp_seq=1 ttl=64 time=1.21 ms
    64 bytes from r1 (10.10.0.1): icmp_seq=2 ttl=64 time=1.32 ms
    64 bytes from r1 (10.10.0.1): icmp_seq=3 ttl=64 time=1.31 ms
    
    --- r1 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2125ms
    rtt min/avg/max/mdev = 1.208/1.279/1.320/0.050 ms
    ```
#### 5.2. Enabling IP forwarding.
- To check whether IP forwarding is turned on or off, run the following command:
  `sysctl net.ipv4.ip_forward`
- To enable IP forwarding temporarily, run the following command on the routers:
  `sysctl -w net.ipv4.ip_forward=1`.
  *With this approach, the forwarding will not work after the system is rebooted.*
  - r1:
    ```
    mark@r1:~$ sudo sysctl -w net.ipv4.ip_forward=1
    net.ipv4.ip_forward = 1
    ```
  - r2:
    ```
    mark@r2:~$ sudo sysctl -w net.ipv4.ip_forward=1
    net.ipv4.ip_forward = 1
    ```
- To enable IP forwarding permanently, open */etc/sysctl.conf* file and uncomment the following line iside it:
  `# net.ipv4.ip_forward=1`
#### 5.3. Default route configuration
- Configure the default route (gateway) for the workstations. To do this, add `default` before the router's IP to the interface at the end of the configuration file:
  - ws11:
    ```
    ---x---
          routes:
            - to:  default
              via: 10.10.0.1
    ```
  - ws21:
    ```
    ---x---
          routes:
            - to:  default
              via: 10.20.0.1
    ```
  - ws22:
    ```
    ---x---
          routes:
            - to:  default
              via: 10.20.0.1
    ```
- Call `ip r | grep eth0` and check that a route is added to the routing table:
  - ws11:
    ```
    default via 10.10.0.1 dev eth0 proto static 
    10.10.0.0/18 dev eth0 proto kernel scope link src 10.10.0.2
    ```
  - ws21:
    ```
    default via 10.20.0.1 dev eth0 proto static 
    10.20.0.0/26 dev eth0 proto kernel scope link src 10.20.0.10 
    ```
  - ws22:
    ```
    default via 10.20.0.1 dev eth0 proto static 
    10.20.0.0/26 dev eth0 proto kernel scope link src 10.20.0.20 
    ```
- Ping r2 router from ws11 and show on r2 that the ping is reaching. To do this, use the `tcpdump ip -tn -i r2` command
> where 
> ip  prints only IPv4 packets
                     -t  don't print a timestamp on each dump line.
        -n  don't convert addresses (i.e., host addresses, port numbers,  etc.) to names.     
<font size="1"> 
  ```
  where ip  prints only IPv4 packets
        -t  don't print a timestamp on each dump line.
        -n  don't convert addresses (i.e., host addresses, port numbers,  etc.) to names.     
  ```
</font>

  - ws1:
    ```
    mark@ws11:~$ ping -c3 r2
    PING r2 (10.100.0.12) 56(84) bytes of data.

    --- r2 ping statistics ---
    3 packets transmitted, 0 received, 100% packet loss, time 2034ms

    ```
  - r2:
    ```
    mark@r2:~$ sudo tcpdump -tn -i eth0 ip
    tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
    listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
    IP 10.10.0.2 > 10.100.0.12: ICMP echo request, id 31, seq 1, length 64
    IP 10.10.0.2 > 10.100.0.12: ICMP echo request, id 31, seq 2, length 64
    IP 10.10.0.2 > 10.100.0.12: ICMP echo request, id 31, seq 3, length 64
    ^C
    3 packets captured
    3 packets received by filter
    0 packets dropped by kernel
    ```
#### 5.4. Adding static routes
##### Add static routes to r1 and r2 in configuration file. Here is an example for r1 route to 10.20.0.0/26:
```shell
# Add description to the end of the eth1 network interface:
- to: 10.20.0.0
  via: 10.100.0.12
```

- Add screenshots of the changed *etc/netplan/00-installer-config.yaml* file for each router to the report.

##### Call `ip r` and show route tables on both routers. Here is an example of the r1 table:
```
10.100.0.0/16 dev eth1 proto kernel scope link src 10.100.0.11
10.20.0.0/26 via 10.100.0.12 dev eth1
10.10.0.0/18 dev eth0 proto kernel scope link src 10.10.0.1
```
- Add a screenshot with the call and output of the used command to the report.
##### Run `ip r list 10.10.0.0/[netmask]` and `ip r list 0.0.0.0/0` commands on ws11.
- Add a screenshot with the call and the output of the used commands to the report.
- Explain in the report why a different route other than 0.0.0.0/0 had been selected for 10.10.0.0/\[netmask\] although it could be the default route.

#### 5.5. Making a router list
Here is an example of the **traceroute** utility output after adding a gateway:
```
1 10.10.0.1 0 ms 1 ms 0 ms
2 10.100.0.12 1 ms 0 ms 1 ms
3 10.20.0.10 12 ms 1 ms 3 ms
```
##### Run the `tcpdump -tnv -i eth0` dump command on r1
##### Use **traceroute** utility to list routers in the path from ws11 to ws21
- Add a screenshots with the call and the output of the used commands (tcpdump and traceroute) to the report.
- Based on the output of the dump on r1, explain in the report how path construction works using **traceroute**.

#### 5.6. Using **ICMP** protocol in routing
##### Run on r1 network traffic capture going through eth0 with the
`tcpdump -n -i eth0 icmp` command.

##### Ping a non-existent IP (e.g. *10.30.0.111*) from ws11 with the
`ping -c 1 10.30.0.111` command.
- Add a screenshot with the call and the output of the used commands to the report.

##### Save dumps of the virtual machine images
**p.s. Do not upload dumps to git under any circumstances!**

## Part 6. Dynamic IP configuration using **DHCP**
Our next step is to learn more about **DHCP** service, which you already know.
##### For r2, configure the **DHCP** service in the */etc/dhcp/dhcpd.conf* file:

##### 1) specify the default router address, DNS-server and internal network address. Here is an example of a file for r2:
```shell
subnet 10.100.0.0 netmask 255.255.0.0 {}

subnet 10.20.0.0 netmask 255.255.255.192
{
    range 10.20.0.2 10.20.0.50;
    option routers 10.20.0.1;
    option domain-name-servers 10.20.0.1;
}
```
##### 2) write `nameserver 8.8.8.8.` in a *resolv.conf* file
- Add screenshots of the changed files to the report.
##### Restart the **DHCP** service with `systemctl restart isc-dhcp-server`. Reboot the ws21 machine with `reboot` and show with `ip a` that it has got an address. Also ping ws22 from ws21.
- Add a screenshot with the call and the output of the used commands to the report.

##### Specify MAC address at ws11 by adding to *etc/netplan/00-installer-config.yaml*:
`macaddress: 10:10:10:10:10:BA`, `dhcp4: true`
- Add a screenshot of the changed *etc/netplan/00-installer-config.yaml* file to the report.
##### Сonfigure r1 the same way as r2, but make the assignment of addresses strictly linked to the MAC-address (ws11). Run the same tests
- Describe this part in the report the same way as for r2.
##### Request ip address update from ws21
- Add screenshots of ip before and after update to the report
- Describe in the report what **DHCP** server options were used in this point.

##### Save dumps of virtual machine images
**p.s. Do not upload dumps to git under any circumstances!**

## Part 7. **NAT**

And finally, the cherry on the cake, let me tell you about network address translation mechanism.

**== Task ==**

*In this task you need to use virtual machines from Part 5*

##### In */etc/apache2/ports.conf* file change the line `Listen 80` to `Listen 0.0.0.0:80`on ws22 and r1, i.e. make the Apache2 server public
- Add a screenshot of the changed file to the report
##### Start the Apache web server with `service apache2 start` command on ws22 and r1
- Add screenshots with the call and the output of the used command to the report.

##### Add the following rules to the firewall, created similarly to the firewall from Part 4, on r2:
##### 1) delete rules in the filter table - `iptables -F`
##### 2) delete rules in the "NAT" table - `iptables -F -t nat`
##### 3) drop all routed packets - `iptables --policy FORWARD DROP`
##### Run the file as in Part 4
##### Check the connection between ws22 and r1 with the `ping` command
*When running the file with these rules, ws22 should not ping from r1*
- Add screenshots with the call and the output of the used command to the report.
##### Add another rule to the file:
##### 4) allow routing of all **ICMP** protocol packets
##### Run the file as in Part 4
##### Check connection between ws22 and r1 with the `ping` command
*When running the file with these rules, ws22 should ping from r1*
- Add screenshots with the call and the output of the used command to the report.
##### Add two more rules to the file:
##### 5) enable **SNAT**, which is masquerade all local ip from the local network behind r2 (as defined in Part 5 - network 10.20.0.0)
*Tip: it is worth thinking about routing internal packets as well as external packets with an established connection*
##### 6) enable **DNAT** on port 8080 of r2 machine and add external network access to the Apache web server running on ws22
*Tip: be aware that when you will try to connect, there will be a new tcp connection for ws22 and port 80
- Add a screenshot of the changed file to the report
##### Run the file as in Part 4
*Before testing it is recommended to disable the **NAT** network interface in VirtualBox (its presence can be checked with `ip a` command), if it is enabled*
##### Check the TCP connection for **SNAT** by connecting from ws22 to the Apache server on r1 with the `telnet [address] [port]` command
##### Check the TCP connection for **DNAT** by connecting from r1 to the Apache server on ws22 with the `telnet` command (address r2 and port 8080)
- Add screenshots with the call and the output of the used commands to the report.

##### Save dumps of virtual machine images
**p.s. Do not upload dumps to git under any circumstances!**

## Part 8. Introduction to **SSH Tunnels**
If you need to have an access to a closed network to get to a project &mdash; **SSH Tunnel** &mdash; this is what you need.
*In this task you need to use virtual machines from Part 5*
##### Run a firewall on r2 with the rules from Part 7
##### Start the **Apapche** web server on ws22 on localhost only (i.e. in */etc/apache2/ports.conf* file change the line `Listen 80` to `Listen localhost:80`)
##### Use *Local TCP forwarding* from ws21 to ws22 to access the web server on ws22 from ws21
##### Use *Remote TCP forwarding* from ws11 to ws22 to access the web server on ws22 from ws11
##### To check if the connection worked in both of the previous steps, go to a second terminal (e.g. with the Alt + F2) and run the `telnet 127.0.0.1 [local port]` command.
- In the report, describe the commands that you need for doing these 4 steps and add screenshots of their call and output.

##### Save dumps of virtual machine images
**p.s. Do not upload dumps to git under any circumstances!**
