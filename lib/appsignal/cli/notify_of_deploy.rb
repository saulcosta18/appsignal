module Appsignal
  class CLI
    class NotifyOfDeploy
      class << self
        def run(options, config)
          validate_active_config(config)
          validate_required_options(options, [:revision, :user, :environment])

          Appsignal::Marker.new(
            {
              :revision => options[:revision],
              :user => options[:user]
            },
            config
          ).transmit
        end

        protected

        def validate_required_options(options, required_options)
          missing = required_options.select do |required_option|
            val = options[required_option]
            val.nil? || (val.respond_to?(:empty?) && val.empty?)
          end
          if missing.any?
            puts "Missing options: #{missing.join(', ')}"
            exit 1
          end
        end

        def validate_active_config(config)
          unless config.active?
            puts 'Exiting: No config file or push api key env var found'
            exit 1
          end
        end
      end
    end
  end
end
