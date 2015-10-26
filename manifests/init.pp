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
  $path_to_ruby    = $::checked_service::params::path_to_ruby,
  $mco_lib_path    = $::checked_service::params::mco_lib_path,
) inherits checked_service::params {

  # Call out to hiera for a hash of services that we want to manage on this
  # particular machine.
  # See the 'tests' directory for an example yaml file that has this right.
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

  # Manage a simple Zabbix-checking script that accepts arguments for what
  # service' status to check, and how many times to retry if it's not ready yet.
  file { 'check service script':
    ensure  => file,
    mode    => '0755',
    owner   => $script_owner,
    group   => $script_group,
    path    => "${script_dir}/${script_name}",
    content => template("checked_service/${script_name}.erb"),
  }

  # Make sure the script is there, before trying to manage any of the services
  # that will be using it.
  File['check service script'] -> Checked_service::Service <| |>


}
