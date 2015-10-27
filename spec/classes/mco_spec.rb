require 'spec_helper'
describe 'checked_service::mco', :type => :class do
  let(:node) { 'gonzo.puppetlabs.vm' }

  describe 'When called with no parameters on Linux' do
    let(:facts) { {
      :kernel => 'Linux',
    } }
    it do
      should contain_class('checked_service::mco')
      should contain_file('/opt/puppet/libexec/mcollective/mcollective/agent/checked_service.ddl').with( {
        'ensure' => 'file',
        'source' => 'puppet:///modules/checked_service/agent/checked_service.ddl',
        'notify' => 'Service[pe-mcollective]'
      } )
      should contain_file('/opt/puppet/libexec/mcollective/mcollective/agent/checked_service.rb').with( {
        'ensure' => 'file',
        'notify' => 'Service[pe-mcollective]',
      } )
    end
  end

  describe 'When called with no parameters on Windows' do
    let(:facts) { {
      :kernel => 'windows',
    } }
    it do
      should contain_class('checked_service::mco')
      should contain_file('C:\ProgramData\PuppetLabs\mcollective\etc\plugins\mcollective/agent/checked_service.ddl').with( {
        'ensure' => 'file',
        'source' => 'puppet:///modules/checked_service/agent/checked_service.ddl',
        'notify' => 'Service[pe-mcollective]'
      } )
      should contain_file('C:\ProgramData\PuppetLabs\mcollective\etc\plugins\mcollective/agent/checked_service.rb').with( {
        'ensure' => 'file',
        'notify' => 'Service[pe-mcollective]',
      } )
    end
  end

end
