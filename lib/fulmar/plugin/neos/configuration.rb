require 'fulmar/plugin/neos/version'
require 'fulmar/plugin/neos/dsl_helper'

module Fulmar
  module Plugin
    module Neos
      # Plugin configuration
      class Configuration
        def initialize(config)
          @config = config
        end

        def test_files
          Dir.glob("#{File.dirname(__FILE__)}/config_tests/*.rb")
        end

        def rake_files
          Dir.glob(File.dirname(__FILE__) + '/rake/*.rake')
        end
      end
    end
  end
end
