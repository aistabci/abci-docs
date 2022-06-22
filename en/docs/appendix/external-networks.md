# Appendix. Communication with External Networks

Communications between ABCI and external services/servers are restricted. The permitted communications are:

| Source | Destination | Port | Service Name |
|:--|:--|:--|:--|
| ANY | Compute nodes<br>Memory intensive node | DENIED | - |
| Compute nodes<br>Memory intensive node | ANY | 22/tcp | ssh |
| Compute nodes<br>Memory intensive node | ANY | 53/tcp | dns |
| Compute nodes<br>Memory intensive node | ANY | 80/tcp | http |
| Compute nodes<br>Memory intensive node | ANY | 443/tcp | https |

For the outbound (Compute nodes -> external) communications which are not currently permitted, we will consider granting a permission for a certain period of time on application basis.

To discuss communication permission, please contact Contact [ABCI Support](../contact.md).

When you contact us, please provide us with the following information to consider permission for communication.

* Name of the destination, IP address/hostname, role, and administrator (or legal entity that manages the server).
* Port number of the destination.
* Purpose of communication.
* Document or URL, etc. explaining that the server name and port number are necessary to achieve the purpose.

Please understand that we may ask for additional information.

After the consultation is complete, the responsible person of the ABCI Group should submit a request for permission to communicate to ABCI support. Or, please attach a document showing that you have received approval from the responsible person of the ABCI Group, and also attach the responsible person of the ABCI Group to the CC before submitting the application. <br>

Please [contact](../contact.md) us for application procedures. 
