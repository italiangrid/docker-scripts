pepcli --verbose --pepd https://argus-pep.cnaf.test:8154/authz \
	--capath /etc/grid-security/certificates \
	--cert /etc/grid-security/hostcert.pem \
    	--key /etc/grid-security/hostkey.pem \
     	--keyinfo ${X509_USER_PROXY:-/proxies/proxy} \
	--resourceid ${RESOURCE_ID:-my_resource_id} \
	--actionid ${ACTION_ID:-my_action_id}
