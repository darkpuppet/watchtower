# watchtower
Script which tests for internet connectivity, and allows actions to be performed 
when the connection is lost or re-established.

Uses unix /dev/tcp to attempt to connect to a set of known good DNS servers.  

If all DNS servers are unavailable, the 'disconnected' status is set and an action performed.

TODO:  Add more info here.
