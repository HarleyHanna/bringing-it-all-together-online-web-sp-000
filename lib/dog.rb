class Dog
  
  attr_accessor :name, :breed
  attr_reader :id
  
  def initialize(id: nil, name: , breed:)
    @id = id
    @name = name
    @breed = breed
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT)
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE dogs
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.new_from_db(row)
    dog = Dog.new(id: row[0], name: row[1], breed: row[2])
    dog
  end
  
  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
    SQL
    
    DB[:conn].execute(sql, self.name, self.breed)
    self
  end
  
  def self.create(hash)
    new_dog = Dog.new(name: hash[:name], breed: hash[:breed])
    new_dog.save
    new_dog
  end
  
  def self.find_by_id(id)
    sql = <<-SQL
      SELECT * FROM dogs
      WHERE id = (?)
    SQL
    
    dog = DB[:conn].execute(sql, [id]).flatten
    
    Dog.new(id: id, name: dog[1], breed: dog[2])
  end
  
  def self.find_or_create_by(name:, breed:)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
    if !dog.empty?
      dog_data = dog[0]
      dog = Dog.new(name: dog_data[1], breed: dog_data[2])
    else
      dog = self.create(name: name, breed: breed)
    end
      dog
  end
      
  
  
end