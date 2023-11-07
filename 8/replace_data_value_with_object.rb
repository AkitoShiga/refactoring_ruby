=begin
データ値からオブジェクトへ
データ項目をオブジェクトに書き換える
データ項目に特別なふるまいが必要になったら、オーナークラスにメソッドを追加するのではなく、 新しいクラスを作成する
=end
class Order
  attr_accessor :customer

  def initialize(customer)
    @customer = customer
  end
end

class OrderClient
  def self.number_of_orders_for(orders, customer)
    orders.select { |order| orders.customer == customer }.size
  end
end

# 1. Customerクラスを作成
class Customer
  attr_reader :name # もとのcustoemrに該当.setterはつけない

  def initialize(name)
    @name = name
  end
end

# 2. オーナークラスからCustomerクラスを参照するように変更
class Order
  def initialize(customer)
    @customer = customer
  end

  def customer
    @customer.name
  end

  def customer=(value)
    @customer = Customer.new(value) # 代入ではなく、newする! 代入しないのは、元の立ち位置が値オブジェクトだったから

  end
end

# 3. メソッド名をわかりやすくする
class Order
  def initialize(customer)
    @customer = customer
  end

  def customer_name  # 変更
    @customer.name
  end

  def customer=(value)
    @customer = Customer.new(value) # 代入ではなく、newする! 代入しないのは、元の立ち位置が値オブジェクトだったから
  end
end