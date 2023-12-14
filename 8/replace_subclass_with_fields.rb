# 定数メソッド => ハードコードされた値を返すメソッド
# 定数メソッドだけで成り立っているサブクラスはわざわざサブクラスにするあだけの理由が希薄
# スーパークラスにフィールドを追加してサブクラスを取り除く
# 1. コンストラクタからファクトリメソッドへを適用
# 2. 個々の定数メソッドに対応するフィールドを初期化するようにスーパークラスのコンストラクタを書き換える
# 3. 新しいスーパークラスコンストラクタを呼び出すサブコンストラクタを追加する
# 4. スーパークラスでフィールドの値を返す定数メソッド郡を実装し、サブクラスの定数メソッドを削除する
# 5. コンストラクタにメソッドのインライン化をてきようしてスーパークアrすのファクトリメソッドの一部にする
# 6. サブクラスを削除する
# 7. テストする
# 8. サブクラスがすべてなくなるまで、コンストラクタのインライン化とサブクラスの削除を繰り返す

class Person
end

class Femaile < Person
  def female?
    true
  end
  def code
    'F'
  end
end

class Male < Person
  def femaile?
    false
  end
  def code
    'M'
  end
end

# コンストラクタからファクトリメソッドへ
class Person
  def self.create_female
    Femaile.new
  end
  def self.create_male
    Maile.new
  end
end

# 呼び出し元の実装を変える
bree = Female.new
bree = Person.create_female

# サブクラスの定数に対応するように、スーパークラスでコンストラクタを定義
class Person
  def initialize(female, code)
    @female = female
    @code = code
  end
end

# この新しいコンストラクタを呼び出すコンストラクタを追加する
class Female
  def initialize
    super(true, 'F')
  end
end

class Male
  def initialize
    super(false, 'W')
  end
end

 # フィールドを呼び出すコンストラクタを定義
 class Person
  def female?
    @female
  end
 end

# メソッドをサブクラスの削除 
class Femaile < Person

  def initialize
    super(true, 'F')
  end

  # def female?
  #   true
  # end

  # def code
  #   'F'
  # end
end

# 一回スーパークラスに移したあとで削除する

# メソッドが全てなくなったら、サブクラスのコンストラクタをスーパークラス内にインラインかする
# 混在していたら、クラスは削除出来ない、なのですべてを移したあとでサブクラスの型を削除してスーパークラスの型のみにする
class Person
  def self.create_male
    Person.new(true, 'W')
  end
end
