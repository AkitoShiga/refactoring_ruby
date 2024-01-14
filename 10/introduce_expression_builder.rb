# APIを理解しやすくする
# 1. クライアント側のコードを修正する...クライアント側のコードから書き換えるとやりやすい
# 2. 元のオブジェクトを使う式ビルダーを作る
# 3. 元のオブジェクトが使われている一つの場所を書き換え、式ビルダーを使うコードにする
# 4. 元のオブジェクトが使われている他の箇所も、すべて式ビルダーを使うコードに書き換える

class Person
  attr_accessor :first_name, :last_name, :ssn

  def save
    PostGateway.save do |persist|
      persist.subject = self
      persist.attributes = %i[first_name last_name ssn]
      persist.to = 'http://www.example.com/person'
    end
  end
end

class Company
  attr_accessor :name, :tax_id

  def save
    GetGatawey.save do |persist|
      persist.subject = self
      persist.attributes = %i[name tax_id]
      persist.to = 'http://www.example.com/companies'
    end
  end
end

class Laptop
  attr_accessor :assigned_to, :serial_number

  def save
    PostGateway.save do |persist|
      persist.subject = self
      persist.attributes = %i[assigned_to serial_number]
      persist.authenticate = true
      persist.to = 'http://www.example.com/issued_laptop'
    end
  end
end

# 1. クライアント側のコードを修正する
class Person
  attr_accessor :first_name, :last_name, :ssn
  def save
    http.post(:first_name, :last_name, :ssn)
        .to('http://www.example.com/person')
  end
end

# Gatewayに実装するのではなく、新しいクラスを作成する

class Person
  def save
    http.post(:first_name, :last_name, :ssn)
        .to('http://www.example.com/person')
  end

  private

  def http
    GatewayExpressionBuilder.new(self)
  end
end

class GatewayExpressionBuilder
  def initialize(subject)
    @subject = subject
  end

  def post(attributes)
    @attributes = attributes
  end

  def to(address)
    PostGateway.save do |persist|
      persist.subject = @subject
      persist.attributes = @attributes
      persit.to = address
    end
  end
end

# Companyクラスも同様に書き換える
class Company < DomainObject
  attr_accessor %i[name tax_id]

  def save
    http.get(:name, :tax_id).to('http://www.example.com/companies')
  end
end

# httpの振る舞いが共通だったので、親クラスに移動する
class DomainObject
  def http
    GatewayExpressionBuilder.new(self)
  end
end

# GetGatewayをサポートする。ハードコードせずにインスタンス変数を使う
class GatewayExpressionBuilder
  def post(attributes)
    @attributes = attributes
    @gateway = PostGateway
  end

  def get(attributes)
    @attributes = attributes
    @gateway = GetGateway
  end

  def to(address)
    @gateway.save do |persist|
      persist.subject = @subject
      persist.attributest = @attributes
      persit.to = address
    end
  end
end

# Laptopも修正する
class Laptop
  attr_accessor :assigned_to, :serial_number

  def save
    http.post(:assigned_to, serial_number)
        .with_authentication
        .to('http://www.example.com/issued_laptop')
  end
end

class GatewayExpressionBuilder
  def with_authentication
    @with_authentication = true
  end

  def to(address)
    @gateway.save do |persist|
      persist.subject = @subject
      persist.attributes = @attributes
      persit.authenticate = @with_authentication
      persit.to = address
    end
  end
end
