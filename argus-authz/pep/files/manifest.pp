include mwdevel_igtf_distribution
include mwdevel_argus::clients

package { 'ca_policy_*':
  ensure  => latest,
  require => Class['mwdevel_igtf_distribution'],
}

class { 'mwdevel_argus::pepd':
  manage_service                        => false,
  pdp_host                              => 'argus-pdp.cnaf.test',
  pdp_port                              => 8152,
  use_secondary_group_names_for_mapping => true,
  log_level                             => 'DEBUG',
  oidc_pip_client_url                   => 'http://argus-oidc.cnaf.test:8156/argus-oidc-client/tokeninfo',
}
