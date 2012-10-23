require 'yaml'
require 'basic_quest/args_helper'

module BasicQuest
  module ConfigLoader
    class << self
      def load_yaml(file)
        YAML.load_file(file).tap do |config|
          ArgsHelper.require!(config, :map, :teleport_room)

          validate_map!(config)
        end
      end

      def validate_map!(opts)
        origin_rooms      = opts[:map].keys
        destination_rooms = opts[:map].values.collect(&:values).flatten.compact.uniq

        invalid_rooms = destination_rooms - origin_rooms
        if !invalid_rooms.empty?
          require 'debugger'
          debugger
          raise "map contains invalid rooms: #{invalid_rooms.join(', ')}"
        end

        raise "invalid teleport room" unless origin_rooms.include?(opts[:teleport_room])
      end
    end
  end
end