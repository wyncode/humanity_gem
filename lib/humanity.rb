require "humanity/version"
require "pg"
require "active_support/core_ext/hash/keys"
require "active_support/core_ext/hash/except"

module Humanity
  class Person
    @@connection = PG::Connection.open(dbname: 'contacts')
    @@attributes = [:tummy, :emotion, :first_name, :last_name, :id]
    @@public_attributes = [:tummy, :emotion, :first_name, :last_name]
    attr_reader :id
    attr_accessor *@@public_attributes

    def initialize(first_name: nil, last_name: nil, tummy: "grumbling", emotion: "sad")
      @first_name = first_name
      @last_name  = last_name
      @tummy      = tummy
      @emotion    = emotion
    end

    def skills
      ["eating"]
    end

    def eat_lunch
      @tummy    = "full"
      @emotion  = "happy"
      self
    end

    def save
      if self.id
        conds = @@public_attributes
                  .map{ |attr| "#{attr} = '#{send(attr)}'" }
                  .join(", ")
        sql   = "UPDATE people
                SET #{conds}
                WHERE id = #{self.id}
                RETURNING #{@@attributes.join(', ')};"
      else
        values  = @@public_attributes
                    .map{ |attr| "'#{send(attr)}'" }
                    .join(', ')
        sql     = "INSERT INTO people(#{@@public_attributes.join(', ')})
                  VALUES(#{values})
                  RETURNING #{@@attributes.join(', ')};"
      end
      record  = @@connection.exec(sql).first
      @id     = record["id"]
      self.class.from_record(record)
    end

    def delete
      if self.id
        @@connection.exec(
          "DELETE FROM people
          WHERE id = #{self.id}"
        )
      end
      true
    end

    def attributes
      attrs = {}
      @@attributes.each do |attribute|
        attrs[attribute.to_s] = send(attribute)
      end
      attrs
    end

    def self.find(id)
      record = @@connection.exec(
        "SELECT #{@@attributes.join(', ')} FROM people
        WHERE id = #{id}"
      ).first
      self.from_record(record)
    rescue
      nil
    end

    def self.all
      @@connection.exec(
        "SELECT #{@@attributes.join(', ')} FROM people;"
      ).map{ |record| self.from_record(record) }
    end

    def self.where(conds)
      conds = conds.map{ |key, value| "#{key} = '#{value}'" }.join(" AND ")
      @@connection.exec(
        "SELECT #{@@attributes.join(', ')} FROM people
        WHERE #{conds};"
      ).map{ |record| self.from_record(record) }
    end

    private

    def self.from_record(record)
      instance = self.new(record.symbolize_keys.except(:id))
      instance.instance_variable_set(:@id, record["id"])
      instance
    end

  end
end
