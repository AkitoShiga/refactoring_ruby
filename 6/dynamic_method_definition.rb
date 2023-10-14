=begin
動的メソッド定義
メソッドの定義が重複しているときに、メソッドの定義を一つにまとめる
=end

def failure
  self.state = :failure
end

def error
  self.state = :error
end

def_each :failure, :error do |method_name|
  self.state = method_name
end

# def_eachを使って類似メソッドを定義する
def failure
  self.state = :failure
end

def error
  self.state = :error
end

def success
  self.state = :success
end

# メソッド名の配列を渡して、それぞれのメソッドを定義する
%i[failure error success].each do |method_name|
  define_mehtod method do
    self.state = method
  end
end

# 読みやすくするためにメソッドを定義する
class Class
  def def_each(*method_names, &block)
    method_names.each do |method_name|
      define_method method_name do
        instance_exec method_name, &block
      end
    end
  end
end

def_each :failure, :error do |method_name|
  self.state = method_name
end

# 動的に定義されたモジュールをextendして、メソッドを定義する
class PostData
  def initialize(post_data)
    @post_data = post_data
  end

  def params
    @post_data[:params]
  end

  def session
    @post_data[:session]
  end
end

class PostData
  def initialize(post_data)
    # 動的なクラス指定
    (class << self; self; end).class_eval do
      post_data.each_pair do |key, value|
        define_method key.to_sym do
          value
        end
      end
    end
  end
end

# 読みにくいので無名もモジュールを定義する
class Hash
  def to_module
    hash = self
    Module.new do
      hash.each_pair do |key, value|
        define_method key do
          value
        end
      end
    end
  end
end

class PostData
  def initialize(post_data)
    self.extend post_data.to_module
  end
end