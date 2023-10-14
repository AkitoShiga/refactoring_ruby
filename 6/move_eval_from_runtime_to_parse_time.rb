=begin
evalを実行時からパース時へ
evalを使わなければならないが、evalの実行回数を減らしたい
メソッド定義の中でevalを使うのではなく、メソッドを定義するときに使う
=end

class Person
  def self.attr_with_default(options)
    options.each_pair do |attribute, default_value|
      define_method attribute do
        eval "#{attribute} ||= #{default_value}}"
      end
    end
  end
end

# evalだからなんでも渡せる
attr_with_default emails: "[]", employee_number: "EmployeeNumberGenerator.next"

class Person
  def self.attr_with_default(option)
    options.each_pair do |attribute, default_value|
      eval "define_method #{attribute} do
        @#{attribute} ||= #{default_value}
      end"
    end
  end
end