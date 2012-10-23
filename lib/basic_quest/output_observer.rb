module BasicQuest
  module OutputObserver
    MESSAGES = {
      :started => lambda { |hsh|
        "You find yourself in a mysterious place. To get out, find 5 gems to unlock the teleport."
      },
      :found_locked_door => lambda { |hsh|
        "#{hsh[:last_direction]} door in #{hsh[:current_room]} Room is locked!"
      },
      :prompt_for_direction => lambda { |hsh|
        "Currently in #{hsh[:current_room]} Room with #{hsh[:gems]} gem#{'s' if hsh[:gems] != 1}. Which way? (N E S W)"
      },
      :changed_room => lambda { |hsh|
        "Went #{hsh[:last_direction]} to #{hsh[:current_room]} Room."
      },
      :player_attacks_grue => lambda { |hsh|
        "You surprise a stinky, cowardly Grue who runs off and leaves a gem behind. You pick up the gem."
      },
      :entered_teleport_room => lambda { |hsh|
        "You see a wonderful glowing dais in the center of the #{hsh[:current_room]} Room."},
      :take_a_rest => lambda { |hsh|
        "Taking a rest on turn #{hsh[:turn]}."
      },
      :grue_attacks_player => lambda { |hsh|
        "While you were resting, a shaggy old Grue came in to the #{hsh[:current_room]} Room, attacked you and took away all of your gems!"
      },
      :win => lambda { |hsh|
        "Salutations! You have reached the #{hsh[:teleport_room]} Room with 5 gems! You find yourself drawn irresistibly to the glowing dais. You walk towards the dais and find yourself absorbed in an intense bright light then are teleported to a room. You see the nasty old Grue in front of you. Before you can run away, the Grue is transformed into a beautiful white horse. Two big bags of gold are hanging from the saddle. Woohoo, you're rich and have a horse, too!"
      }
    }

    def update(opts)
      template = MESSAGES[ opts[:last_action] ]
      message  = template && template.call(opts)

      if message
        puts(message)
        puts "\n"
      end
    end

    module_function :update
  end
end