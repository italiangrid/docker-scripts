voms-testsuite-image
==============


A docker image based on Centos for testing VOMS clients.


# Build the voms-restsuite image

    docker pull centos:6.4
    docker build --no-cache -t centos-6.4/voms-ts:1.0 .

# Running the VOMS testsuite 

    docker run -v /etc/localtime:/etc/localtime:ro --name voms-ts centos-6.4/voms-ts:1.0 sh -c "pybot --variable vo1_host:vgrid02.cnaf.infn.it --variable vo1:test.vo --variable vo1_issuer:/C=IT/O=INFN/OU=Host/L=CNAF/CN=vgrid02.cnaf.infn.it --pythonpath lib -d reports tests/clients"

