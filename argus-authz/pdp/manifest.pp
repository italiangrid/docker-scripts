include mwdevel_infn_ca
include mwdevel_test_ca

class { 'mwdevel_argus::pdp::configure':
  pap_host       => 'argus-pap.cnaf.test',
  pap_port       => 8150,
  pdp_admin_host => '0.0.0.0'
}
