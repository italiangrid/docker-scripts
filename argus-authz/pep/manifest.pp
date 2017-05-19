include mwdevel_infn_ca
include mwdevel_test_ca
include mwdevel_argus::clients

class { 'mwdevel_argus::pepd::configure':
  pdp_host                              => 'argus-pdp.cnaf.test',
  pdp_port                              => 8152,
  use_secondary_group_names_for_mapping => true,
  log_level                             => 'DEBUG'
}
