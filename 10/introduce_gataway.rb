# 外部のAPIをラップすする
# 1.生のAPIを使うゲートウェイを導入する
# 2.APIを使っているコードに手をいれ、ゲートウェイを使うようにする
# 3.APIを使っている他のすべての箇所についてmゲートウェイを使うようにする

# Webサービスを使ってデータを永続化するアプリケーション、ドメインオブジェクトの　saveはnet/httpを利用している
class Person
  attr_accessor *%i[first_name last_name ssn]

  def save
    url = URI.parse('http://www.example.com/person')
    request = Net::HTTP::Post.new(url.path)
    request.set_form_data(
      'first_name' => first_name,
      'last_name' => last_name,
      'ssn' => ssn
    )
    Net::HTTP.new(url.host, url.post).start { |http| http.request(request) }
  end
end

# 異なるチームが存在しており、saveに色々な方法がある。template_methoodを適用できるほどは共通化されていない

# 異なるチームの実装
class Company
  attr_accessor *%i[name tax_id]

  def save
    url = URI.parse('http://www.example.com/companies')
    request = Net::HTTP::Get.new(url.path + "?=#{name}&tax_id=#{tax_id}")
    Net::HTTP.new(url.host, url.post).start { |http| http.request(request) }
  end
end

class Laptop
  attr_accessor *%i[assigned_to serial_number]

  def save
    url = URI.parse('http://www.example.com/issued_laptop')
    request = Net::HTTP::Post.new(url.path)
    request.basic_auth 'username', 'password'
    request.set_form_data(
      "assigned_to" => assigned_to,
      "serial_number" => serial_number
    )
    Net::HTTP.new(url.host, url.port).start { |http| http.request(request) }
  end
end

# この問題を解決するために、ゲートウェイを導入する
# インターフェースを統一して、net/httpの処理をカプセル化する

# Personだけが必要とするゲートウェイ
class Gateway
  attr_accessor *%i[subject attributes to]

  def self.save
    gateway = self.new
    yield gateway # yieldの内部でGatewayのプロパティを設定する
    gataway.execute
  end

  def execute
    request = Net::HTTP::Post.new(url.path)
    attribute_hash = attributes.inject({}) do |result, attribute|
      result[attribute.to_s] = subject.send attribute
      result
    end
    request.set_form_data(attribute.hash)
    Net::HTTP.new(url.host, url.port).start { |http| http.request(request) }
  end

  def url
    URI.parse(to)
  end
end

class Person
  attr_accessor *%i[first_name last_name ssn]

  def save
    # gatewayの初期値をブロック内で設定する
    Gateway.save do |gateway|
      gateway.subject = self # value
      gateway.attributes = %i[first_name last_name ssn] # key
      gateway.to = 'http://www.example.com/person'
    end
  end
end

# Companyだけが必要とするゲートウェイ
# PostとGetをサポートする必要があるのでGatewayを修正する
# リクエスト部分を抽象化する

class Gateway
  attr_accessor *%i[subject attributes to]

  def self.save
    gateway = self.new
    yield gateway # yieldの内部でGatewayのプロパティを設定する
    gataway.execute
  end

  def execute
    Net::HTTP.new(url.host, url.post).start do |http|
      http.request(build_request) # リクエスト部分を別の関数にする
    end
  end

  def url
    URI.parse(to)
  end
end

# template?
class PostGateway < Gateway
  def build_request
    request = Net::HTTP::Post.new(url.path)
    attribute_hash = attributes.inject({}) do |result, attribute|
      result[attribute.to_s] = subject.send attribute
      result
    end
    reqest.set_form_data(attribute.hash)
  end
end

class GetGatawey < Gaeawey
  def build_request
    parameters = attributes.collect do |attribute|
      "#{attribute}=#{subject.send(attribute)}"
    end
    Net::HTTP::Get.new("#{url.path}?#{parameters.join("&")}")
  end
end

# CompanyはGetGateway, PersonはPostGatewayを使うようにする
class Company
  attr_accessor %i[name tax_id]

  def save
    GetGatawey.save do |persist|
      persist.subject = self
      persist.attributes = %i[name tax_id]
      persist.to = 'http://www.example.com/companies'
    end
  end
end

class Person
  attr_accessor *%i[first_name last_name ssn]

  def save
    PostGateway.save do |persist|
      persist.subject = self
      persist.attributes = %i[first_name last_name ssn]
      persist.to = 'http://www.example.com/person'
    end
  end
end

# Laptopのために認証をサポートする
class Gateway
  attr_accessor *%i[subject attributes to authenticate]

  def execute
    request = build_request(url)
    request.basic_auth 'username', 'password' if authenticate
    Net::HTTP.new(url.host, url.port).start { |http| http.request(request) }
  end
end

class Laptop
  attr_accessor *%i[assigned_to serial_number]
  def save
    PostGateway.save do |persist|
      persist.subject = self
      persist.attributes = %i[assigned_to serial_number]
      persist.authenticate = true
      persist.to = 'http://www.example.com/issued_laptop'
    end
  end
end
