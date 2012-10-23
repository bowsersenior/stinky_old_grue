require 'test_helper'
require 'basic_quest/game'

# sets instance vars
lambda do
  g = BasicQuest::Game.new({:map => {:foo => :bar}, :teleport_room => :baz})
  assert g.instance_variable_get(:@map), :== => {:foo => :bar}
  assert g.instance_variable_get(:@teleport_room), :== => :baz
  assert g.instance_variable_get(:@current_room), :== => :foo
end.call