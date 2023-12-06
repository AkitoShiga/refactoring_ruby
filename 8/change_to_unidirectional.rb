# 片方向リンクから双方向リンクへ

class Order
  attr_accessor :customer
end

require 'set'

class Custoemr
  def initialize
    @orders = Set.new
  end
end

# どちらのクラスに管理させるかを決める
# Orderがリンクを管理する場合は、Ordersコレクションに直接アクセスするためのヘルパーメソッドをCustomersに追加する
# Orderの輪ん区更新メソッドは、このメソッドを使って両方のポインタと同期させる
# ヘルパーメソッドは、この特殊条件のもとでしか使われないことを示す名前をつける

class Customer
  def friend_orders
    # Orderがリンクを更新するときにのみ使われる
    @orders
  end
end

class Order
  attr_reader :customer

  def customer=(value)
    # リンクを切り替える
    customer.friend_orders.subtract (self) unless customer.nil?
    @customer = value
    customer.friend_orders.add(self) unless customer.nil?
  end
end
# お互いにメンバとして持って、代入するときに相手も更新する
# 管理される側は特に何もしない

# 多対多の場合

class Order
  def add_customer(customer)
    customer.friend_orders.add(self)
    @customers.add(customer)
  end

  def remove_customer(customer)
    customer.friend_orders.subtract(self)
    @customers.subtract(customer)
  end
end
