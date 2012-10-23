module BasicQuest
  module ArgsHelper
    def require!(hsh, *required_keys)
      missing_keys = required_keys - hsh.keys
      if !missing_keys.empty?
        raise "missing required key(s): #{missing_keys.join(', ')}"
      end
    end
    module_function :require!
  end
end