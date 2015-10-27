# This defined type takes two parameters, and loads the rest of its variables
# from the main class (and thus the params class).  It manages a service using
# the built-in type, but makes a script run before the service is managed.
#
# The intention is that the script checks the status of a Zabbix check,
# blocking the run from continuing to the service management until the check
# is successful.
#
# Refer to the module's README.md file for examples.

define checked_service::service (
  $service_name          = $title,
  $ensure                = 'running',
  $enable                = true,

  $checker_argument      = $title,
  $checker_tries         = 4,
  $checker_timeout       = 60,
  $checker_triggers      = undef,
  $service_start_command = undef,
  $service_stop_command  = undef,
) {

  # In case we're being declared directly, make sure the main class is here too.
  include checked_service

  $service_data = hiera('checked_service::services')
  $triggers = $service_data[$service_name]['checker_triggers']

  # Invoke the Zabbix checker
  exec { "Check prerequisite of ${service_name}":
    command  => "'${checked_service::path_to_ruby}' -- ${checked_service::script_dir}/${checked_service::script_name} \'${checker_triggers}\'",
    unless   => "'${checked_service::path_to_ruby}' -- ${checked_service::script_dir}/${checked_service::script_name} \'${checker_triggers}\'",
    before   => Service[$service_name],
    provider => $::kernel ? {
      'Linux'   => 'posix',
      'windows' => 'powershell',
    },
    tries    => $checker_tries,
    timeout  => $checker_timeout,
  }

  # Manage the service specified in our parameters
  service { $service_name:
    ensure => $ensure,
    enable => $enable,
  }
}
