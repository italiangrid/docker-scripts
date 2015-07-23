include puppet-test-ca
include puppet-infn-ca

class {'puppet-java':
  java_version =>  8
}

