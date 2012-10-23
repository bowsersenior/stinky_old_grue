require 'test_helper'
require 'basic_quest/game'

# sets instance vars
lambda do
  g = BasicQuest::Game.new({:map => :foo, :start_room => :bar, :teleport_room => :baz})
  assert g.map, :== => :foo
  assert g.teleport_room, :== => :baz
  assert g.current_room, :== => :bar
end.call