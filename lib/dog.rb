class Dog

    attr_accessor :name, :breed, :id
  
      def initialize(name: , breed: , id: nil)
          @id = id
          @name = name
          @breed = breed
      end
  
      def self.create_table
          query = <<-SQL
              CREATE TABLE dogs (
                  id INTEGER PRIMARY KEY,
                  name TEXT,
                  breed TEXT
              )
          SQL
          DB[:conn].execute(query)
      end
  
      def self.drop_table
          query = <<-SQL
              DROP TABLE IF EXISTS dogs
          SQL
          DB[:conn].execute(query)
      end
  
      def save
          query = <<-SQL
              INSERT INTO DOGS (name, breed) VALUES(?, ?)
          SQL
          DB[:conn].execute(query, self.name, self.breed)
          self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
          self
      end
  
      def self.create name: , breed:
          dog = Dog.new(name: name, breed: breed)
          dog.save
      end
  
      def self.new_from_db row
          self.new(id: row[0], name:row[1], breed:row[2])
      end
  
      def self.all
          query = <<-SQL
              SELECT * FROM dogs
          SQL
          DB[:conn].execute(query).map do |row|
              self.new_from_db(row)
          end
      end
  
      def self.find_by_name name
          query = <<-SQL
              SELECT * FROM dogs
              WHERE name = ?
              LIMIT 1
          SQL
          DB[:conn].execute(query, name).map do |row|
              self.new_from_db(row)
          end.first
      end
  
      def self.find id
          query = <<-SQL
              SELECT * FROM dogs
              WHERE id = ?
              LIMIT 1
          SQL
          DB[:conn].execute(query, id).map do |row|
              self.new_from_db(row)
          end.first
      end 

end
