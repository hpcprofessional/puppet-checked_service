# This class provides the sensible defaults for the main checked_service class
# to inherit.  It should not be called directly.

class checked_service::params {

  case $::kernel {
    'windows': {
      $script_dir      = 'C:\Windows\Temp'
      $script_name     = 'check_service.ps1'
      $script_template = 'check_service.ps1'
      $script_owner    = 'Administrator'
      $script_group    = 'Administrators'
    }
    'Linux': {
      $script_dir      = '/tmp'
      $script_name     = 'check_service.sh'
      $script_template = 'check_service.sh'
      $script_owner    = 'root'
      $script_group    = 'root'
    }
    default: {
      # In the *very* unlikely case ..
      fail("This module can only be applied to Linux and Windows systems")
    }
  }

}
