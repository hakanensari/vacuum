require 'spec_helper'

describe Vacuum do
  describe '.configure' do
    it 'yields a locale' do
      obj = nil
      Vacuum.configure :us do |c|
        c.key    = 'foo'
        c.secret = 'bar'
        c.tag    = 'baz'
        obj = c
      end

      obj.should be_a Vacuum::Locale
    end
  end
end
