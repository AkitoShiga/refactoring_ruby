# 委譲しすぎてただの横流しのメソッドになっている場合、カプセル化したオブジェクトを直接呼び出してもらうようにする
# 委譲オブジェクトにアクセサを作って、委譲オブジェクトメソッドの呼び出しを挿入する

class Person
  def initialize(department)
    @department = department
  end

  def manager
    @department.manager
  end
end

class Department
  attr_reader :manager

  def initialize(manager)
    @manager = manager
  end
end

# まずPersonに委譲クラスのアクセサを作る
class Person
  attr_reader :department
end