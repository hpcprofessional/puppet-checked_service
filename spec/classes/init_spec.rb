# This file lays out some basic spec tests to perform on the module's main
# class.
#
# For more information on rspec-puppet, start here:
#
#        http://rspec-puppet.com/tutorial/

require 'spec_helper'
describe 'checked_service', :type => :class do
  let(:node) { 'gonzo.puppetlabs.vm' }

  describe 'When called with no parameters on Linux' do
    let(:facts) { {
      :kernel => 'Linux',
    } }
    it do
      should contain_class('checked_service')
      should contain_package('zabby').with( {
        'ensure' => '0.1.2',
        'provider' => 'pe_gem',
      } )
      should contain_file('check service script').with( {
        'ensure' => 'file',
        'mode'   => '0755',
        'owner'  => 'root',
        'group'  => 'root',
        'path'   => '/tmp/zbx-query.rb',
      } )
      should contain_file('check service script').with_content(/zabby/)
    end
  end

  describe 'When called with no parameters on Windows' do
    let(:facts) { {
      :kernel => 'windows',
    } }
    it do
      should contain_class('checked_service')
      should contain_package('zabby').with( {
        'ensure' => '0.1.2',
        'provider' => 'pe_gem',
      } )
      should contain_file('check service script').with( {
        'ensure' => 'file',
        'mode'   => '0755',
        'owner'  => 'Administrator',
        'group'  => 'Administrators',
        'path'   => 'C:\Windows\Temp/zbx-query.rb',
      } )
      should contain_file('check service script').with_content(/zabby/)
    end
  end

  describe 'When called with no parameters on OS X' do
    let(:facts) { {
      :kernel => 'Darwin',
    } }
    it do
      expect {
        should contain_class('checked_service')
      }.to raise_error(Puppet::Error, /Linux and Windows/)
    end
  end

end
