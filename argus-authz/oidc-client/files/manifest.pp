include mwdevel_egi_trust_anchors
include mwdevel_infn_ca

package { 'ca-policy-egi-core':
  ensure  => latest,
  require => Class['mwdevel_egi_trust_anchors'],;
}
