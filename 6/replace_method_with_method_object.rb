=begin
メソッドからメソッドオブジェクトへ
メソッドの抽出をできないようなローカル変数の使い方をしている長いメソッドに適用する
長いメソッドを分解して同じオブジェクトの別のメソッドにする

1. メソッドを独自のオブジェクトに変える
2. メソッドローカル変数と引数をインスタンス変数にする
3. 元々のクラスは新しいオブジェクトを参照して処理を移譲する
=end

# 長いメソッド
class Account
  def gamma(input_val, quantity, year_to_date)

    important_value1 = (input_val * quantity) + delta
    important_value2 = (input_val * year_to_date) + 100

    if(year_to_date - important_value2) > 100
      important_value2 -= 20
    end
    important_value3 = imporatant_value2 * 7
    important_value3 - 2 * important_value1
  end

  def gamma(input_val, quantity, year_to_date)

    important_value1 = (input_val * quantity) + delta
    important_value2 = (input_val * year_to_date) + 100

    if(year_to_date - important_value2) > 100
      important_value2 -= 20
    end

    important_value3 = imporatant_value2 * 7
    important_value3 - 2 * important_value1
  end
end

# 1. クラスを定義して、元のオブジェクトの引数、一時変数のための属性を宣言する
class Gamma
  ATTRIBUTES = %i[
    account
    input_val
    quantity
    year_to_date
    important_value1
    important_value2
    important_value3
  ]
  attr_reader *ATTRIBUTES
end

# 2. コンストラクタを定義する
class Gamma
  ATTRIBUTES = %i[
    account
    input_val
    quantity
    year_to_date
    important_value1
    important_value2
    important_value3
  ]
  attr_reader *ATTRIBUTES

  def initialize(account, input_val_arg, quantity_arg, year_to_date_arg)
    @account = account # Account
    @input_val = input_val_arg
    @quantity = quantity_arg
    @year_to_date = year_to_date_arg
  end
end


# 3. computeメソッドを定義
class Gamma
  def compute
    @important_value1 = (input_val * quantity) + @account.delta
    @important_value2 = (input_val * year_to_date) + 100

    if(year_to_date - important_value2) > 100
      @important_value2 -= 20
    end

    @important_value3 = imporatant_value2 * 7
    important_value3 - 2 * important_value1
  end
end

# 4. 元の呼び出し先は移譲させる
class Account
  def gamma(input_val, quantity, year_to_date)
    Gamma.new(self, input_val, quantity, year_to_date).compute
  end
end

# 5. Gammaは引数渡しの心配をせずメソッドの抽出を行うことができる
class Gamma
  def compute
    @important_value1 = (input_val * quantity) + @account.delta
    @important_value2 = (input_val * year_to_date) + 100

    important_thing

    @important_value3 = imporatant_value2 * 7
    important_value3 - 2 * important_value1
  end

  def important_thing
    if(year_to_date - important_value2) > 100
      @important_value2 -= 20
    end
  end
end