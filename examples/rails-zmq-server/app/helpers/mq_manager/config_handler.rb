module MqManager
  
  class ConfigHandler
    def load_config
      return Rails.configuration.mq_manager_config if defined? Rails and !Rails.configuration.mq_manager_config.nil?
      require 'yaml'
      config_file = File.join(__dir__, 'config.yml')
      return YAML::load_file(config_file) if File.exists?(config_file)
      raise "No configuration provided for MqManager"
    end
  end
  
end
