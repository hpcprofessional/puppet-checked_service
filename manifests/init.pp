# This class sets up the resources that are needed for any use of the
# checked_service::service defined type.  It should be included whenever
# the type will be used somewhere.
#
# For more information on the parameters accepted, please refer to the
# module's README.md file.

class checked_service (
  # Parameters that govern the source and placement of a Zabbix checker script.
  $script_dir      = $::checked_service::params::script_dir,
  $script_name     = $::checked_service::params::script_name,
  $script_template = $::checked_service::params::script_template,
  $script_owner    = $::checked_service::params::script_owner,
  $script_group    = $::checked_service::params::script_group,
) inherits checked_service::params {

  # Create a script from a template.  This is intended to be a script that
  # checks the status of a dependent service in Zabbix.
  file { 'check service script':
    ensure  => file,
    mode    => '0755',
    owner   => $script_owner,
    group   => $script_group,
    path    => "${script_dir}/${script_name}",
    content => template("checked_service/${script_name}.erb"),
  }

  # Call out to hiera for a hash of services that we want to manage on this
  # particular machine.
  # See the 'tests' directory for an example yaml file that has one.
  # If hiera didn't come back with a list of services to manage, we print
  # a warning.
  $checked_services = hiera_hash('checked_service::services',undef)
  if $checked_services != undef {
    create_resources( checked_service::service, $checked_services )
  }
  else {
    notify { 'hiera warning':
      message => 'Note: hiera has no checked_service::services for this node',
    }
  }

}
