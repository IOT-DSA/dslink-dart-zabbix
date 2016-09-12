```
- root
 |- @Add_Connection
 |- ZabbixNode
 | |- @Refresh_Hosts
 | |- @Edit_Connection
 | |- @Remove_Connection
 | |- HostGroups
 | | |- @Create_Hostgroup
 | | |- ZabbixHostGroup
 | | | |- flags
 | | | |- internal
 | | | |- @Rename_Hostgroup
 | | | |- @Delete_Hostgroup
 | | | |- ZabbixHost
 | | | | |- hostId
 | | | | |- available
 | | | | |- description
 | | | | |- disable_until
 | | | | |- error
 | | | | |- error_from
 | | | | |- flags
 | | | | |- IPMI
 | | | | | |- ipmi_authtype
 | | | | | |- ipmi_disable_until
 | | | | | |- ipmi_error
 | | | | | |- ipmi_password
 | | | | | |- ipmi_privlege
 | | | | | |- ipmi_username
 | | | | |- JMX
 | | | | | |- jmx_disable_until
 | | | | | |- jmx_error
 | | | | | |- jmx_error_from
 | | | | |- maintenanceid
 | | | | | |- maintenance_from
 | | | | | |- maintenance_status
 | | | | | |- maintenance_type
 | | | | |- name
 | | | | |- proxy_hostid
 | | | | |- SNMP
 | | | | | |- snmp_disable_until
 | | | | | |- snmp_error
 | | | | | |- snmp_errors_from
 | | | | |- status
 | | | | |- Items
 | | | | | |- ZabbixItem
 | | | | | | |- itemid
 | | | | | | |- delay
 | | | | | | |- hostid
 | | | | | | |- interfaceid
 | | | | | | |- key
 | | | | | | |- name
 | | | | | | |- type
 | | | | | | |- value_type
 | | | | | | |- authtype
 | | | | | | |- data_type
 | | | | | | |- delay_flex
 | | | | | | |- delta
 | | | | | | |- description
 | | | | | | |- error
 | | | | | | |- flags
 | | | | | | |- formula
 | | | | | | |- history
 | | | | | | |- inventory_link
 | | | | | | |- ipmi_sensor
 | | | | | | |- lastclock
 | | | | | | |- lastns
 | | | | | | |- lastvalue
 | | | | | | |- logtimefmt
 | | | | | | |- mtime
 | | | | | | |- multiplier
 | | | | | | |- params
 | | | | | | |- password
 | | | | | | |- port
 | | | | | | |- prevvalue
 | | | | | | |- privatekey
 | | | | | | |- publickey
 | | | | | | |- snmp
 | | | | | | | |- snmp_community
 | | | | | | | |- snmp_oid
 | | | | | | | |- snmpv3_authpassphrase
 | | | | | | | |- snmpv3_authprotocol
 | | | | | | | |- snmpv3_contextname
 | | | | | | | |- snmpv3_privpassphrase
 | | | | | | | |- snmpv3_privprotocol
 | | | | | | | |- snmpv3_securitylevel
 | | | | | | | |- snmpv3_securityname
 | | | | | | |- state
 | | | | | | |- status
 | | | | | | |- templateid
 | | | | | | |- trapper_hosts
 | | | | | | |- trends
 | | | | | | |- units
 | | | | | | |- username
 | | | | | | |- valuemapid
 | | | | |- Triggers
 | | | | | |- ZabbixTrigger
 | | | | | | |- triggerId
 | | | | | | |- description
 | | | | | | |- expression
 | | | | | | |- comments
 | | | | | | |- error
 | | | | | | |- flags
 | | | | | | |- lastchange
 | | | | | | |- priority
 | | | | | | |- state
 | | | | | | |- status
 | | | | | | |- templateid
 | | | | | | |- type
 | | | | | | |- url
 | | | | | | |- Events
 | | | | | | | |- ZabbixEvent
 | | | | | | | | |- eventid
 | | | | | | | | |- acknowledged
 | | | | | | | | | |- Acknowledgements
 | | | | | | | | | | |- ZabbixAcknowledgement
 | | | | | | | | | | | |- userid
 | | | | | | | | | | | | |- alias
 | | | | | | | | | | | | |- name
 | | | | | | | | | | | | |- surname
 | | | | | | | | | | | |- clock
 | | | | | | | | | | | |- message
 | | | | | | | | |- clock
 | | | | | | | | |- ns
 | | | | | | | | |- object
 | | | | | | | | |- objectid
 | | | | | | | | |- source
 | | | | | | | | |- value
 | | | | | | | | |- value_changed
 | | | | | | | | |- @Acknowledge_Event
 | | | | | | | | |- Alerts
 | | | | | | | | | |- ZabbixAlert
 | | | | | | | | | | |- actionid
 | | | | | | | | | | |- alerttype
 | | | | | | | | | | |- clock
 | | | | | | | | | | |- error
 | | | | | | | | | | |- esc_step
 | | | | | | | | | | |- eventid
 | | | | | | | | | | |- mediatypeid
 | | | | | | | | | | |- message
 | | | | | | | | | | |- retries
 | | | | | | | | | | |- sendto
 | | | | | | | | | | |- status
 | | | | | | | | | | |- subject
 | | | | | | | | | | |- userid
```

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

