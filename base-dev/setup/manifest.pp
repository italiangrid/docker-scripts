include mwdevel_maven_repo
include mwdevel_test_ca
include mwdevel_infn_ca

class { 'mwdevel_umd_repo': umd_repo_version => 4, }
class { 'mwdevel_java_setup': java_version   => 8, }
