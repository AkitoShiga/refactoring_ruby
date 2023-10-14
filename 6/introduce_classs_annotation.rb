=begin
クラスアノテーションの導入

実装の手順がごく一般的なので、安全に隠してしまえるようなメソッドがある
クラス定義からクラスメソッドを呼び出して振る舞いを宣言する
=end

class SearchCriteria
  def initialize(hash)
    @author_id = hash[:author_id]
    @publisher_id = hash[:publisher_id]
    @isbn = hash[:isbn]
  end
end

class SearchCriteria
  hash_initializer :author_id, :publisher_id, :isbn
end

class SearchCriteria
  # hash_initializerは引数の数だけアクセサを定義するinitializeメソッドを定義する
  def self.hash_initializer(*attribute_names)
    define_method(:initialize) do |*args|
      data = args.first || {}
      attribute_names.each do |attribute_name|
        instance_variable_set "@#{attribute_name}", data[attribute_name]
      end
    end
  end
end

# モジュール化する
module CustomInitializers
  def hash_initializer(*attribute_names)
    define_method(:initialize) do |*args|
      data = args.first || {}
      attribute_names.each do |attribute_name|
        instance_variable_set "@#{attribute_name}", data[attribute_name]
      end
    end
  end
end