---

### internal  

If the hostgroup is internal only.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHostGroup](#zabbixhostgroup)  
Value Type: `bool`

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

---

### available  

Availability of Zabbix agent on host.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
String representation of the availability of the Zabbix Agent on the host. Values may be Available, Unavailable, or Unknown. Value may not be set.  

Value Type: `string`

---

### description  

Description of host. May be set.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  
Value Type: `string`

---

### disable_until  

Timestamp for the next polling time of an unavailable Zabbix agent.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  
Value Type: `string`

---

### error  

Error text if Zabbix agent on host is unavailable.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  
Value Type: `string`

---

### error_from  

Timestamp when the Zabbix agent on host became unavailable.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  
Value Type: `string`

---

### flags  

Origin of the host.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
A string representation of the origin of the host. Value may be Plain Host or Discovered Host. Value cannot be set.  

Value Type: `string`

---

### IPMI  

IPMI availability and grouping of other IPMI related values.  

Type: Node   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
IPMI value is a string representation of the availability of the agent. Value may be Available, Unavailable, or Unknown.  

Value Type: `string`

---

### ipmi_authtype  

IPMI authentication algorithm.  

Type: Node   
$is: zabbixValueNode   
Parent: [IPMI](#ipmi)  

Description:  
String representation of the authentication algorithm used by the IPMI agent. Value may be set to one of the valid enum values.  

Value Type: `enum[default,none,MD2,MD5,straight,OEM,RMCP+]`

---

### ipmi_disable_until  

Timestamp for the next polling time of an unavailable IPMI agent.  

Type: Node   
$is: zabbixValueNode   
Parent: [IPMI](#ipmi)  
Value Type: `string`

---

### ipmi_error  

Error text if IPMI agent is unavailable.  

Type: Node   
$is: zabbixValueNode   
Parent: [IPMI](#ipmi)  
Value Type: `string`

---

### ipmi_password  

Password required to authenticate with the IPMI.  

Type: Node   
$is: zabbixValueNode   
Parent: [IPMI](#ipmi)  

Description:  
The IPMI Password is used for the server to authenticate with IPMI. This value may be set to update it on the remote server.  

Value Type: `string`

---

### ipmi_privlege  

IPMI Privilege level  

Type: Node   
$is: zabbixValueNode   
Parent: [IPMI](#ipmi)  

Description:  
This is the string representation of IPMI priviledge level on the server. This value may be modified with one of the enum values.  

Value Type: `enum[callback,user,operator,admin,OEM]`

---

### ipmi_username  

Username required to authenticate with the IPMI  

Type: Node   
$is: zabbixValueNode   
Parent: [IPMI](#ipmi)  

Description:  
The IPMI Username is used for the server to authenticate with IPMI. This value may be set to update it on the remote server.  

Value Type: `string`

---

### JMX  

JMX Availability and grouping of other JMX related values.  

Type: Node   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
JMX value is a string representation of the availability of JMX agent. Value may be Available, Unavailable, or Unknown.  

Value Type: `string`

---

### jmx_disable_until  

Timestamp value of the next polling time of an unavailable JMX agent.  

Type: Node   
$is: zabbixValueNode   
Parent: [JMX](#jmx)  
Value Type: `string`

---

### jmx_error  

Error text if the JMX agent is unavailable.  

Type: Node   
$is: zabbixValueNode   
Parent: [JMX](#jmx)  
Value Type: `string`

---

### jmx_error_from  

Timestamp value of when the JMX agent became unavailable.  

Type: Node   
$is: zabbixValueNode   
Parent: [JMX](#jmx)  
Value Type: `string`

---

### maintenanceid  

The ID of the maintenance that is currently in effect on the host.  

Type: Node   
Parent: [ZabbixHost](#zabbixhost)  
Value Type: `string`

---

### maintenance_from  

Timestamp of the starting time of the effective maintenance.  

Type: Node   
$is: zabbixValueNode   
Parent: [maintenanceid](#maintenanceid)  
Value Type: `string`

---

### maintenance_status  

Effective maintenance status.  

Type: Node   
$is: zabbixValueNode   
Parent: [maintenanceid](#maintenanceid)  

Description:  
This is a string representation of the current maintenance status. Value may be No Maintenance or In effect.  

Value Type: `string`

---

### maintenance_type  

Effective maintenance type.  

Type: Node   
$is: zabbixValueNode   
Parent: [maintenanceid](#maintenanceid)  

Description:  
Maintenance Type is a string representation of the current maintenance type. Value may be With data collection or Without data collection.  

Value Type: `string`

---

### name  

Name of the host on the remote server.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
This value may be updated to update host configuration on the remote server. Successful update will also update the display name of this ZabbixHost node.  

Value Type: `string`

---

### proxy_hostid  

Id of the proxy that is used to monitor the host.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
The value of this field can be updated to change the proxy used for monitoring this host.  

Value Type: `string`

---

### SNMP  

Grouping of SNMP related values, and SNMP availability.  

Type: Node   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
The value of this field indicates if SNMP functionality for this host is Available, Unavailable or Unknown.  

Value Type: `string`

---

### snmp_disable_until  

Timestamp of the next polling time of an unavailable SNMP agent.  

Type: Node   
$is: zabbixValueNode   
Parent: [SNMP](#snmp)  
Value Type: `string`

---

### snmp_error  

Error text if SNMP is unavailable.  

Type: Node   
$is: zabbixValueNode   
Parent: [SNMP](#snmp)  
Value Type: `string`

---

### snmp_errors_from  

Timestamp when the SNMP agent became unavailable.  

Type: Node   
$is: zabbixValueNode   
Parent: [SNMP](#snmp)  
Value Type: `string`

---

### status  

Status of the Host.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixHost](#zabbixhost)  

Description:  
Status may be @set to disable or enable monitoring of this host.  

Value Type: `enum[Monitored,Unmonitored]`

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

---

### delay  

Update interval of the item in seconds.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `number`

---

### hostid  

Id of the host the item belongs to.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### interfaceid  

Id of the item's host interface. Only for host items.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### key  

Item key  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### name  

Name of the item  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### type  

Type of the item  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  

Description:  
String representation of the type of the item. Can be set to an enum value.  

Value Type: `enum[Zabbix Agent,SNMPv1 Agent,Zabbix Trapper,Simple Check,SNMPv2 Agent,Zabbix Internal,SNMPv3 Agent,Zabbix Agent (active),Zabbix Aggregate,Web Item,External Clock,Database Monitor,IPMI Agent,SSH Agent,Telnet Agent,Calculated,JMX Agent,SNMP Trap]`

---

### value_type  

Type of information the item provides.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  

Description:  
Value type is the type of information that is contained in the value. Can be set to one of the enum values.  

Value Type: `enum[Numeric float,Character,Log,Numeric unsigned,text]`

---

### authtype  

SSH authentication method. Used only by SSH agent items.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `enum[password,public key]`

---

### data_type  

Data type of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `enum[decimal,octal,hexadecimal,boolean]`

---

### delay_flex  

Flexible intervals as a serialized string  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### delta  

Value that will be stored.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `enum[as is,Delta (speed per second),Delta (simple change)]`

---

### description  

Description of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### error  

Error text if there are problems updating the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### flags  

Origin of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  

Description:  
A string representation of the origin of the time. Possible values are Plain Item or Discovered Item.  

Value Type: `string`

---

### formula  

Custom multipler  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `number`

---

### history  

Number of days to keep the item's history.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `number`

---

### inventory_link  

Id of the host inventory field that is populated by the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `number`

---

### ipmi_sensor  

IPMI sensor. Used only by IPMI items.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### lastclock  

Timestamp when the item was last updated.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### lastns  

Nanoseconds when the item was last updated.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `number`

---

### lastvalue  

Last value of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### logtimefmt  

Format of the time in log entries. Only used by log items.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### mtime  

Time when the monitored log file was last updated.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### multiplier  

Whether to use a custom multiplier  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `number`

---

### params  

Additional parameters depending on the type of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  

Description:  
Parameters may be executed scripts for SSH/Telnet items; SQL query for database monitor items; or formula for calculated items.  

Value Type: `string`

---

### password  

Password used for authentication.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  

Description:  
Password that is required for simple check, SSH, telnet, database monitor and JMX items.  

Value Type: `string`

---

### port  

Port monitored by the item. Used only by SNMP items.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### prevvalue  

Previous value of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### privatekey  

Name of the private key file.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### publickey  

Name of the public key file.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

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

---

### snmp_oid  

SNMP OID to query.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `string`

---

### snmpv3_authpassphrase  

SNMPv3 auth passphrase. Used only by SNMPv3 items.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `string`

---

### snmpv3_authprotocol  

SNMPv3 auth protocol. Used only by SNMPv3 items.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `enum[MD5,SHA]`

---

### snmpv3_contextname  

SNMPv3 context name. Used only by SNMPv3 items.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `string`

---

### snmpv3_privpassphrase  

SNMPv3 priv passphrase. Used only by SNMPv3 items.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `string`

---

### snmpv3_privprotocol  

SNMPv3 privacy protocol.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `enum[DES,AES]`

---

### snmpv3_securitylevel  

SNMPv3 Security level. Used only by SNMPv3 items.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `enum[noAuthNoPriv,authNoPriv,authPriv]`

---

### snmpv3_securityname  

SNMPv3 Security name. Used only by SNMPv3 items.  

Type: Node   
$is: zabbixValueNode   
Parent: [snmp](#snmp)  
Value Type: `string`

---

### state  

State of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  

Description:  
String representation of the state of the item. Possible values normal, or not supported  

Value Type: `string`

---

### status  

Status of the item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `enum[enabled,disabled]`

---

### templateid  

Id of the parent template item.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### trapper_hosts  

Allowed hosts. Only used by trapper items.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  

---

### trends  

Number of days to keep item's trends data.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `number`

---

### units  

Value units.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

---

### username  

Username for authentication.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  

Description:  
Username that is required for simple check, SSH, telnet, database monitor and JMX items.  

Value Type: `string`

---

### valuemapid  

Id of the associated value map.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixItem](#zabbixitem)  
Value Type: `string`

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

---

### triggerId  

Id of the trigger on the remote server.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  
Value Type: `string`

---

### description  

Name of the trigger. Value may be set.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  
Value Type: `string`

---

### expression  

Reduced trigger expression. May be set.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  
Value Type: `string`

---

### comments  

Additional comments to the trigger. Value may be set.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  
Value Type: `string`

---

### error  

Error text if there have been problems updating the trigger.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  

Description:  
If an error occurred when updating the state of the trigger, the error text will appear here. Cannot be set.  

Value Type: `string`

---

### flags  

Origin of the trigger.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  

Description:  
Indicate the origin of the trigger. Value may be plain or discovered.  

Value Type: `string`

---

### lastchange  

Timestamp indicating when the trigger last changed its state.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  
Value Type: `string`

---

### priority  

Severity of the trigger.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  

Description:  
Priority is the string representation of the priority level of the trigger. May be modified as one of the enum values.  

Value Type: `enum[not classified,information,warning,average,high,disaster]`

---

### state  

State of the trigger.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  

Description:  
State is the string representation of the trigger's current state. Possible values are Up to date, Unknown.  

Value Type: `string`

---

### status  

Whether the trigger is enabled or disabled.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  

Description:  
The enum values may be used to change the current state of the trigger.  

Value Type: `enum[enabled,disabled]`

---

### templateid  

Id of the parent template trigger.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  
Value Type: `string`

---

### type  

Whether the trigger can generate multiple problem events.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  

Description:  
The enum values may be set and used to change if the trigger can generate multiple problem events.  

Value Type: `enum[single event,multple events]`

---

### url  

The Url associated with the trigger. May be set.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixTrigger](#zabbixtrigger)  
Value Type: `string`

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

---

### acknowledged  

Total number of acknowledgements on this event.  

Type: Node   
Parent: [ZabbixEvent](#zabbixevent)  
Value Type: `number`

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

---

### alias  

Alias for the user.  

Type: Node   
$is: zabbixValueNode   
Parent: [userid](#userid)  
Value Type: `string`

---

### name  

The user's first name.  

Type: Node   
$is: zabbixValueNode   
Parent: [userid](#userid)  
Value Type: `string`

---

### surname  

The user's surname (last name).  

Type: Node   
$is: zabbixValueNode   
Parent: [userid](#userid)  
Value Type: `string`

---

### clock  

Timestamp of the acknowledged time.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAcknowledgement](#zabbixacknowledgement)  
Value Type: `string`

---

### message  

Message which accompanies the acknowledgement.  

Type: Node   
$is: zabbixNodeValue   
Parent: [ZabbixAcknowledgement](#zabbixacknowledgement)  
Value Type: `string`

---

### clock  

Timestamp of when the event was created.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixEvent](#zabbixevent)  
Value Type: `string`

---

### ns  

Nanosecond timestamp of when the event was created.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixEvent](#zabbixevent)  
Value Type: `string`

---

### object  

Type of object related to this event.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixEvent](#zabbixevent)  

Description:  
String representation of the type of object for this event. The value will vary depending on the event type.  

Value Type: `string`

---

### objectid  

Id of the object related to this event.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixEvent](#zabbixevent)  
Value Type: `string`

---

### source  

The type of event.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixEvent](#zabbixevent)  
Value Type: `string`

---

### value  

State of the related object.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixEvent](#zabbixevent)  

Description:  
The value of the event is the string representation of the status of the object related to the event. This will vary depending on the type of event generated.  

Value Type: `string`

---

### value_changed  

Value changed is the number of times the event's value has updated.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixEvent](#zabbixevent)  
Value Type: `number`

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

---

### alerttype  

Type of alert. Values are message or remote command.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`

---

### clock  

Timestamp of when the alert was generated  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`

---

### error  

Error text if there are issues sending a message or running a command.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`

---

### esc_step  

Escalation step during which the alert was generated.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `number`

---

### eventid  

Id of the event that triggered the action.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`

---

### mediatypeid  

Id of the media type used to send the message.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`

---

### message  

Message text used in message alerts.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  

---

### retries  

Number of times remote Zabbix server tried to send the message.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `number`

---

### sendto  

Address, username, or identifier of the recipient for message alerts.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`

---

### status  

Status of the action operation.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  

Description:  
Status is a string representation of the status of the action operation. This will vary depending on the alert type.  

Value Type: `string`

---

### subject  

Message subject used for message alerts.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  
Value Type: `string`

---

### userid  

Id of the user the message was sent to.  

Type: Node   
$is: zabbixValueNode   
Parent: [ZabbixAlert](#zabbixalert)  

---
