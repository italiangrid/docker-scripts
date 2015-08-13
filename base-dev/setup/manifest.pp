include puppet-maven-repo
include puppet-emi3-release
include puppet-test-ca
include puppet-infn-ca

class {'puppet-java':
  java_version => 8
}
