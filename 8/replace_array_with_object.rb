# 一部の要素が別の’意味を持つような’配列がある
# Arrayを取り除き各要素をフィールドとするオブジェクトを作成する
row = []
row[0] = 'Liverpool'
row[1] = '15'

name = row[0]
wins = row[1].to_i

class Performance
  def initialize
    @data = []
  end

  def []=(index, value)
    @data[index] = value
  end

  def [](index)
    @data[index]
  end
end

row = Performance.new

class Performance
  attr_reader :name

  def wins
    @wins.to_id
  end
end

name = row.name
wins = row.wins

class Performance
  attr_accessor :name, :wins

  def wins
    @wins.to_i
  end
end

row = Performance.new
row.name = 'Liverpool'
row[1] = '15'

class Performance
  attr_accessor :name
  attr_writer :wins
end
