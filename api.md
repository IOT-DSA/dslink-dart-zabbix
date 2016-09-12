 <pre>
-[root](#root)
 |-[@Add_Connection(name, address, username, password, refreshRate)](#add_connection)
 |-[ZabbixNode](#zabbixnode)
 | |-[@Refresh_Hosts()](#refresh_hosts)
 | |-[@Remove_Connection()](#remove_connection)
 | |-[@Edit_Connection(address, username, password, refreshRate)](#edit_connection)
 | |-[HostGroups](#hostgroups)
 | | |-[@Create_Hostgroup(name)](#create_hostgroup)
 | | |-[ZabbixHostGroup](#zabbixhostgroup)
 | | | |-[flags](#flags) - string
 | | | |-[internal](#internal) - bool
 | | | |-[@Rename_Hostgroup(name)](#rename_hostgroup)
 | | | |-[@Delete_Hostgroup()](#delete_hostgroup)
 | | | |-[ZabbixHost](#zabbixhost)
 | | | | |-[hostId](#hostid) - string
 | | | | |-[available](#available) - string
 | | | | |-[description](#description) - string
 | | | | |-[disable_until](#disable_until) - string
 | | | | |-[error](#error) - string
 | | | | |-[error_from](#error_from) - string
 | | | | |-[flags](#flags) - string
 | | | | |-[IPMI](#ipmi) - string
 | | | | | |-[ipmi_authtype](#ipmi_authtype) - enum[default,none,MD2,MD5,straight,OEM,RMCP+]
 | | | | | |-[ipmi_disable_until](#ipmi_disable_until) - string
 | | | | | |-[ipmi_error](#ipmi_error) - string
 | | | | | |-[ipmi_password](#ipmi_password) - string
 | | | | | |-[ipmi_privlege](#ipmi_privlege) - enum[callback,user,operator,admin,OEM]
 | | | | | |-[ipmi_username](#ipmi_username) - string
 | | | | |-[JMX](#jmx) - string
 | | | | | |-[jmx_disable_until](#jmx_disable_until) - string
 | | | | | |-[jmx_error](#jmx_error) - string
 | | | | | |-[jmx_error_from](#jmx_error_from) - string
 | | | | |-[maintenanceid](#maintenanceid) - string
 | | | | | |-[maintenance_from](#maintenance_from) - string
 | | | | | |-[maintenance_status](#maintenance_status) - string
 | | | | | |-[maintenance_type](#maintenance_type) - string
 | | | | |-[name](#name) - string
 | | | | |-[proxy_hostid](#proxy_hostid) - string
 | | | | |-[SNMP](#snmp) - string
 | | | | | |-[snmp_disable_until](#snmp_disable_until) - string
 | | | | | |-[snmp_error](#snmp_error) - string
 | | | | | |-[snmp_errors_from](#snmp_errors_from) - string
 | | | | |-[status](#status) - enum[Monitored,Unmonitored]
 | | | | |-[Items](#items)
 | | | | | |-[ZabbixItem](#zabbixitem)
 | | | | | | |-[itemid](#itemid) - string
 | | | | | | |-[delay](#delay) - number
 | | | | | | |-[hostid](#hostid) - string
 | | | | | | |-[interfaceid](#interfaceid) - string
 | | | | | | |-[key](#key) - string
 | | | | | | |-[name](#name) - string
 | | | | | | |-[type](#type) - enum[Zabbix Agent,SNMPv1 Agent,Zabbix Trapper,Simple Check,SNMPv2 Agent,Zabbix Internal,SNMPv3 Agent,Zabbix Agent (active),Zabbix Aggregate,Web Item,External Clock,Database Monitor,IPMI Agent,SSH Agent,Telnet Agent,Calculated,JMX Agent,SNMP Trap]
 | | | | | | |-[value_type](#value_type) - enum[Numeric float,Character,Log,Numeric unsigned,text]
 | | | | | | |-[authtype](#authtype) - enum[password,public key]
 | | | | | | |-[data_type](#data_type) - enum[decimal,octal,hexadecimal,boolean]
 | | | | | | |-[delay_flex](#delay_flex) - string
 | | | | | | |-[delta](#delta) - enum[as is,Delta (speed per second),Delta (simple change)]
 | | | | | | |-[description](#description) - string
 | | | | | | |-[error](#error) - string
 | | | | | | |-[flags](#flags) - string
 | | | | | | |-[formula](#formula) - number
 | | | | | | |-[history](#history) - number
 | | | | | | |-[inventory_link](#inventory_link) - number
 | | | | | | |-[ipmi_sensor](#ipmi_sensor) - string
 | | | | | | |-[lastclock](#lastclock) - string
 | | | | | | |-[lastns](#lastns) - number
 | | | | | | |-[lastvalue](#lastvalue) - string
 | | | | | | |-[logtimefmt](#logtimefmt) - string
 | | | | | | |-[mtime](#mtime) - string
 | | | | | | |-[multiplier](#multiplier) - number
 | | | | | | |-[params](#params) - string
 | | | | | | |-[password](#password) - string
 | | | | | | |-[port](#port) - string
 | | | | | | |-[prevvalue](#prevvalue) - string
 | | | | | | |-[privatekey](#privatekey) - string
 | | | | | | |-[publickey](#publickey) - string
 | | | | | | |-[snmp](#snmp)
 | | | | | | | |-[snmp_community](#snmp_community) - string
 | | | | | | | |-[snmp_oid](#snmp_oid) - string
 | | | | | | | |-[snmpv3_authpassphrase](#snmpv3_authpassphrase) - string
 | | | | | | | |-[snmpv3_authprotocol](#snmpv3_authprotocol) - enum[MD5,SHA]
 | | | | | | | |-[snmpv3_contextname](#snmpv3_contextname) - string
 | | | | | | | |-[snmpv3_privpassphrase](#snmpv3_privpassphrase) - string
 | | | | | | | |-[snmpv3_privprotocol](#snmpv3_privprotocol) - enum[DES,AES]
 | | | | | | | |-[snmpv3_securitylevel](#snmpv3_securitylevel) - enum[noAuthNoPriv,authNoPriv,authPriv]
 | | | | | | | |-[snmpv3_securityname](#snmpv3_securityname) - string
 | | | | | | |-[state](#state) - string
 | | | | | | |-[status](#status) - enum[enabled,disabled]
 | | | | | | |-[templateid](#templateid) - string
 | | | | | | |-[trapper_hosts](#trapper_hosts) - string
 | | | | | | |-[trends](#trends) - number
 | | | | | | |-[units](#units) - string
 | | | | | | |-[username](#username) - string
 | | | | | | |-[valuemapid](#valuemapid) - string
 | | | | |-[Triggers](#triggers)
 | | | | | |-[ZabbixTrigger](#zabbixtrigger) - string
 | | | | | | |-[triggerId](#triggerid) - string
 | | | | | | |-[description](#description) - string
 | | | | | | |-[expression](#expression) - string
 | | | | | | |-[comments](#comments) - string
 | | | | | | |-[error](#error) - string
 | | | | | | |-[flags](#flags) - string
 | | | | | | |-[lastchange](#lastchange) - string
 | | | | | | |-[priority](#priority) - enum[not classified,information,warning,average,high,disaster]
 | | | | | | |-[state](#state) - string
 | | | | | | |-[status](#status) - enum[enabled,disabled]
 | | | | | | |-[templateid](#templateid) - string
 | | | | | | |-[type](#type) - enum[single event,multple events]
 | | | | | | |-[url](#url) - string
 | | | | | | |-[Events](#events)
 | | | | | | | |-[ZabbixEvent](#zabbixevent)
 | | | | | | | | |-[eventid](#eventid) - string
 | | | | | | | | |-[acknowledged](#acknowledged) - number
 | | | | | | | | | |-[Acknowledgements](#acknowledgements)
 | | | | | | | | | | |-[ZabbixAcknowledgement](#zabbixacknowledgement)
 | | | | | | | | | | | |-[userid](#userid) - string
 | | | | | | | | | | | | |-[alias](#alias) - string
 | | | | | | | | | | | | |-[name](#name) - string
 | | | | | | | | | | | | |-[surname](#surname) - string
 | | | | | | | | | | | |-[clock](#clock) - string
 | | | | | | | | | | | |-[message](#message) - string
 | | | | | | | | |-[clock](#clock) - string
 | | | | | | | | |-[ns](#ns) - string
 | | | | | | | | |-[object](#object) - string
 | | | | | | | | |-[objectid](#objectid) - string
 | | | | | | | | |-[source](#source) - string
 | | | | | | | | |-[value](#value) - string
 | | | | | | | | |-[value_changed](#value_changed) - number
 | | | | | | | | |-[@Acknowledge_Event(message)](#acknowledge_event)
 | | | | | | | | |-[Alerts](#alerts)
 | | | | | | | | | |-[ZabbixAlert](#zabbixalert)
 | | | | | | | | | | |-[actionid](#actionid) - string
 | | | | | | | | | | |-[alerttype](#alerttype) - string
 | | | | | | | | | | |-[clock](#clock) - string
 | | | | | | | | | | |-[error](#error) - string
 | | | | | | | | | | |-[esc_step](#esc_step) - number
 | | | | | | | | | | |-[eventid](#eventid) - string
 | | | | | | | | | | |-[mediatypeid](#mediatypeid) - string
 | | | | | | | | | | |-[message](#message) - string
 | | | | | | | | | | |-[retries](#retries) - number
 | | | | | | | | | | |-[sendto](#sendto) - string
 | | | | | | | | | | |-[status](#status) - string
 | | | | | | | | | | |-[subject](#subject) - string
 | | | | | | | | | | |-[userid](#userid) - string
 </pre>

---

### root  

Root node of the DsLink  

Type: Node   

---

### Add_Connection  

Adds a connection to a Zabbix Server.  

Type: Action   
$is: addConnectionNode   
Parent: [root](#root)  

Description:  
Add Connection will attempt to connect to the specified server with the provided credentials. If successful it will add a ZabbixNode to the root of the link with the specified name.  

Params:  

Name | Type | Description
--- | --- | ---
name | `string` | Name to specify the server. Name becomes the path of the new ZabbixNode when added.
address | `string` | Address is the full URL to the ZabbixServer
username | `string` | Username used to authenticate to the server.
password | `string` | Password used to authenticate to the server.
refreshRate | `number` | Refresh Rate is the number of seconds between polling the server for new information.

Return type: value   
Columns:  

Name | Type | Description
--- | --- | ---
success | `bool` | Success is true when the action is successful, and false if the action failed. 
message | `string` | Message is Success! when the action is successful, and provides an error message if the action failed. 

---

### ZabbixNode  

Main connection to the remote Zabbix server.  

Type: Node   
$is: zabbixNode   
Parent: [root](#root)  

Description:  
Zabbix node manages the client which connects to the remote Zabbix server. This node also manages the subscriptions to child nodes to ensure that update polls are minimal and efficient.  

---

### Refresh_Hosts  

Refreshes the host list.  

Type: Action   
$is: connectionRefresh   
Parent: [ZabbixNode](#zabbixnode)  

Description:  
Refresh Hosts will poll the remote zabbix server and update the hosts with any new host groups, hosts or update configurations of the above.  

Return type: value   
Columns:  

Name | Type | Description
--- | --- | ---
success | `bool` | Success returns true when the action is successful; return false on failure. 
message | `string` | Message returns Success! when action is successful; returns an error message on failure. 

---

### Remove_Connection  

Remove the connection to the remote server.  

Type: Action   
$is: remoteConnectionNode   
Parent: [ZabbixNode](#zabbixnode)  

Description:  
Removes the Zabbix server from the link and closes the connection to the remote server. This action should not fail.  

Return type: value   
Columns:  

Name | Type | Description
--- | --- | ---
success | `bool` | Success is true when action completes successfully; false on failure. 
message | `string` | Message returns Success! when action completes successfully. Returns an error message on failure. 

---

### Edit_Connection  

Edit the connection details.  

Type: Action   
$is: editConnectionNode   
Parent: [ZabbixNode](#zabbixnode)  

Description:  
Edit connection updates the connection details and will verify that the new parameters are able to authenticate against the remote server. On success the action will update the backing client with the new connection details.  

Params:  

Name | Type | Description
--- | --- | ---
address | `string` | Address is the remote address of the Zabbix Server.
username | `string` | Username required to authenticate with the remote server.
password | `string` | Password required to authenticate with the remote server.
refreshRate | `number` | RefreshRate is the number of seconds between polling for updates from the remote server.

Return type: value   
Columns:  

Name | Type | Description
--- | --- | ---
success | `bool` | Success returns true if the action is successful; false on failure. 
message | `string` | Message returns Success! if the action is successful; an error message is return on failure. 

---

### HostGroups  

Container for the various host groups.  

Type: Node   
Parent: [ZabbixNode](#zabbixnode)  

---

### Create_Hostgroup  

Sends a request to the server to create a new host group.  

Type: Action   
$is: zabbixCreateHostgroup   
Parent: [HostGroups](#hostgroups)  

Description:  
Create Host Group will request the server create a new host group with the specified name.  

Params:  

Name | Type | Description
--- | --- | ---
name | `string` | The name of the host group for the server to create.

Return type: value   
Columns:  

Name | Type | Description
--- | --- | ---
success | `bool` | Success returns true on success, false on failure. 
message | `string` | Message returns "Success!" on success, and an error on failure. 

---

### ZabbixHostGroup  

A Host group provided by the server.  

Type: Node   
$is: zabbixHostgroupNode   
Parent: [HostGroups](#hostgroups)  

Description:  
ZabbixHostGroup will have the path of the group ID, and display name of the group name.  


---

### flags  

Flags indicate if the hostgroup was plain or discovered.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHostGroup](#zabbixhostgroup)  
Value Type: `string`  
Writable: `never`  

---

### internal  

If the hostgroup is internal only.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHostGroup](#zabbixhostgroup)  
Value Type: `bool`  
Writable: `never`  

---

### Rename_Hostgroup  

Send a request to the server to rename the hostgroup to the name specified.  

Type: Action   
$is: zabbixRenameHostgroup   
Parent: [ZabbixHostGroup](#zabbixhostgroup)  

Description:  
Rename Hostgroup will attempt to rename the hostgroup to the specified name. If the command is successful, it will also update the display name of the ZabbixHostGroup node.  

Params:  

Name | Type | Description
--- | --- | ---
name | `string` | The name try updating the hostgroup to.

Return type: value   
Columns:  

Name | Type | Description
--- | --- | ---
success | `bool` | Success is true if the Action succeeds, and false if the action fails. 
message | `string` | Message is "Success!" if the action is successful, and provides an error message if the action failed. 

---

### Delete_Hostgroup  

Sends a request to the server to remove the hostgroup.  

Type: Action   
$is: zabbixDeleteHostgroup   
Parent: [ZabbixHostGroup](#zabbixhostgroup)  

Description:  
Delete Hostgroup will request that the server remove the hostgroup. This command will only be available on any host groups which are not internal. If the action is successful, it will remote the hostgroup node from the link.  

Return type: value   
Columns:  

Name | Type | Description
--- | --- | ---
success | `bool` | Success is true if the Action succeeds, and false if the action fails. 
message | `string` | Message is "Success!" if the action is successful, and provides an error message if the action failed. 

---

### ZabbixHost  

A host in the Zabbix Server.  

Type: Node   
$is: zabbixHostNode   
Parent: [ZabbixHostGroup](#zabbixhostgroup)  

Description:  
ZabbixHost represents a host as defined on the remote server. It's path is the hostId and display name is the host name.  


---

### hostId  

Id of the host.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  
Value Type: `string`  
Writable: `never`  

---

### available  

Availability of Zabbix agent on host.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
String representation of the availability of the Zabbix Agent on the host. Values may be Available, Unavailable, or Unknown. Value may not be set.  

Value Type: `string`  
Writable: `never`  

---

### description  

Description of host. May be set.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  
Value Type: `string`  
Writable: `write`  

---

### disable_until  

Timestamp for the next polling time of an unavailable Zabbix agent.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  
Value Type: `string`  
Writable: `never`  

---

### error  

Error text if Zabbix agent on host is unavailable.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  
Value Type: `string`  
Writable: `never`  

---

### error_from  

Timestamp when the Zabbix agent on host became unavailable.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  
Value Type: `string`  
Writable: `never`  

---

### flags  

Origin of the host.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
A string representation of the origin of the host. Value may be Plain Host or Discovered Host. Value cannot be set.  

Value Type: `string`  
Writable: `never`  

---

### IPMI  

IPMI availability and grouping of other IPMI related values.  

Type: Node   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
IPMI value is a string representation of the availability of the agent. Value may be Available, Unavailable, or Unknown.  

Value Type: `string`  
Writable: `never`  

---

### ipmi_authtype  

IPMI authentication algorithm.  

Type: Node   
$is: zabbixValueNode   
Parent: [IPMI](#ipmi)  

Description:  
String representation of the authentication algorithm used by the IPMI agent. Value may be set to one of the valid enum values.  

Value Type: `enum[default,none,MD2,MD5,straight,OEM,RMCP+]`  
Writable: `write`  

---

### ipmi_disable_until  

Timestamp for the next polling time of an unavailable IPMI agent.  

Type: Node   
$is: zabbixValueNode   
Parent: [IPMI](#ipmi)  
Value Type: `string`  
Writable: `never`  

---

### ipmi_error  

Error text if IPMI agent is unavailable.  

Type: Node   
$is: zabbixValueNode   
Parent: [IPMI](#ipmi)  
Value Type: `string`  
Writable: `never`  

---

### ipmi_password  

Password required to authenticate with the IPMI.  

Type: Node   
$is: zabbixValueNode   
Parent: [IPMI](#ipmi)  

Description:  
The IPMI Password is used for the server to authenticate with IPMI. This value may be set to update it on the remote server.  

Value Type: `string`  
Writable: `write`  

---

### ipmi_privlege  

IPMI Privilege level  

Type: Node   
$is: zabbixValueNode   
Parent: [IPMI](#ipmi)  

Description:  
This is the string representation of IPMI priviledge level on the server. This value may be modified with one of the enum values.  

Value Type: `enum[callback,user,operator,admin,OEM]`  
Writable: `write`  

---

### ipmi_username  

Username required to authenticate with the IPMI  

Type: Node   
$is: zabbixValueNode   
Parent: [IPMI](#ipmi)  

Description:  
The IPMI Username is used for the server to authenticate with IPMI. This value may be set to update it on the remote server.  

Value Type: `string`  
Writable: `write`  

---

### JMX  

JMX Availability and grouping of other JMX related values.  

Type: Node   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
JMX value is a string representation of the availability of JMX agent. Value may be Available, Unavailable, or Unknown.  

Value Type: `string`  
Writable: `never`  

---

### jmx_disable_until  

Timestamp value of the next polling time of an unavailable JMX agent.  

Type: Node   
$is: zabbixValueNode   
Parent: [JMX](#jmx)  
Value Type: `string`  
Writable: `never`  

---

### jmx_error  

Error text if the JMX agent is unavailable.  

Type: Node   
$is: zabbixValueNode   
Parent: [JMX](#jmx)  
Value Type: `string`  
Writable: `never`  

---

### jmx_error_from  

Timestamp value of when the JMX agent became unavailable.  

Type: Node   
$is: zabbixValueNode   
Parent: [JMX](#jmx)  
Value Type: `string`  
Writable: `never`  

---

### maintenanceid  

The ID of the maintenance that is currently in effect on the host.  

Type: Node   
Parent: [ZabbixHost](#zabbixhost)  
Value Type: `string`  
Writable: `never`  

---

### maintenance_from  

Timestamp of the starting time of the effective maintenance.  

Type: Node   
$is: zabbixValueNode   
Parent: [maintenanceid](#maintenanceid)  
Value Type: `string`  
Writable: `never`  

---

### maintenance_status  

Effective maintenance status.  

Type: Node   
$is: zabbixValueNode   
Parent: [maintenanceid](#maintenanceid)  

Description:  
This is a string representation of the current maintenance status. Value may be No Maintenance or In effect.  

Value Type: `string`  
Writable: `never`  

---

### maintenance_type  

Effective maintenance type.  

Type: Node   
$is: zabbixValueNode   
Parent: [maintenanceid](#maintenanceid)  

Description:  
Maintenance Type is a string representation of the current maintenance type. Value may be With data collection or Without data collection.  

Value Type: `string`  
Writable: `never`  

---

### name  

Name of the host on the remote server.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
This value may be updated to update host configuration on the remote server. Successful update will also update the display name of this ZabbixHost node.  

Value Type: `string`  
Writable: `write`  

---

### proxy_hostid  

Id of the proxy that is used to monitor the host.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
The value of this field can be updated to change the proxy used for monitoring this host.  

Value Type: `string`  
Writable: `write`  

---

### SNMP  

Grouping of SNMP related values, and SNMP availability.  

Type: Node   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
The value of this field indicates if SNMP functionality for this host is Available, Unavailable or Unknown.  

Value Type: `string`  
Writable: `never`  

---

### snmp_disable_until  

Timestamp of the next polling time of an unavailable SNMP agent.  

Type: Node   
$is: zabbixValueNode   
Parent: [SNMP](#snmp)  
Value Type: `string`  
Writable: `never`  

---

### snmp_error  

Error text if SNMP is unavailable.  

Type: Node   
$is: zabbixValueNode   
Parent: [SNMP](#snmp)  
Value Type: `string`  
Writable: `never`  

---

### snmp_errors_from  

Timestamp when the SNMP agent became unavailable.  

Type: Node   
$is: zabbixValueNode   
Parent: [SNMP](#snmp)  
Value Type: `string`  
Writable: `never`  

---

### status  

Status of the Host.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
Status may be @set to disable or enable monitoring of this host.  

Value Type: `enum[Monitored,Unmonitored]`  
Writable: `write`  

---

### Items  

Collection of items for the given ZabbixHost.  

Type: Node   
Parent: [ZabbixHost](#zabbixhost)  

---

### ZabbixItem  

Items associated with a given Zabbix Host.  

Type: Node   
Parent: [Items](#items)  

Description:  
Detailed information regarding the monitoring points for a given Zabbix Host. The path is the Item Id and the display name is the item's key.  


---

### itemid  

Id of the Item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `never`  

---

### delay  

Update interval of the item in seconds.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `number`  
Writable: `write`  

---

### hostid  

Id of the host the item belongs to.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `write`  

---

### interfaceid  

Id of the item's host interface. Only for host items.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `write`  

---

### key  

Item key  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `write`  

---

### name  

Name of the item  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `write`  

---

### type  

Type of the item  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  

Description:  
String representation of the type of the item. Can be set to an enum value.  

Value Type: `enum[Zabbix Agent,SNMPv1 Agent,Zabbix Trapper,Simple Check,SNMPv2 Agent,Zabbix Internal,SNMPv3 Agent,Zabbix Agent (active),Zabbix Aggregate,Web Item,External Clock,Database Monitor,IPMI Agent,SSH Agent,Telnet Agent,Calculated,JMX Agent,SNMP Trap]`  
Writable: `write`  

---

### value_type  

Type of information the item provides.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  

Description:  
Value type is the type of information that is contained in the value. Can be set to one of the enum values.  

Value Type: `enum[Numeric float,Character,Log,Numeric unsigned,text]`  
Writable: `write`  

---

### authtype  

SSH authentication method. Used only by SSH agent items.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `enum[password,public key]`  
Writable: `write`  

---

### data_type  

Data type of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `enum[decimal,octal,hexadecimal,boolean]`  
Writable: `write`  

---

### delay_flex  

Flexible intervals as a serialized string  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `write`  

---

### delta  

Value that will be stored.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `enum[as is,Delta (speed per second),Delta (simple change)]`  
Writable: `write`  

---

### description  

Description of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `write`  

---

### error  

Error text if there are problems updating the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `never`  

---

### flags  

Origin of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  

Description:  
A string representation of the origin of the time. Possible values are Plain Item or Discovered Item.  

Value Type: `string`  
Writable: `never`  

---

### formula  

Custom multipler  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `number`  
Writable: `write`  

---

### history  

Number of days to keep the item's history.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `number`  
Writable: `write`  

---

### inventory_link  

Id of the host inventory field that is populated by the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `number`  
Writable: `write`  

---

### ipmi_sensor  

IPMI sensor. Used only by IPMI items.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `write`  

---

### lastclock  

Timestamp when the item was last updated.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `never`  

---

### lastns  

Nanoseconds when the item was last updated.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `number`  
Writable: `never`  

---

### lastvalue  

Last value of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `never`  

---

### logtimefmt  

Format of the time in log entries. Only used by log items.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `write`  

---

### mtime  

Time when the monitored log file was last updated.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `never`  

---

### multiplier  

Whether to use a custom multiplier  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `number`  
Writable: `write`  

---

### params  

Additional parameters depending on the type of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  

Description:  
Parameters may be executed scripts for SSH/Telnet items; SQL query for database monitor items; or formula for calculated items.  

Value Type: `string`  
Writable: `write`  

---

### password  

Password used for authentication.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  

Description:  
Password that is required for simple check, SSH, telnet, database monitor and JMX items.  

Value Type: `string`  
Writable: `write`  

---

### port  

Port monitored by the item. Used only by SNMP items.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `write`  

---

### prevvalue  

Previous value of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `never`  

---

### privatekey  

Name of the private key file.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `write`  

---

### publickey  

Name of the public key file.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `write`  

---

### snmp  

Collection of Item SNMP configurations.  

Type: Node   
Parent: [ZabbixItem](#zabbixitem)  

---

### snmp_community  

SNMP community. Used only by SNMPv1 an SNMPv2 items.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `string`  
Writable: `write`  

---

### snmp_oid  

SNMP OID to query.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `string`  
Writable: `write`  

---

### snmpv3_authpassphrase  

SNMPv3 auth passphrase. Used only by SNMPv3 items.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `string`  
Writable: `write`  

---

### snmpv3_authprotocol  

SNMPv3 auth protocol. Used only by SNMPv3 items.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `enum[MD5,SHA]`  
Writable: `write`  

---

### snmpv3_contextname  

SNMPv3 context name. Used only by SNMPv3 items.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `string`  
Writable: `write`  

---

### snmpv3_privpassphrase  

SNMPv3 priv passphrase. Used only by SNMPv3 items.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `string`  
Writable: `write`  

---

### snmpv3_privprotocol  

SNMPv3 privacy protocol.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `enum[DES,AES]`  
Writable: `write`  

---

### snmpv3_securitylevel  

SNMPv3 Security level. Used only by SNMPv3 items.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `enum[noAuthNoPriv,authNoPriv,authPriv]`  
Writable: `write`  

---

### snmpv3_securityname  

SNMPv3 Security name. Used only by SNMPv3 items.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `string`  
Writable: `write`  

---

### state  

State of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  

Description:  
String representation of the state of the item. Possible values normal, or not supported  

Value Type: `string`  
Writable: `never`  

---

### status  

Status of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `enum[enabled,disabled]`  
Writable: `write`  

---

### templateid  

Id of the parent template item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `never`  

---

### trapper_hosts  

Allowed hosts. Only used by trapper items.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `write`  

---

### trends  

Number of days to keep item's trends data.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `number`  
Writable: `write`  

---

### units  

Value units.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `write`  

---

### username  

Username for authentication.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  

Description:  
Username that is required for simple check, SSH, telnet, database monitor and JMX items.  

Value Type: `string`  
Writable: `write`  

---

### valuemapid  

Id of the associated value map.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`  
Writable: `write`  

---

### Triggers  

Container node for the ZabbixTriggers  

Type: Node   
Parent: [ZabbixHost](#zabbixhost)  

---

### ZabbixTrigger  

Triggers for a Zabbix Host as defined on the remote server.  

Type: Node   
$is: zabbixTriggerNode   
Parent: [Triggers](#triggers)  

Description:  
Zabbix Triggers are the definition of an event which make cause an Event or Alert to happen. The path name is the trigger Id and the display name is the short description given to the trigger. The value is the current state of the trigger and may be Ok, or Problem  

Value Type: `string`  
Writable: `never`  

---

### triggerId  

Id of the trigger on the remote server.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  
Value Type: `string`  
Writable: `never`  

---

### description  

Name of the trigger. Value may be set.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  
Value Type: `string`  
Writable: `write`  

---

### expression  

Reduced trigger expression. May be set.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  
Value Type: `string`  
Writable: `write`  

---

### comments  

Additional comments to the trigger. Value may be set.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  
Value Type: `string`  
Writable: `write`  

---

### error  

Error text if there have been problems updating the trigger.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  

Description:  
If an error occurred when updating the state of the trigger, the error text will appear here. Cannot be set.  

Value Type: `string`  
Writable: `never`  

---

### flags  

Origin of the trigger.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  

Description:  
Indicate the origin of the trigger. Value may be plain or discovered.  

Value Type: `string`  
Writable: `never`  

---

### lastchange  

Timestamp indicating when the trigger last changed its state.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  
Value Type: `string`  
Writable: `never`  

---

### priority  

Severity of the trigger.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  

Description:  
Priority is the string representation of the priority level of the trigger. May be modified as one of the enum values.  

Value Type: `enum[not classified,information,warning,average,high,disaster]`  
Writable: `write`  

---

### state  

State of the trigger.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  

Description:  
State is the string representation of the trigger's current state. Possible values are Up to date, Unknown.  

Value Type: `string`  
Writable: `never`  

---

### status  

Whether the trigger is enabled or disabled.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  

Description:  
The enum values may be used to change the current state of the trigger.  

Value Type: `enum[enabled,disabled]`  
Writable: `write`  

---

### templateid  

Id of the parent template trigger.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  
Value Type: `string`  
Writable: `never`  

---

### type  

Whether the trigger can generate multiple problem events.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  

Description:  
The enum values may be set and used to change if the trigger can generate multiple problem events.  

Value Type: `enum[single event,multple events]`  
Writable: `write`  

---

### url  

The Url associated with the trigger. May be set.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  
Value Type: `string`  
Writable: `write`  

---

### Events  

Container node for ZabbixEvent's on a Trigger.  

Type: Node   
Parent: [ZabbixTrigger](#zabbixtrigger)  

---

### ZabbixEvent  

Events generated by the parent ZabbixTrigger  

Type: Node   
$is: zabbixEventNode   
Parent: [Events](#events)  

Description:  
A ZabbixEvent is generated by a Trigger conditions being met. The path and name for the event is the eventId.  


---

### eventid  

Id of the event  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixEvent](#zabbixevent)  
Value Type: `string`  
Writable: `never`  

---

### acknowledged  

Total number of acknowledgements on this event.  

Type: Node   
Parent: [ZabbixEvent](#zabbixevent)  
Value Type: `number`  
Writable: `never`  

---

### Acknowledgements  

Collection of Acknowledgements on this trigger.  

Type: Node   
Parent: [acknowledged](#acknowledged)  

---

### ZabbixAcknowledgement  

Acknowledgement received by the remote server.  

Type: Node   
Parent: [Acknowledgements](#acknowledgements)  

Description:  
An acknowledgement for the event on the trigger. Path and name are the acknowledgementId.  


---

### userid  

User who acknowledged the event. Display name is User ID. The value is the user's Id.  

Type: Node   
Parent: [ZabbixAcknowledgement](#zabbixacknowledgement)  
Value Type: `string`  
Writable: `never`  

---

### alias  

Alias for the user.  

Type: Node   
$is: zabbixValueNode   
Parent: [userid](#userid)  
Value Type: `string`  
Writable: `never`  

---

### name  

The user's first name.  

Type: Node   
$is: zabbixValueNode   
Parent: [userid](#userid)  
Value Type: `string`  
Writable: `never`  

---

### surname  

The user's surname (last name).  

Type: Node   
$is: zabbixValueNode   
Parent: [userid](#userid)  
Value Type: `string`  
Writable: `never`  

---

### clock  

Timestamp of the acknowledged time.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAcknowledgement](#zabbixacknowledgement)  
Value Type: `string`  
Writable: `never`  

---

### message  

Message which accompanies the acknowledgement.  

Type: Node   
$is: zabbixNodeValue   
Parent: [ZabbixAcknowledgement](#zabbixacknowledgement)  
Value Type: `string`  
Writable: `never`  

---

### clock  

Timestamp of when the event was created.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixEvent](#zabbixevent)  
Value Type: `string`  
Writable: `never`  

---

### ns  

Nanosecond timestamp of when the event was created.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixEvent](#zabbixevent)  
Value Type: `string`  
Writable: `never`  

---

### object  

Type of object related to this event.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixEvent](#zabbixevent)  

Description:  
String representation of the type of object for this event. The value will vary depending on the event type.  

Value Type: `string`  
Writable: `never`  

---

### objectid  

Id of the object related to this event.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixEvent](#zabbixevent)  
Value Type: `string`  
Writable: `never`  

---

### source  

The type of event.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixEvent](#zabbixevent)  
Value Type: `string`  
Writable: `never`  

---

### value  

State of the related object.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixEvent](#zabbixevent)  

Description:  
The value of the event is the string representation of the status of the object related to the event. This will vary depending on the type of event generated.  

Value Type: `string`  
Writable: `never`  

---

### value_changed  

Value changed is the number of times the event's value has updated.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixEvent](#zabbixevent)  
Value Type: `number`  
Writable: `never`  

---

### Acknowledge_Event  

Send an acknowledgement of the event to the remote server.  

Type: Action   
$is: zabbixAcknowledgeEvent   
Parent: [ZabbixEvent](#zabbixevent)  

Description:  
Acknowledge Event will acknowledge the event with the remote server. If successful, the acknowledgement will be added to the events acknowledgements. Action will fail if message parameter is not specified.  

Params:  

Name | Type | Description
--- | --- | ---
message | `string` | Message to include with the acknowledgement.

Return type: value   
Columns:  

Name | Type | Description
--- | --- | ---
success | `bool` | Success will return true on success; False on failure. 
resultMessage | `string` | Result message will be Success if the action completes successfully. Otherwise it will provide an error message. 

---

### Alerts  

Container of alerts generated by the ZabbixEvent  

Type: Node   
Parent: [ZabbixEvent](#zabbixevent)  

---

### ZabbixAlert  

Information regarding certain action operations executed on an event.  

Type: Node   
$is: zabbixAlertNode   
Parent: [Alerts](#alerts)  

Description:  
ZabbixAlert contains details about which operations took place after an event was triggered. The path is the alertId. Alerts are generated by the remote Zabbix server and values cannot be modified.  


---

### actionid  

Id of the action that generated the alert.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`  
Writable: `never`  

---

### alerttype  

Type of alert. Values are message or remote command.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`  
Writable: `never`  

---

### clock  

Timestamp of when the alert was generated  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`  
Writable: `never`  

---

### error  

Error text if there are issues sending a message or running a command.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`  
Writable: `never`  

---

### esc_step  

Escalation step during which the alert was generated.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `number`  
Writable: `never`  

---

### eventid  

Id of the event that triggered the action.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`  
Writable: `never`  

---

### mediatypeid  

Id of the media type used to send the message.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`  
Writable: `never`  

---

### message  

Message text used in message alerts.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`  
Writable: `never`  

---

### retries  

Number of times remote Zabbix server tried to send the message.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `number`  
Writable: `never`  

---

### sendto  

Address, username, or identifier of the recipient for message alerts.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`  
Writable: `never`  

---

### status  

Status of the action operation.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  

Description:  
Status is a string representation of the status of the action operation. This will vary depending on the alert type.  

Value Type: `string`  
Writable: `never`  

---

### subject  

Message subject used for message alerts.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`  
Writable: `never`  

---

### userid  

Id of the user the message was sent to.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`  
Writable: `never`  

---
