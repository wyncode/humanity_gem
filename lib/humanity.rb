require "humanity/version"
require "pg"
require "active_record"

ActiveRecord::Base.establish_connection(database: 'contacts', adapter: 'postgresql')

module Humanity
  class Person < ActiveRecord::Base

    def initialize(attributes)
      super
      self.tummy = "grumbling"
      self.emotion = "sad"
    end

    def skills
      ["eating"]
    end

    def eat_lunch
      self.tummy    = "full"
      self.emotion  = "happy"
      self
    end

  end
end
