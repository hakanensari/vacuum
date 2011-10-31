require 'spec_helper'

module Vacuum
  describe Locale do
    describe '.new' do
      it 'raises an error if locale is not valid' do
        expect { Locale.new(:ab) }.to raise_error BadLocale
      end
    end

    describe '#configure' do
      it 'raises an error if key is missing' do
        expect do
          Locale.new(:us).configure do |c|
            c.secret = 'foo'
            c.tag    = 'bar'
          end
        end.to raise_error MissingKey
      end

      it 'raises an error if secret is missing' do
        expect do
          Locale.new(:us).configure do |c|
            c.key = 'foo'
            c.tag = 'bar'
          end
        end.to raise_error MissingSecret
      end

      it 'raises an error if tag is missing' do
        expect do
          Locale.new(:us).configure do |c|
            c.key    = 'foo'
            c.secret = 'bar'
          end
        end.to raise_error MissingTag
      end

      it 'freezes the object' do
        Locale.new(:us).configure do |c|
          c.key    = 'foo'
          c.tag    = 'bar'
          c.secret = 'baz'
        end.should be_frozen
      end
    end
  end
end
