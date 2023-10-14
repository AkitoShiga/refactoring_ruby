# 一時変数に副作用をもたらすメソッドをメソッドチェインできるようにする

# セレクトボックスのオプションを追加する
class Select
  def options
    @options ||= []
  end

  def add_options(arg)
    options << arg
  end
end

select = Select.new
select.add_option(1999)
select.add_option(2000)
select.add_option(2001)
select.add_option(2002)
select.add_option(2003)

# Selectのインスタンスを作ってオプションを追加するメソッドを作る
class Select
  def options
    @options ||= []
  end

  def self.with_options(option)
    select = self.new
    select.options << option
    select
  end

  def and(arg)
    options << arg
    self
  end
end

select = Select.with_options(1999)
               .and(2000)
               .and(2001)
               .and(2002)
               .and(2003)
