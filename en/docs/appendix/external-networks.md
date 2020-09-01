# Appendix: Communication with External Networks

Communications between ABCI compute resource and external services/servers are restricted. The permitted communications are:

| Source | Destination | Port | Service Name |
|:--|:--|:--|:--|
| ANY | Compute nodes<br>Memory intensive node | DENIED | - |
| Compute nodes<br>Memory intensive node | ANY | 22/tcp | ssh |
| Compute nodes<br>Memory intensive node | ANY | 53/tcp | dns |
| Compute nodes<br>Memory intensive node | ANY | 80/tcp | http |
| Compute nodes<br>Memory intensive node | ANY | 443/tcp | https |

Especially, for the outbound (compute nodes -> external) communications which are not currently permitted, we will consider granting a permission for a certain period of time on application basis.

For further information, please contact [ABCI support](../contact.md) if you have any request.
