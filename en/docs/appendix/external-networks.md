# Appendix. Communication with External Networks

Communications between ABCI and external services/servers are restricted. The permitted communications are:

| Source | Destination | Port | Service Name |
|:--|:--|:--|:--|
| ANY | Compute nodes<br>Memory intensive node | DENIED | - |
| Compute nodes<br>Memory intensive node | ANY | 22/tcp | ssh |
| Compute nodes<br>Memory intensive node | ANY | 53/tcp | dns |
| Compute nodes<br>Memory intensive node | ANY | 80/tcp | http |
| Compute nodes<br>Memory intensive node | ANY | 443/tcp | https |

Especially, for the outbound (Compute nodes -> external) communications which are not currently permitted, we will consider granting a permission for a certain period of time on application basis.

For further information, please contact [ABCI support](../contact.md) of your request for communication permission. 

Provide us with the following information to consider permission for communication: purpose of communication, hostname of the server, role, administrator, IP address, port number, and documents (URL, etc.) explaining the purpose of communication. Please understand that we may ask you to provide additional information.

Requests for permission to communicate should be made by the responsible person of the ABCI Group to [ABCI support](. /contact.md). Or, please forward the e-mail approved by the responsible person of the ABCI Group and send the application to [ABCI support](. /contact.md) via e-mail with cc: responsible person of the ABCI Group.
