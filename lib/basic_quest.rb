# BasicQuest
# Usage: ruby basic_quest.rb
raise "BasicQuest requires ruby 1.9.3" if RUBY_VERSION < "1.9.3"

require 'basic_quest/config_loader'
require 'basic_quest/game'
require 'basic_quest/output_observer'

module BasicQuest


  def run(config_file='basic_quest.yml')
    config = ConfigLoader.load_yaml(config_file)
    config[:start_room] = (config[:map].keys - [ config[:teleport_room] ]).sample

    g = Game.new(config)
    g.add_observer(OutputObserver)

    g.start

    while !g.done? do
      if g.turn % 4 == 0
        g.rest
        next
      end

      direction = nil

      while ! g.valid_input?(direction) do
        g.prompt_for_direction

        # read first char of input, and convert to upper-case
        direction =  STDIN.gets.strip.upcase[0]
      end

      g.go_through_door(direction)
    end
  end
  module_function :run
end

BasicQuest.run