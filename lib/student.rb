require 'pry'

class Student

  attr_accessor :name, :grade, :id
  # attr_reader :id

  def initialize(id:, name:, grade:)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    DB[:conn].execute ("
      CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )")
  end

  def self.drop_table
    DB[:conn].execute ("
      DROP TABLE students
      ")
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)

      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      self
  end

  def self.create(some_hash)
    new_student = Student.new
    some_hash.each do |key, value|
      new_student.send(key, value)
    end

    new_student.save
  end

end
