require 'pry'
class Student
  attr_accessor :name, :grade
  attr_reader :id
  def initialize(name, grade, id=nil)
    @id = id
    @grade = grade
    @name = name
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
      SQL
    DB[:conn].execute(sql)
  end

  def save
    #LEARN.CO does not do a good job with the commented code below.
    # sql = <<-SQL
    #   INSERT INTO students (
    #     name, grade
    #   ) VALUES (
    #     ?, ?
    #   )
    #   SQL, [@name, @grade]
    # DB[:conn].execute(sql)

    DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)", @name, @grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    stu = self.new(name, grade)
    stu.save
    stu
  end
end
