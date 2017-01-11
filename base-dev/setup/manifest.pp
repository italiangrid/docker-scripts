include mwdevel_maven_repo
include mwdevel_emi3_release
include mwdevel_test_ca
include mwdevel_infn_ca

class { 'mwdevel_java_setup': java_version => 8, }
