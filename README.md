# zabbix-syslog-ng
Zabbix syslog-ng monitoring

## Installation
1. Install `zabbix_syslog_ng.sh` script:
```
cp zabbix_syslog_ng.sh /usr/local/bin/zabbix_syslog_ng.sh
chmod a+rx /usr/local/bin/zabbix_syslog_ng.sh
```
2. Allow zabbix user to run `zabbix_syslog_ng.sh` as root
```
cp sudoers /etc/sudoers.d/zabbix_syslog_ng.sh
```
3. Add syslog-ng specific *UserParameter*s to zabbix-agent:
```
cp syslog-ng.conf /etc/zabbix/zabbix_agentd.d/
```
4. Install dependencies (sudo, jq, ...)

### Requirements
 - zabbix 4.0 or newer
