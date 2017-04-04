pepcli --verbose --pepd https://argus-pep.cnaf.test:8154/authz \
	--capath /etc/grid-security/certificates \
	--cert /etc/grid-security/hostcert.pem \
    	--key /etc/grid-security/hostkey.pem \
     	--keyinfo /proxies/proxy \
	--resourceid my_resource_id \
	--actionid my_action_id
