module BasicQuest
  module OutputObserver
    MESSAGES = {
      :started => lambda { |hsh|
        "Find 5 gems, then go to the #{hsh  [:teleport_room]} Room."
      },
      :found_locked_door => lambda { |hsh|
        "#{hsh[:last_direction]} door in #{hsh[:current_room]} Room is locked!"
      },
      :prompt_for_direction => lambda { |hsh|
        "Currently in #{hsh[:current_room]} Room. Which way? (N E S W)"
      },
      :changed_room => lambda { |hsh|
        "Went #{hsh[:last_direction]} to #{hsh[:current_room]} Room."
      },
      :take_a_rest => lambda { |hsh|
        "Taking a rest on turn #{hsh[:turn]}."
      },
      :done => lambda { |hsh|
        "Salutations! You reached the #{hsh[:teleport_room]} Room!"
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