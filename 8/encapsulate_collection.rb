# コレクションのカプセル化
class Course
  def initialize(name, advanced)
    @name = name
    @advanced = advanced
  end
end

class Person
  attr_accessor :cources
end

# 配列を直接操作している
kent = Person.new
courses = []
courses << Course.new('Smalltalk Programming', false)
courses << Course.new('Appreciating Single Malts', true)
kent.courses = courses

# コレクションに適切な操作メソッドを追加する
class Person
  def initialize
    @courses = []
  end

  def add_course(course)
    @courses << course
  end

  def remove_course(course)
    @courses.delete(course)
  end
end

class Person
  def initialize
    @courses = []
  end

  def add_course(course)
    @courses << course
  end

  def remove_course(course)
    @courses.delete(course)
  end

  def courses=(courses)
    # 初期化処理のために明示的にライターを使うようにラップする
    raise 'Courses should be empty' unless @courses.empty?
    cources.each { |course| add_course(course) }
  end

  def courses
    # コピーを返却することで、コレクションが変更されることを防ぐ
    @courses.dup
  end
end
