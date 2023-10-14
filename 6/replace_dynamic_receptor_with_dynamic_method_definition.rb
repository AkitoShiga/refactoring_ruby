=begin
動的レセプタから動的メソッドて定義へ
method_missingの代用
=end

# method_missingを使わない動的な移譲
class Decorator
  def initialize(subject)
    @subject = subject
  end

  def method_missing(sym, *args, &block)
    @subject.send sym, *args, &block
  end
end

# subjectに移譲したメソッドが存在しない場合はsubjectでNoMethodErrorが発生する
class Decorator
  def initialize(subject)
    subject.public_methods(false).each do |method|
      (class << self; self; end).class_eval do
        define_method method do |*args|
          subject.send method, *args
        end
      end
    end
  end
end
# subjectに移譲したメソッドが存在しない場合はDecoratorでNoMethodErrorが発生する




