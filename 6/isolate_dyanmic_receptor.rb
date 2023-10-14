=begin
動的レセプタの分離
method_missingを使っているクラスが容易に書き換えられなくなっている時に新しいクラスを作成して、ロジックを移動する
ActiveRecordのfind_by_attributeメソッドを定義するようなイメージ
=end

# 全てのmethod_missingを捕捉するクラス
class Recorder
  instance_methods.each do |method|
    undef method unless method =~ /^(__|inspect)/
  end

  def messages
    @messagee ||= []
  end

  def method_missing(sym, *args)
    messages << [sym, args]
    self
  end
end

# 新しい機能の追加
class Recorder
  instance_methods.each do |method|
    undef method unless method =~ /^(__|inspect)/
  end

  def messages
    @messagee ||= []
  end

  def method_missing(sym, *args)
    messages << [sym, args]
    self
  end

  def play_for(obj)
    messages.inject(obj) do |result, message|
      result.send message.first, *message.last
    end
  end

  def to_s
    messages.inject([]) do |result, message|
      result << "#{message.first}(args: #{message.last.inspect})"
    end.join(".")
  end
end

class CommandCenter
  def start(command_string)
    self
  end

  def stop(command_string)
    self
  end
end


# 他オブジェクトのメッセージを記録する
recorder = Recorder.new
recorder.start("LRMMMMRL")
recorder.stop("LRMMMMRL")
recorder.play_for(CommandCenter.new)

# recorderのメソッドが増えてくると、動的に処理されたメソッドかどうかを判定する必要がある
# method_missing呼び出しを処理するMessageCollectorクラスを追加する

class MessageCollector
  instance_methods.each do |method|
    undef_method method unless method =~ /^(__|inspect)/
  end

  def messages
    @messages ||= []
  end

  def method_missing(sym, *args)
    messages << [sym, args]
    self
  end
end

# Recorderからメソッドの記録を分離する
class Recorder
  def play_for(obj)
    @message_collector.messages.inject(obj) do |result, message|
      result.send message.first, *message.last
    end
  end

  def record
    @message_collector ||= MessageCollector.new
  end

  def to_s
    @message_collector.messages.inject([]) do |result, message|
      result << "#{message.first}(args: #{mesage.list.inspect})"
    end
  end
end

recorder = Recorder.new
recorder.record.start("LRMMMMRL")
recorder.record.stop("LRMMMMRL")
recorder.play_for(CommandCenter.new)
