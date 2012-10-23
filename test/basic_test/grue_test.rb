require 'test_helper'
require 'basic_quest/config_loader'
require 'basic_quest/game'
require 'basic_quest/grue'

config = BasicQuest::ConfigLoader.load_yaml('basic_quest.yml')
all_edges = BasicQuest::Grue.all_edges_for(config[:map])
all_rooms = config[:map].keys

# grue paths are correct
lambda do
  # get every possible path
  all_rooms.combination(2) do |start_room, teleport_room|
    # create a game and set start & teleport rooms
    g = BasicQuest::Game.new( config.merge(:teleport_room => teleport_room) )
    g.spawn_player(start_room)

    # get the purported best path
    best = BasicQuest::Grue.grue_path(start_room, teleport_room, all_edges)

    # we just need the directions
    directions = best.map{ |edge| edge.last }

    # go through the map
    directions.each do |d|
      g.go_through_door(d)
    end

    # check that we got to the teleport room
    assert g.current_room, :== => teleport_room
  end
end.call

# grue paths are shortest
# (hard to test deterministically, so use a stochastic approach)
lambda do

  # keep track of good random paths
  good_random_paths = []
  num_runs = 200
  num_runs.times do
    # pick a random start_room
    # (make sure it's not the same as teleport_room!)
    start_room = (all_rooms - [ config[:teleport_room] ]).sample

    # initialize and start a game
    g = BasicQuest::Game.new(config)
    g.spawn_player(start_room)

    # get the purported best path
    best = BasicQuest::Grue.grue_path(g.current_room, g.teleport_room, all_edges)

    random_path = []
    # walk randomly until we get to the teleport room
    while g.current_room != g.teleport_room do
      corridors = config[:map][g.current_room].select do |direction, room|
        !room.nil?
      end

      if RUBY_VERSION < '1.9.2'
        corridors = Hash[corridors] # ruby 1.8.7 compatibility
      end

      direction = corridors.keys.sample
      next_room = corridors[direction]

      random_path << [ g.current_room, next_room, direction]
      g.go_through_door(direction)
    end

    if best.size == random_path.size
      good_random_paths << random_path
    end

    assert best.size, :<= => random_path.size
  end

  # test run is no good if we don't have enough good random paths
  assert (good_random_paths.size.to_f/num_runs), :> => 0.15
end.call