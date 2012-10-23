# BasicQuest
# Usage: ruby basic_quest.rb
raise "BasicQuest requires ruby 1.9.3" if RUBY_VERSION < "1.9.3"

require 'basic_quest/config_loader'
require 'basic_quest/game'

module BasicQuest
  def run(config_file='basic_quest.yml')
    config = ConfigLoader.load_yaml(config_file)

    g = Game.new(config)

    while !g.done? do
      g.next_move
    end

    puts "Salutations! You reached the #{g.teleport_room} Room!"
  end
  module_function :run
end

BasicQuest.run