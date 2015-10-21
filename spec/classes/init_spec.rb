require 'spec_helper'
describe 'checked_service' do

  context 'with defaults for all parameters' do
    it { should contain_class('checked_service') }
  end
end
