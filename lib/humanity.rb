require "humanity/version"

module Humanity
  class Person
    attr_reader :tummy, :emotion

    def initialize
      @tummy = "grumbling"
      @emotion = "sad"
    end

    def skills
      ["eating"]
    end

    def eat_lunch
      @tummy = "full"
      @emotion = "happy"
    end

  end
end
