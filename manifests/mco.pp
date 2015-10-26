# This class creates an mcollective application so that a batch of services
# can be easily, remotely, shut down.  It also offers the ability to check on
# the status of a batch of services.

class checked_service::mco {

  # Ensure the presence of the Agent's DDL file.
  file { '/opt/puppet/libexec/mcollective/mcollective/agent/checked_service.ddl':
    ensure => file,
    source => 'puppet:///modules/checked_service/agent/checked_service.ddl',
    notify => Service['pe-mcollective'],
  }

  # Ensure the presence of the Agent's RB file, generated from template.
  file { '/opt/puppet/libexec/mcollective/mcollective/agent/checked_service.rb':
    ensure  => file,
    content => template('checked_service/agent/checked_service.rb.erb'),
    notify => Service['pe-mcollective'],
  }

}
