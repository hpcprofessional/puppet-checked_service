# This class provides the sensible defaults for the main checked_service class
# to inherit.  It should not be called directly.

class checked_service::params {

  $script_name     = 'zbx-query.rb'
  $script_template = $script_name
  $zabbix_api_url  = undef
  $zabbix_user     = undef
  $zabbix_pass     = undef
  $zabbix_proxy    = undef

  case $::kernel {
    'windows': {
      $script_dir   = 'C:\Windows\Temp'
      $script_owner = 'Administrator'
      $script_group = 'Administrators'
      $path_to_ruby = 'C:\Program Files\Puppet Labs\Puppet Enterprise\sys\ruby\bin\ruby.exe'
      $mco_lib_path = 'C:\ProgramData\PuppetLabs\mcollective\etc\plugins\mcollective'
      $gem_provider = 'gem'
    }
    'Linux': {
      $script_dir   = '/tmp'
      $script_owner = 'root'
      $script_group = 'root'
      $path_to_ruby = '/opt/puppet/bin/ruby'
      $mco_lib_path = '/opt/puppet/libexec/mcollective/mcollective'
      #For Puppet v3 this must be puppet module install'd prior to use
      $gem_provider = 'pe_gem'
      #For Puppet v4, the name changes but the provider should be available out-of-the-box.
      #$gem_provider = 'puppet_gem'
    }
    default: {
      # In the *very* unlikely case ..
      fail("This module can only be applied to Linux and Windows systems")
    }
  }

}
