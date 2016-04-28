# BasicQuest
# Usage: ruby basic_quest.rb

require 'basic_quest/config_loader'
require 'basic_quest/game'
require 'basic_quest/output_observer'
require 'basic_quest/grue'

module BasicQuest
  DEFAULT_CONFIG_FILE_DIR = File.expand_path("../..", __FILE__)
  DEFAULT_CONFIG_FILE     = File.join(DEFAULT_CONFIG_FILE_DIR, 'basic_quest.yml')
  
  # a big ugly method that controls the game flow
  def run(config_file=DEFAULT_CONFIG_FILE)
    config = ConfigLoader.load_yaml(config_file)
    config[:start_room] = (config[:map].keys - [ config[:teleport_room] ]).sample

    g = Game.new(config)
    g.add_observer(OutputObserver)
    g.spawn_player

    gem_count = 0

    while !g.done? do
      if g.turn % 4 == 0
        # check if you are resting and grue attacked you

        g.rest

        old = g.grue.current_room

        # move one room closer to the player
        g.grue.move_towards(g.current_room)

        if g.grue.current_room == g.current_room
          g.grue_attacks_player
        end
        next
      end

      direction = nil

      while ! g.valid_input?(direction) do
        g.prompt_for_direction

        # read first char of input, and convert to upper-case
        direction =  STDIN.gets.strip.upcase[0]
      end

      g.go_through_door(direction)

      # check if you attacked the grue
      if g.grue.current_room == g.current_room
        old = g.current_room

        g.player_attacks_grue
      end
    end

    g.win
  end
  module_function :run
end