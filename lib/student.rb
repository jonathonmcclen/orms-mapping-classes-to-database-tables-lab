class Student

  attr_accessor :name, :grade
 
  @@all =[]

  def initialize(name,grade,id=nil)
    @name = name
    @grade = grade
    @id = id

    @@all << self
  end

  def self.create_table
    sql =  <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        grade INT
        )
        SQL
    DB[:conn].execute(sql) 
  end 

  def id 
    @id
  end 

  def self.drop_table
    DB[:conn].execute("DROP TABLE students") 
  end 

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end 

  def self.create(name:, grade:)
    song = Student.new(name, grade)
    song.save
    song
  end
end
