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
  $service_name  = $title,
  $ensure        = 'running',
  $check_retries = '',
) {

  exec { "/usr/bin/echo checking dependency of ${service_name}":
    unless => '/bin/true',
    before => Service[$service_name],
  }

  service { $service_name:
    ensure => $ensure,
  }

}
