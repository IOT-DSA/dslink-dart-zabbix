### root  

Type: Node   

Short: Root node of the DsLink  


---

### Add_Connection  

Type: Action   
Is: addConnectionNode   
Parent: [root](#root)  

Short: Adds a connection to a Zabbix Server.  

Long: Add Connection will attempt to connect to the specified server with the provided credentials. If successful it will add a ZabbixNode to the root of the link with the specified name.  

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

Type: Node   
Is: zabbixNode   
Parent: [root](#root)  

Short: Main connection to the remote Zabbix server.  

Long: Zabbix node manages the client which connects to the remote Zabbix server. This node also manages the subscriptions to child nodes to ensure that update polls are minimal and efficient.  


---

### Refresh_Hosts  

Type: Action   
Is: connectionRefresh   
Parent: [ZabbixNode](#ZabbixNode)  

Short: Refreshes the host list.  

Long: Refresh Hosts will poll the remote zabbix server and update the hosts with any new host groups, hosts or update configurations of the above.  

Return type: value   
Columns:  

Name | Type | Description
--- | --- | ---
success | `bool` | Success returns true when the action is successful; return false on failure. 
message | `string` | Message returns Success! when action is successful; returns an error message on failure. 

---

### Edit_Connection  

Type: Action   
Is: editConnectionNode   
Parent: [ZabbixNode](#ZabbixNode)  

Short: Edit the connection details.  

Long: Edit connection updates the connection details and will verify that the new parameters are able to authenticate against the remote server. On success the action will update the backing client with the new connection details.  

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

Type: Action   
Is: remoteConnectionNode   
Parent: [ZabbixNode](#ZabbixNode)  

Short: Remove the connection to the remote server.  

Long: Removes the Zabbix server from the link and closes the connection to the remote server. This action should not fail.  

Return type: value   
Columns:  

Name | Type | Description
--- | --- | ---
success | `bool` | Success is true when action completes successfully; false on failure. 
message | `string` | Message returns Success! when action completes successfully. Returns an error message on failure. 

---

### HostGroups  

Type: Node   
Parent: [ZabbixNode](#ZabbixNode)  

Short: Container for the various host groups.  


---

### Create_Hostgroup  

Type: Action   
Is: zabbixCreateHostgroup   
Parent: [HostGroups](#HostGroups)  

Short: Sends a request to the server to create a new host group.  

Long: Create Host Group will request the server create a new host group with the specified name.  

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

Type: Node   
Is: zabbixHostgroupNode   
Parent: [HostGroups](#HostGroups)  

Short: A Host group provided by the server.  

Long: ZabbixHostGroup will have the path of the group ID, and display name of the group name.  


---

### flags  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixHostGroup](#ZabbixHostGroup)  

Short: Flags indicate if the hostgroup was plain or discovered.  

Value Type: `string`

---

### internal  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixHostGroup](#ZabbixHostGroup)  

Short: If the hostgroup is internal only.  

Value Type: `bool`

---

### Rename_Hostgroup  

Type: Action   
Is: zabbixRenameHostgroup   
Parent: [ZabbixHostGroup](#ZabbixHostGroup)  

Short: Send a request to the server to rename the hostgroup to the name specified.  

Long: Rename Hostgroup will attempt to rename the hostgroup to the specified name. If the command is successful, it will also update the display name of the ZabbixHostGroup node.  

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

Type: Action   
Is: zabbixDeleteHostgroup   
Parent: [ZabbixHostGroup](#ZabbixHostGroup)  

Short: Sends a request to the server to remove the hostgroup.  

Long: Delete Hostgroup will request that the server remove the hostgroup. This command will only be available on any host groups which are not internal. If the action is successful, it will remote the hostgroup node from the link.  

Return type: value   
Columns:  

Name | Type | Description
--- | --- | ---
success | `bool` | Success is true if the Action succeeds, and false if the action fails. 
message | `string` | Message is "Success!" if the action is successful, and provides an error message if the action failed. 

---

### ZabbixHost  

Type: Node   
Is: zabbixHostNode   
Parent: [ZabbixHostGroup](#ZabbixHostGroup)  

Short: A host in the Zabbix Server.  

Long: ZabbixHost represents a host as defined on the remote server. It's path is the hostId and display name is the host name.  


---

### hostId  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixHost](#ZabbixHost)  

Short: Id of the host.  

Value Type: `string`

---

### available  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixHost](#ZabbixHost)  

Short: Availability of Zabbix agent on host.  

Long: String representation of the availability of the Zabbix Agent on the host. Values may be Available, Unavailable, or Unknown. Value may not be set.  

Value Type: `string`

---

### description  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixHost](#ZabbixHost)  

Short: Description of host. May be set.  

Value Type: `string`

---

### disable_until  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixHost](#ZabbixHost)  

Short: Timestamp for the next polling time of an unavailable Zabbix agent.  

Value Type: `string`

---

### error  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixHost](#ZabbixHost)  

Short: Error text if Zabbix agent on host is unavailable.  

Value Type: `string`

---

### error_from  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixHost](#ZabbixHost)  

Short: Timestamp when the Zabbix agent on host became unavailable.  

Value Type: `string`

---

### flags  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixHost](#ZabbixHost)  

Short: Origin of the host.  

Long: A string representation of the origin of the host. Value may be Plain Host or Discovered Host. Value cannot be set.  

Value Type: `string`

---

### IPMI  

Type: Node   
Parent: [ZabbixHost](#ZabbixHost)  

Short: IPMI availability and grouping of other IPMI related values.  

Long: IPMI value is a string representation of the availability of the agent. Value may be Available, Unavailable, or Unknown.  

Value Type: `string`

---

### ipmi_authtype  

Type: Node   
Is: zabbixValueNode   
Parent: [IPMI](#IPMI)  

Short: IPMI authentication algorithm.  

Long: String representation of the authentication algorithm used by the IPMI agent. Value may be set to one of the valid enum values.  

Value Type: `enum[default,none,MD2,MD5,straight,OEM,RMCP+]`

---

### ipmi_disable_until  

Type: Node   
Is: zabbixValueNode   
Parent: [IPMI](#IPMI)  

Short: Timestamp for the next polling time of an unavailable IPMI agent.  

Value Type: `string`

---

### ipmi_error  

Type: Node   
Is: zabbixValueNode   
Parent: [IPMI](#IPMI)  

Short: Error text if IPMI agent is unavailable.  

Value Type: `string`

---

### ipmi_password  

Type: Node   
Is: zabbixValueNode   
Parent: [IPMI](#IPMI)  

Short: Password required to authenticate with the IPMI.  

Long: The IPMI Password is used for the server to authenticate with IPMI. This value may be set to update it on the remote server.  

Value Type: `string`

---

### ipmi_privlege  

Type: Node   
Is: zabbixValueNode   
Parent: [IPMI](#IPMI)  

Short: IPMI Privilege level  

Long: This is the string representation of IPMI priviledge level on the server. This value may be modified with one of the enum values.  

Value Type: `enum[callback,user,operator,admin,OEM]`

---

### ipmi_username  

Type: Node   
Is: zabbixValueNode   
Parent: [IPMI](#IPMI)  

Short: Username required to authenticate with the IPMI  

Long: The IPMI Username is used for the server to authenticate with IPMI. This value may be set to update it on the remote server.  

Value Type: `string`

---

### JMX  

Type: Node   
Parent: [ZabbixHost](#ZabbixHost)  

Short: JMX Availability and grouping of other JMX related values.  

Long: JMX value is a string representation of the availability of JMX agent. Value may be Available, Unavailable, or Unknown.  

Value Type: `string`

---

### jmx_disable_until  

Type: Node   
Is: zabbixValueNode   
Parent: [JMX](#JMX)  

Short: Timestamp value of the next polling time of an unavailable JMX agent.  

Value Type: `string`

---

### jmx_error  

Type: Node   
Is: zabbixValueNode   
Parent: [JMX](#JMX)  

Short: Error text if the JMX agent is unavailable.  

Value Type: `string`

---

### jmx_error_from  

Type: Node   
Is: zabbixValueNode   
Parent: [JMX](#JMX)  

Short: Timestamp value of when the JMX agent became unavailable.  

Value Type: `string`

---

### maintenanceid  

Type: Node   
Parent: [ZabbixHost](#ZabbixHost)  

Short: The ID of the maintenance that is currently in effect on the host.  

Value Type: `string`

---

### maintenance_from  

Type: Node   
Is: zabbixValueNode   
Parent: [maintenanceid](#maintenanceid)  

Short: Timestamp of the starting time of the effective maintenance.  

Value Type: `string`

---

### maintenance_status  

Type: Node   
Is: zabbixValueNode   
Parent: [maintenanceid](#maintenanceid)  

Short: Effective maintenance status.  

Long: This is a string representation of the current maintenance status. Value may be No Maintenance or In effect.  

Value Type: `string`

---

### maintenance_type  

Type: Node   
Is: zabbixValueNode   
Parent: [maintenanceid](#maintenanceid)  

Short: Effective maintenance type.  

Long: Maintenance Type is a string representation of the current maintenance type. Value may be With data collection or Without data collection.  

Value Type: `string`

---

### name  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixHost](#ZabbixHost)  

Short: Name of the host on the remote server.  

Long: This value may be updated to update host configuration on the remote server. Successful update will also update the display name of this ZabbixHost node.  

Value Type: `string`

---

### proxy_hostid  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixHost](#ZabbixHost)  

Short: Id of the proxy that is used to monitor the host.  

Long: The value of this field can be updated to change the proxy used for monitoring this host.  

Value Type: `string`

---

### SNMP  

Type: Node   
Parent: [ZabbixHost](#ZabbixHost)  

Short: Grouping of SNMP related values, and SNMP availability.  

Long: The value of this field indicates if SNMP functionality for this host is Available, Unavailable or Unknown.  

Value Type: `string`

---

### snmp_disable_until  

Type: Node   
Is: zabbixValueNode   
Parent: [SNMP](#SNMP)  

Short: Timestamp of the next polling time of an unavailable SNMP agent.  

Value Type: `string`

---

### snmp_error  

Type: Node   
Is: zabbixValueNode   
Parent: [SNMP](#SNMP)  

Short: Error text if SNMP is unavailable.  

Value Type: `string`

---

### snmp_errors_from  

Type: Node   
Is: zabbixValueNode   
Parent: [SNMP](#SNMP)  

Short: Timestamp when the SNMP agent became unavailable.  

Value Type: `string`

---

### status  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixHost](#ZabbixHost)  

Short: Status of the Host.  

Long: Status may be @set to disable or enable monitoring of this host.  

Value Type: `enum[Monitored,Unmonitored]`

---

### Items  

Type: Node   
Parent: [ZabbixHost](#ZabbixHost)  

Short: Collection of items for the given ZabbixHost.  


---

### ZabbixItem  

Type: Node   
Parent: [Items](#Items)  

Short: Items associated with a given Zabbix Host.  

Long: Detailed information regarding the monitoring points for a given Zabbix Host. The path is the Item Id and the display name is the item's key.  


---

### itemid  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Id of the Item.  

Value Type: `string`

---

### delay  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Update interval of the item in seconds.  

Value Type: `number`

---

### hostid  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Id of the host the item belongs to.  

Value Type: `string`

---

### interfaceid  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Id of the item's host interface. Only for host items.  

Value Type: `string`

---

### key  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Item key  

Value Type: `string`

---

### name  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Name of the item  

Value Type: `string`

---

### type  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Type of the item  

Long: String representation of the type of the item. Can be set to an enum value.  

Value Type: `enum[Zabbix Agent,SNMPv1 Agent,Zabbix Trapper,Simple Check,SNMPv2 Agent,Zabbix Internal,SNMPv3 Agent,Zabbix Agent (active),Zabbix Aggregate,Web Item,External Clock,Database Monitor,IPMI Agent,SSH Agent,Telnet Agent,Calculated,JMX Agent,SNMP Trap]`

---

### value_type  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Type of information the item provides.  

Long: Value type is the type of information that is contained in the value. Can be set to one of the enum values.  

Value Type: `enum[Numeric float,Character,Log,Numeric unsigned,text]`

---

### authtype  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: SSH authentication method. Used only by SSH agent items.  

Value Type: `enum[password,public key]`

---

### data_type  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Data type of the item.  

Value Type: `enum[decimal,octal,hexadecimal,boolean]`

---

### delay_flex  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Flexible intervals as a serialized string  

Value Type: `string`

---

### delta  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Value that will be stored.  

Value Type: `enum[as is,Delta (speed per second),Delta (simple change)]`

---

### description  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Description of the item.  

Value Type: `string`

---

### error  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Error text if there are problems updating the item.  

Value Type: `string`

---

### flags  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Origin of the item.  

Long: A string representation of the origin of the time. Possible values are Plain Item or Discovered Item.  

Value Type: `string`

---

### formula  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Custom multipler  

Value Type: `number`

---

### history  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Number of days to keep the item's history.  

Value Type: `number`

---

### inventory_link  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Id of the host inventory field that is populated by the item.  

Value Type: `number`

---

### ipmi_sensor  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: IPMI sensor. Used only by IPMI items.  

Value Type: `string`

---

### lastclock  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Timestamp when the item was last updated.  

Value Type: `string`

---

### lastns  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Nanoseconds when the item was last updated.  

Value Type: `number`

---

### lastvalue  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Last value of the item.  

Value Type: `string`

---

### logtimefmt  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Format of the time in log entries. Only used by log items.  

Value Type: `string`

---

### mtime  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Time when the monitored log file was last updated.  

Value Type: `string`

---

### multiplier  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Whether to use a custom multiplier  

Value Type: `number`

---

### params  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Additional parameters depending on the type of the item.  

Long: Parameters may be executed scripts for SSH/Telnet items; SQL query for database monitor items; or formula for calculated items.  

Value Type: `string`

---

### password  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Password used for authentication.  

Long: Password that is required for simple check, SSH, telnet, database monitor and JMX items.  

Value Type: `string`

---

### port  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Port monitored by the item. Used only by SNMP items.  

Value Type: `string`

---

### prevvalue  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Previous value of the item.  

Value Type: `string`

---

### privatekey  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Name of the private key file.  

Value Type: `string`

---

### publickey  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Name of the public key file.  

Value Type: `string`

---

### snmp  

Type: Node   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Collection of Item SNMP configurations.  


---

### snmp_community  

Type: Node   
Is: zabbixValueNode   
Parent: [snmp](#snmp)  

Short: SNMP community. Used only by SNMPv1 an SNMPv2 items.  

Value Type: `string`

---

### snmp_oid  

Type: Node   
Is: zabbixValueNode   
Parent: [snmp](#snmp)  

Short: SNMP OID to query.  

Value Type: `string`

---

### snmpv3_authpassphrase  

Type: Node   
Is: zabbixValueNode   
Parent: [snmp](#snmp)  

Short: SNMPv3 auth passphrase. Used only by SNMPv3 items.  

Value Type: `string`

---

### snmpv3_authprotocol  

Type: Node   
Is: zabbixValueNode   
Parent: [snmp](#snmp)  

Short: SNMPv3 auth protocol. Used only by SNMPv3 items.  

Value Type: `enum[MD5,SHA]`

---

### snmpv3_contextname  

Type: Node   
Is: zabbixValueNode   
Parent: [snmp](#snmp)  

Short: SNMPv3 context name. Used only by SNMPv3 items.  

Value Type: `string`

---

### snmpv3_privpassphrase  

Type: Node   
Is: zabbixValueNode   
Parent: [snmp](#snmp)  

Short: SNMPv3 priv passphrase. Used only by SNMPv3 items.  

Value Type: `string`

---

### snmpv3_privprotocol  

Type: Node   
Is: zabbixValueNode   
Parent: [snmp](#snmp)  

Short: SNMPv3 privacy protocol.  

Value Type: `enum[DES,AES]`

---

### snmpv3_securitylevel  

Type: Node   
Is: zabbixValueNode   
Parent: [snmp](#snmp)  

Short: SNMPv3 Security level. Used only by SNMPv3 items.  

Value Type: `enum[noAuthNoPriv,authNoPriv,authPriv]`

---

### snmpv3_securityname  

Type: Node   
Is: zabbixValueNode   
Parent: [snmp](#snmp)  

Short: SNMPv3 Security name. Used only by SNMPv3 items.  

Value Type: `string`

---

### state  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: State of the item.  

Long: String representation of the state of the item. Possible values normal, or not supported  

Value Type: `string`

---

### status  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Status of the item.  

Value Type: `enum[enabled,disabled]`

---

### templateid  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Id of the parent template item.  

Value Type: `string`

---

### trapper_hosts  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Allowed hosts. Only used by trapper items.  


---

### trends  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Number of days to keep item's trends data.  

Value Type: `number`

---

### units  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Value units.  

Value Type: `string`

---

### username  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Username for authentication.  

Long: Username that is required for simple check, SSH, telnet, database monitor and JMX items.  

Value Type: `string`

---

### valuemapid  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixItem](#ZabbixItem)  

Short: Id of the associated value map.  

Value Type: `string`

---

### Triggers  

Type: Node   
Parent: [ZabbixHost](#ZabbixHost)  

Short: Container node for the ZabbixTriggers  


---

### ZabbixTrigger  

Type: Node   
Is: zabbixTriggerNode   
Parent: [Triggers](#Triggers)  

Short: Triggers for a Zabbix Host as defined on the remote server.  

Long: Zabbix Triggers are the definition of an event which make cause an Event or Alert to happen. The path name is the trigger Id and the display name is the short description given to the trigger. The value is the current state of the trigger and may be Ok, or Problem  

Value Type: `string`

---

### triggerId  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixTrigger](#ZabbixTrigger)  

Short: Id of the trigger on the remote server.  

Value Type: `string`

---

### description  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixTrigger](#ZabbixTrigger)  

Short: Name of the trigger. Value may be set.  

Value Type: `string`

---

### expression  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixTrigger](#ZabbixTrigger)  

Short: Reduced trigger expression. May be set.  

Value Type: `string`

---

### comments  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixTrigger](#ZabbixTrigger)  

Short: Additional comments to the trigger. Value may be set.  

Value Type: `string`

---

### error  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixTrigger](#ZabbixTrigger)  

Short: Error text if there have been problems updating the trigger.  

Long: If an error occurred when updating the state of the trigger, the error text will appear here. Cannot be set.  

Value Type: `string`

---

### flags  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixTrigger](#ZabbixTrigger)  

Short: Origin of the trigger.  

Long: Indicate the origin of the trigger. Value may be plain or discovered.  

Value Type: `string`

---

### lastchange  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixTrigger](#ZabbixTrigger)  

Short: Timestamp indicating when the trigger last changed its state.  

Value Type: `string`

---

### priority  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixTrigger](#ZabbixTrigger)  

Short: Severity of the trigger.  

Long: Priority is the string representation of the priority level of the trigger. May be modified as one of the enum values.  

Value Type: `enum[not classified,information,warning,average,high,disaster]`

---

### state  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixTrigger](#ZabbixTrigger)  

Short: State of the trigger.  

Long: State is the string representation of the trigger's current state. Possible values are Up to date, Unknown.  

Value Type: `string`

---

### status  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixTrigger](#ZabbixTrigger)  

Short: Whether the trigger is enabled or disabled.  

Long: The enum values may be used to change the current state of the trigger.  

Value Type: `enum[enabled,disabled]`

---

### templateid  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixTrigger](#ZabbixTrigger)  

Short: Id of the parent template trigger.  

Value Type: `string`

---

### type  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixTrigger](#ZabbixTrigger)  

Short: Whether the trigger can generate multiple problem events.  

Long: The enum values may be set and used to change if the trigger can generate multiple problem events.  

Value Type: `enum[single event,multple events]`

---

### url  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixTrigger](#ZabbixTrigger)  

Short: The Url associated with the trigger. May be set.  

Value Type: `string`

---

### Events  

Type: Node   
Parent: [ZabbixTrigger](#ZabbixTrigger)  

Short: Container node for ZabbixEvent's on a Trigger.  


---

### ZabbixEvent  

Type: Node   
Is: zabbixEventNode   
Parent: [Events](#Events)  

Short: Events generated by the parent ZabbixTrigger  

Long: A ZabbixEvent is generated by a Trigger conditions being met. The path and name for the event is the eventId.  


---

### eventid  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixEvent](#ZabbixEvent)  

Short: Id of the event  

Value Type: `string`

---

### acknowledged  

Type: Node   
Parent: [ZabbixEvent](#ZabbixEvent)  

Short: Total number of acknowledgements on this event.  

Value Type: `number`

---

### Acknowledgements  

Type: Node   
Parent: [acknowledged](#acknowledged)  

Short: Collection of Acknowledgements on this trigger.  


---

### ZabbixAcknowledgement  

Type: Node   
Parent: [Acknowledgements](#Acknowledgements)  

Short: Acknowledgement received by the remote server.  

Long: An acknowledgement for the event on the trigger. Path and name are the acknowledgementId.  


---

### userid  

Type: Node   
Parent: [ZabbixAcknowledgement](#ZabbixAcknowledgement)  

Short: User who acknowledged the event. Display name is User ID. The value is the user's Id.  

Value Type: `string`

---

### alias  

Type: Node   
Is: zabbixValueNode   
Parent: [userid](#userid)  

Short: Alias for the user.  

Value Type: `string`

---

### name  

Type: Node   
Is: zabbixValueNode   
Parent: [userid](#userid)  

Short: The user's first name.  

Value Type: `string`

---

### surname  

Type: Node   
Is: zabbixValueNode   
Parent: [userid](#userid)  

Short: The user's surname (last name).  

Value Type: `string`

---

### clock  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixAcknowledgement](#ZabbixAcknowledgement)  

Short: Timestamp of the acknowledged time.  

Value Type: `string`

---

### message  

Type: Node   
Is: zabbixNodeValue   
Parent: [ZabbixAcknowledgement](#ZabbixAcknowledgement)  

Short: Message which accompanies the acknowledgement.  

Value Type: `string`

---

### clock  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixEvent](#ZabbixEvent)  

Short: Timestamp of when the event was created.  

Value Type: `string`

---

### ns  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixEvent](#ZabbixEvent)  

Short: Nanosecond timestamp of when the event was created.  

Value Type: `string`

---

### object  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixEvent](#ZabbixEvent)  

Short: Type of object related to this event.  

Long: String representation of the type of object for this event. The value will vary depending on the event type.  

Value Type: `string`

---

### objectid  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixEvent](#ZabbixEvent)  

Short: Id of the object related to this event.  

Value Type: `string`

---

### source  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixEvent](#ZabbixEvent)  

Short: The type of event.  

Value Type: `string`

---

### value  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixEvent](#ZabbixEvent)  

Short: State of the related object.  

Long: The value of the event is the string representation of the status of the object related to the event. This will vary depending on the type of event generated.  

Value Type: `string`

---

### value_changed  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixEvent](#ZabbixEvent)  

Short: Value changed is the number of times the event's value has updated.  

Value Type: `number`

---

### Acknowledge_Event  

Type: Action   
Is: zabbixAcknowledgeEvent   
Parent: [ZabbixEvent](#ZabbixEvent)  

Short: Send an acknowledgement of the event to the remote server.  

Long: Acknowledge Event will acknowledge the event with the remote server. If successful, the acknowledgement will be added to the events acknowledgements. Action will fail if message parameter is not specified.  

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

Type: Node   
Parent: [ZabbixEvent](#ZabbixEvent)  

Short: Container of alerts generated by the ZabbixEvent  


---

### ZabbixAlert  

Type: Node   
Is: zabbixAlertNode   
Parent: [Alerts](#Alerts)  

Short: Information regarding certain action operations executed on an event.  

Long: ZabbixAlert contains details about which operations took place after an event was triggered. The path is the alertId. Alerts are generated by the remote Zabbix server and values cannot be modified.  


---

### actionid  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixAlert](#ZabbixAlert)  

Short: Id of the action that generated the alert.  

Value Type: `string`

---

### alerttype  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixAlert](#ZabbixAlert)  

Short: Type of alert. Values are message or remote command.  

Value Type: `string`

---

### clock  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixAlert](#ZabbixAlert)  

Short: Timestamp of when the alert was generated  

Value Type: `string`

---

### error  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixAlert](#ZabbixAlert)  

Short: Error text if there are issues sending a message or running a command.  

Value Type: `string`

---

### esc_step  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixAlert](#ZabbixAlert)  

Short: Escalation step during which the alert was generated.  

Value Type: `number`

---

### eventid  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixAlert](#ZabbixAlert)  

Short: Id of the event that triggered the action.  

Value Type: `string`

---

### mediatypeid  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixAlert](#ZabbixAlert)  

Short: Id of the media type used to send the message.  

Value Type: `string`

---

### message  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixAlert](#ZabbixAlert)  

Short: Message text used in message alerts.  


---

### retries  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixAlert](#ZabbixAlert)  

Short: Number of times remote Zabbix server tried to send the message.  

Value Type: `number`

---

### sendto  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixAlert](#ZabbixAlert)  

Short: Address, username, or identifier of the recipient for message alerts.  

Value Type: `string`

---

### status  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixAlert](#ZabbixAlert)  

Short: Status of the action operation.  

Long: Status is a string representation of the status of the action operation. This will vary depending on the alert type.  

Value Type: `string`

---

### subject  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixAlert](#ZabbixAlert)  

Short: Message subject used for message alerts.  

Value Type: `string`

---

### userid  

Type: Node   
Is: zabbixValueNode   
Parent: [ZabbixAlert](#ZabbixAlert)  

Short: Id of the user the message was sent to.  


---


```
- root
 |- Add_Connection
 |- ZabbixNode
 | |- Refresh_Hosts
 | |- Edit_Connection
 | |- Remove_Connection
 | |- HostGroups
 | | |- Create_Hostgroup
 | | |- ZabbixHostGroup
 | | | |- flags
 | | | |- internal
 | | | |- Rename_Hostgroup
 | | | |- Delete_Hostgroup
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
 | | | | | | | | |- Acknowledge_Event
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
