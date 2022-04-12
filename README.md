## Info
For now, only OpenRC scripts are tested.<br/>
### LokiNET
To use LokiNET you can use the `daemon` useflag to make things easier, otherwise you can use your own account.<br/>
To run the daemon:<br/>
`rc-service lokinet start`<br/>

You might need to use dnsmasq in order to translate .loki addresses, do this inside your dnsmaq config:<br/>
```
server=/loki/snode/127.3.2.1
server=127.0.0.1#53000
```
<br/>

Where 127.3.2.1 is LokiNET DNS server and 127.0.0.1:53000 is Stubby/getdns for example.<br/>
Stubby/getdns: https://packages.gentoo.org/packages/net-dns/getdns<br/>

### OXEN Daemon
To use OXEN Daemon you need to set the useflag `daemon` aswell.<br/>
To run it:<br/>
`rc-service oxend start`
