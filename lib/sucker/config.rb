module Sucker
  class Config
    class << self

      protected

      def define_configs(*configs)
        configs.each do |config|
          self.class.instance_eval do

            define_method("#{config}=") do |value|
              instance_variable_set("@#{config}", value)
            end

            define_method("#{config}") do
              instance_variable_get("@#{config}")
            end

          end
        end
      end
    end

    define_configs :key, :secret, :associate_tag, :locale

  end
end
