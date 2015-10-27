require 'spec_helper'
describe 'checked_service', :type => :class do
  let(:node) { 'gonzo.puppetlabs.vm' }

  describe 'When called with no parameters on Linux' do
    let(:facts) { {
      :kernel => 'Linux',
    } }

    it {
      should contain_class('checked_service')
    }

  end

  describe 'When called with no parameters on Windows' do
    let(:facts) { {
      :kernel => 'windows',
    } }

    it {
      should contain_class('checked_service')
    }

  end

end
