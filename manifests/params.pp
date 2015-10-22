# This class provides the sensible defaults for the main checked_service class
# to inherit.  It should not be called directly.

class checked_service::params {

  $script_name     = 'check_service.rb'
  $script_template = $script_name

  case $::kernel {
    'windows': {
      $script_dir   = 'C:\Windows\Temp'
      $script_owner = 'Administrator'
      $script_group = 'Administrators'
      $path_to_ruby = 'C:\Program Files\Puppet Labs\Puppet Enterprise\sys\ruby\bin\ruby.exe'
    }
    'Linux': {
      $script_dir   = '/tmp'
      $script_owner = 'root'
      $script_group = 'root'
      $path_to_ruby = '/opt/puppet/bin/ruby'
    }
    default: {
      # In the *very* unlikely case ..
      fail("This module can only be applied to Linux and Windows systems")
    }
  }

}
