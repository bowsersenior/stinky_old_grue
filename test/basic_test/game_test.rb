require 'test_helper'
require 'basic_quest/game'

# sets instance vars
lambda do
  g = BasicQuest::Game.new({:map => {:foo => [:bar]}, :teleport_room => :baz})
  assert g.map, :== => {:foo => [:bar]}
  assert g.teleport_room, :== => :baz
end.call