require 'basic_quest/args_helper'

module BasicQuest
  class Grue
    attr_accessor :current_room, :edges, :rooms
    def initialize(opts)
      BasicQuest::ArgsHelper.require!(opts, :map, :player_room)

      self.rooms = opts[:map].keys
      self.edges = self.class.all_edges_for(opts[:map])
    end

    # set the grue's current_room as far as possible from the player
    def spawn(player_room)
      # get all possible paths and create a hash indexed by size
      paths_to_player = self.rooms.inject({}) do |hsh, room|
        path = self.class.grue_path(room, player_room, self.edges)
        hsh[path.size] = path
        hsh
      end

      # get the longest of the shortest paths
      # (this is as far away as we can get)
      longest_path = paths_to_player[paths_to_player.keys.max]

      # get the first element of the first edge
      self.current_room = longest_path.first.first
    end

    def move_towards(player_room)
      self.current_room = Grue.grue_path(
        self.current_room,
        player_room,
        self.edges
      ).first[1]
    end

    class << self
      # map is a hash with this structure:
      # {
      #   'room name' => {
      #     :N => 'room 1',
      #     :E => 'room 2',
      #     :S => 'room 3',
      #     :W => 'room 4',
      #   }
      # }
      def all_edges_for(map)
        map.inject([]) do |arr, (room1, rooms)|
          rooms.each do |direction, room2|
            edge = [room1, room2, direction]
            arr << edge unless room1 == room2 || arr.include?(edge)
          end
          arr
        end
      end

      def path_distance(arr)
        if arr.empty?
          Float::INFINITY
        else
          arr.size
        end
      end

      # grue_room : string
      # player_room : string
      # edges : array of arrays
      #           each element has the form [room1, room2, direction]
      def grue_path(grue_room, player_room, edges)
        shortest_path = []

        edges_to_check = edges.select do |arr|
          arr.first == grue_room
        end

        unchecked_edges = edges - edges_to_check

        edges_to_check.each do |e|
          path = [e]
          if e[1] != player_room

            next_node = (e - [grue_room]).first

            remaining_path = grue_path(next_node, player_room, unchecked_edges)

            if remaining_path.empty?
              path.clear
            else
              path += remaining_path
            end
          else
            path
          end

          if path_distance(path) < path_distance(shortest_path)
            shortest_path = path
          end
        end

        shortest_path
      end
    end
  end
end