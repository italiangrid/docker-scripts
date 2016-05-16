include puppet-infn-ca
include puppet-test-ca

class { 'argus::pdp::configure':
  pap_host => 'argus-pap.cnaf.test',
  pap_port => 8150,
  pdp_admin_host => '0.0.0.0'
}
