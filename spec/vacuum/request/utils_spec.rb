require 'spec_helper'

module Vacuum
  module Request
    describe Utils do
      describe '.encode' do
        it 'encodes reserved characters' do
          Utils.encode(',').should eql '%2C'
        end

        it 'does not encode unreserved characters' do
          Utils.encode('~').should eql '~'
        end
      end
    end
  end
end
