# zabbix-syslog-ng
Zabbix syslog-ng monitoring

## Installation
1. Install `zabbix-syslog-ng.sh` script:
```
cp zabbix-syslog-ng.sh /usr/local/bin/zabbix-syslog-ng.sh
chmod a+rx /usr/local/bin/zabbix-syslog-ng.sh
```
2. Allow zabbix user to run `zabbix-syslog-ng.sh` as root
```
cp sudoers /etc/sudoers.d/zabbix-syslog-ng.sh
```
3. Add syslog-ng specific *UserParameter*s to zabbix-agent:
```
cp syslog-ng.conf /etc/zabbix/zabbix_agentd.d/
```
4. Install dependencies (sudo, jq, ...)

### Requirements
 - zabbix 4.0 or newer
