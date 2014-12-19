module Broadcast
  class Share

    def self.to message, *targets
      targets.each do |target|
        eval("Broadcast::#{target.to_s.capitalize}").broadcast message
      end
    end

  end
end
