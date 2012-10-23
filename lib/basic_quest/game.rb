require "observer"

module BasicQuest
  class Game
    include Observable

    VALID_INPUTS = %w(N E S W)

    attr_accessor :map,
                  :teleport_room,
                  :current_room,
                  :last_action,
                  :last_direction,
                  :turn

    def initialize(opts)
      self.map           = opts[:map]
      self.teleport_room = opts[:teleport_room]
      self.turn          = 1
    end

    def start
      self.current_room  = (self.map.keys - [self.teleport_room]).sample
      self.broadcast :started
    end

    def prompt_for_direction
      self.broadcast :prompt_for_direction
    end

    def go_through_door(direction)
      self.last_direction = direction.to_sym
      self.turn += 1

      next_room = self.map[self.current_room][self.last_direction]
      if next_room
        self.current_room = next_room

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

    def done?
      self.current_room == self.teleport_room
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
        :turn           => self.turn
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