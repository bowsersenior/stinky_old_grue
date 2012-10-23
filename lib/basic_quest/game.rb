require "observer"
require "basic_quest/args_helper"
require "basic_quest/grue"

module BasicQuest
  class Game
    include Observable

    VALID_INPUTS = %w(N E S W)

    attr_accessor :map,
                  :teleport_room,
                  :current_room,
                  :last_action,
                  :last_direction,
                  :turn,
                  :grue,
                  :gems

    def initialize(opts)
      BasicQuest::ArgsHelper.require!(opts, :map, :teleport_room)

      self.map           = opts[:map]
      self.teleport_room = opts[:teleport_room]

      self.grue = Grue.new(:map => self.map, :player_room => self.current_room)
      self.spawn_grue
    end

    def spawn_player(room=nil)
      self.gems = 0
      self.turn = 1

      self.current_room = room || self.map.keys.sample

      self.broadcast :started
    end

    def spawn_grue
      self.grue.spawn(self.current_room)
    end

    def prompt_for_direction
      self.broadcast :prompt_for_direction
    end

    def in_teleport_room?
      self.current_room == self.teleport_room
    end

    def go_through_door(direction)
      self.last_direction = direction.to_sym
      self.turn += 1

      next_room = self.map[self.current_room][self.last_direction]
      if next_room
        self.current_room = next_room

        self.broadcast(:entered_teleport_room) if self.in_teleport_room?

        if self.done?
          self.broadcast :done
        else
          self.broadcast :changed_room
        end
      else
        self.broadcast :found_locked_door
      end
    end

    def rest
      self.broadcast :take_a_rest
      self.turn += 1
    end

    def grue_attacks_player
      self.broadcast :grue_attacks_player
      self.spawn_player
    end

    def player_attacks_grue
      self.broadcast :player_attacks_grue
      self.gems += 1

      random_room_next_door = self.map[self.current_room].select do |direction, room|
        !room.nil?
      end.values.sample

      self.grue.current_room = random_room_next_door
    end

    def done?
      self.gems == 5 && self.in_teleport_room?
    end

    def win
      self.broadcast :win
    end

    def valid_input?(d)
      VALID_INPUTS.include?(d)
    end

    def to_hash
      {
        :current_room   => self.current_room,
        :last_action    => self.last_action,
        :teleport_room  => self.teleport_room,
        :last_direction => self.last_direction,
        :turn           => self.turn,
        :gems           => self.gems
      }
    end

    # mark this object as changed & broadcast to observers
    def broadcast(action)
      self.last_action = action
      self.changed
      self.notify_observers(self.to_hash)
    end
  end
end