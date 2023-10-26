# クラスが大きくなったら分割する
# 1. メソッドを移動する
# 2. フィールドを移動する

class Person
  attr_reader :name
  attr_accessor :office_area_code
  attr_accessor :office_number

  def telephone_number
    '(' + @office_area_code + ')' + @office_number
  end
end

# 電話番号に関するクラスを移動させる

class TelephoneNumber
end

# PersonからTelephoneNumberへのリンクを作る
class Person
  def initialize
    @office_telephone = TelephoneNumber.new
  end
end

# フィールドの移動
class TelephoneNumber
  attr_accessor :area_code 
end

class Person
  def telephone_number
    '(' + office_area_code + ')' + @office_number
  end

  def office_area_code
    @office_telephone.area_code
  end

  def office_area_code=(arg)
    @office_telephone.area_code = arg 
  end
end

# さらに他のフィールドを移してtelephone_numberについてメソッドの移動を行う
class Person
  attr_reader :name

  def initialize
    @office_telephone = TelephoneNumber.new
  end

  def telephone_number
    @office_telephone.telephone_number
  end

  def office_telephone
    @office_telephone
  end
end

class TlephoneNumber
  attr_accessor :area_code, :number

  def telephone_number
    '(' + office_area_code + ')' + number
  end
end

# 一回移しきったあとに、クライアントに対してどの程度新クラスを公開するかを決める

