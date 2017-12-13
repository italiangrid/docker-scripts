class { 'mwdevel_argus::pdp':
  manage_service         => false,
  pap_host               => 'argus-pap.cnaf.test',
  pap_port               => 8150,
  pdp_admin_host         => '0.0.0.0',
  pdp_retention_interval => '5',
}
