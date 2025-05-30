# Request for Communication with External Networks

Communications between ABCI and external services/servers are restricted. The permitted communications are:

| Source | Destination | Port | Service Name |
|:--|:--|:--|:--|
| ANY | Compute nodes | DENIED | - |
| Compute nodes | ANY | 22/tcp | ssh |
| Compute nodes | ANY | 53/tcp | dns |
| Compute nodes | ANY | 80/tcp | http |
| Compute nodes | ANY | 443/tcp | https |


For the outbound (Compute nodes -> external) communications which are not currently permitted, we will consider granting a permission for a certain period of time on application basis. 

To discuss communication permission, please [contact ABCI Support](../contact.md). 

Please provide the following information, as it is necessary for us to review your application. 

* Destination server information, IP address/hostname, role, and administrator (or legal entity that manages the server). 
* Port number of the destination. 
* Purpose of communication. 
* Document or URL, etc. explaining that the server name and port number are necessary to achieve the purpose. 

Please understand that we may ask for additional information. 

After the consultation is complete, the responsible person of the ABCI Group should submit a request for permission to communicate to ABCI support. Or, please attach a document showing that you have received approval from the responsible person of the ABCI Group, and also add the responsible person to the cc of your email. 

Please [contact](../contact.md) us for application procedures. 
