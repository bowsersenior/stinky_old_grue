require 'test_helper'
require 'basic_quest/config_loader'

# raises an error if required opts are missing
lambda do
  stub(YAML, :spy => :load_file, :return => {}) do
    begin
      BasicQuest::ConfigLoader.load_yaml(:foo)
    rescue
      assert $!.message,
        :include? => "map",
        :include? => "teleport_room"
    end
  end
end.call