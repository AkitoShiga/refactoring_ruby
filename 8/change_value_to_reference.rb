=begin
値から参照へ
* 同じインスタンスをいくつも生成するクラスがあるが、それらのオブジェクトを一個のオブジェクトにまとめたい
* オブジェクトを参照オブジェクトと値オブジェクトに分類すると、多くのシステムで役に立つ

参照オブジェクトの種類
* 顧客
* 銀行口座
* オブジェクトが同一かどうかによってオブジェクトの等しさを判定する

値オブジェクトの種類
* 日付
* 金額
* 値の等しさを判定

* 単純なデータを持つだけだったイミュータブルなオブジェクトが、
* 変更可能なデータを追加してオブジェクトを参照するすべての部分にそのデータ変更の効果をあたえたくなった場合に有効
* シンプルなデータ
=end

class Customer
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class Order
  def initialize(customer_name)
    @customer = Customer.new(customer_name)
  end

  def customer=(customer_name)
    @customer = Customer.new(customer_name)
  end

  def customer_name
    @customer.name
  end
end

#--- client
# @param[Array<Order>] 注文リスト
# @param[Customer] お客さん
# @return[Integer] お客さんの注文数
def self.number_of_orders_for(orders, customer)
  orders.count { |o| o.customer_name == customer.name }
end

# ここのorder.customerとcustomerは、論理的には同じものだが、オブジェクトとしては別のものである。
# order.customerとcustomerは同一のインスタンスを参照したい

# 1. 自分のクラスにファクトリメソッドを作成
class Customer
  def self.create(name)
    Customer.new(name)
  end
end

# 2. オーナークラスがファクトリメソッドを使うようにする
class Order
  def initialize(customer_name)
    @customer = Customer.create(customer_name)
  end
end

# 3. Customerへのアクセス方法を決める
# 例: 注文明細のアクセスは注文が提供する
# 今回はCustomer自身のフィールドを利用する
class Customer
  Instances = {}
end

# 4. Customerが要求された時にその場でCustomerを作るか、予め作るかを決める
# 予め作る場合、アプリの立ち上げ時にCustomerをロードする(DB, ファイル, etc)

class Customer
  def self.load_customer
    new("Lemon Car Hire").store
    new("Associated Coffee Machines").store
    new("Bilston Gasworks").store
  end

  def store
    Instances[name] = self
  end

  def self.create(name) # メソッドをわかりやすいようにする
    Instances[name]
  end
end

