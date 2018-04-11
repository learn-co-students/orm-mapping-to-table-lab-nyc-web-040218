class Student
 require "pry"
  attr_reader :id
  attr_accessor :name, :grade


  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      );
    SQL
    DB[:conn].execute(sql)
  end





  def self.drop_table
    sql = <<-SQL
      DROP TABLE students;
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = get_id

  end

  def get_id
    sql = <<-SQL
      SELECT id FROM students ORDER BY id DESC LIMIT 1
    SQL

    bob = DB[:conn].execute(sql)
    bob[0][0]
  end





  def self.create(hash)
    new_student = Student.new(hash[:name], hash[:grade])
    new_student.save
    return new_student
  end


end
