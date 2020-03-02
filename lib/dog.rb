require_relative '../config/environment.rb'

class Dog

  attr_accessor :name, :breed, :id

  def initialize(attributes)
    if attributes
      attributes.each{|k,v| self.send(("#{k}="), v)}
    end
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs(id INTEGER PRIMARY KEY, name TEXT, breed TEXT)
    SQL
  
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS dogs
    SQL
  
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed) VALUES(?, ?)
      SQL
    
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    self
  end

  def self.create(name:, breed:)
    dog_hash = {:name => name, :breed => breed}
    dog = Dog.new(dog_hash)
    dog.save
    dog 
  end 
  
  def self.new_from_db(row)
    dog_hash = {:id => row[0], :name => row[1], :breed => row[2]}
    new_dog = Dog.new(dog_hash)
  end
    

    
end 
    

