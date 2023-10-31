# 委譲の隠蔽
# クライアントがオブジェクト内のの委譲クラスを呼び出している時に、サーバに委譲を隠すためのメソッドを作る
# 委譲のメソッドを作る

class Person
  attr_accessor :department
end

class Department
  attr_reader :manager

  def initialize(manager)
    @manager = manager
  end
end

# クライアントがPersonの上司を知りたい時に、まず部署を呼び出さないといけない
manager = john.department.manager

# 委譲のメソッドを作ってdepatementの知識をクライアントから取り除く
class Person
  def manager
    @department.manager
  end
end
manager = john.manager

