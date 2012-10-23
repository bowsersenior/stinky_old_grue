require 'io/console'

module BasicQuest
  class Game
    attr_accessor :map, :teleport_room, :current_room

    def initialize(opts)
      self.map           = opts[:map]
      self.teleport_room = opts[:teleport_room]
      self.current_room  = (self.map.keys - [self.teleport_room]).sample

      output "Find 5 gems, then go to the #{self.teleport_room} Room"
    end

    def output(message)
      puts message
      puts "\n"
    end

    def done?
      self.current_room == self.teleport_room
    end

    def next_move
      Signal.trap("INT") do # SIGINT = control-C
        exit
      end

      valid_inputs = %w(N E S W n e s w)
      direction = nil

      while ! valid_inputs.include?(direction) do
        output "Currently in #{self.current_room} Room. Which way? (N E S W)"
        direction = STDIN.getch
      end

      go_through_door(direction.upcase)
    end

    private
    def go_through_door(direction)
      next_room = self.map[self.current_room][direction.to_sym]
      if next_room
        self.current_room = next_room
        true
      else
        output "#{direction} door in #{self.current_room} Room is locked!"
        false
      end
    rescue
      require 'debugger'
      debugger
      nil
    end
  end
end