
=begin
# ビデオレンタルの料金を計算するプログラム

## 仕様

### 1.映画の種類と貸出日数で料金を決定する
#### 映画の種類
1. 一般
2. 新作
3. 子供向け

### 2. レンタルポイントを計算する
#### レンタルポイントの種類
1. 新作
2. 新作じゃない（一般・子供向け）
=end


class Movie
  REGULAR = 0
  NEW_RELEASE = 1
  CHIULDRENS = 2

  attr_reader :title
  attr_accessor :price_code

  def initialize(title, price_code)
    @title, @price_code = title, price_code
  end
end

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, rented)
    @movie, @days_rented = movie, days_rented
  end
end

class Customer
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = []
  end

  def add_rental(arg)
    @rentals << arg
  end

  # 料金とレンタルポイントを計算してレシートを作成する
  def statement

    total_amount, frequent_renter_points = 0, 0
    result = "Rental Record for #{@name}\n"

    @rentals.each do |element|
      this.amount = 0

      # 各行の金額を計算
      case element.movie.price_code
      when Movie::REGULAR
        this_amount += 2
        this_amount += (element.days_rented - 2) * 1.5 if element.days_rented > 2
      when Movie::NEW_RELEASE
        this_amount += element.days_rented * 3
      when Movie::CHILDRENS
        this_amount += 1.5
        this_amount += (element.days_rented - 3) * 1.5 if element.days_rented > 3
      end

      # レンタルポイントを加算
      frequent_renter_points += 1

      # 新作２日間レンタルでボーナスポイントを加算
      if element.movie.price_code == Movie.NEW_RELEASE && element.days_rented > 1
        frequent_renter_points += 1
      end

      # このレンタルの料金を表示
      result += "\t" + element.movie.title + "\t" + this_amount.to_s + "\n"
    end

    # フッター行を追加
    result += "Amount owed is #{total_amount}\n"
    result += "You earned #{frequent_renter_points} frequent renter points"
    result
  end
end

=begin
問題点
* HTMLで出力したくなったらどうする？
* 料金の計算方法が変わったらどうする？

感じたこと
* customerがレシートの作成を行っているのはおかしい
* 料金の計算をここで行っているのはおかしい
* レンタルポイントの計算をここで行っているのはおかしい
* ビジネスロジックとプレゼンテーションの処理を一つのメソッドの中で行っているのはおかしい

改善案
* 料金の計算を別クラスに切り出す
* レンタルポイントの計算を別クラスに切り出す
* レシートを印刷するクラスを作成する
* statementメソッドを別クラスに切り出す
* statementではレシートの作成のみを行う
=end

# Step 1 statementを分割する「メソッドの抽出」
class Customer
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = []
  end

  def add_rental(arg)
    @rentals << arg
  end

  # 料金とレンタルポイントを計算してレシートを作成する
  def statement

    total_amount, frequent_renter_points = 0, 0
    result = "Rental Record for #{@name}\n"

    @rentals.each do |element|
      this_amount = amount_for(element)
      # レンタルポイントを加算
      frequent_renter_points += 1

      # 新作２日間レンタルでボーナスポイントを加算
      if element.movie.price_code == Movie.NEW_RELEASE && element.days_rented > 1
        frequent_renter_points += 1
      end

      # このレンタルの料金を表示
      result += "\t" + element.movie.title + "\t" + this_amount.to_s + "\n"
    end

    # フッター行を追加
    result += "Amount owed is #{total_amount}\n"
    result += "You earned #{frequent_renter_points} frequent renter points"
    result
  end

  def amount_for(element)
    this_amount = 0
    # 各行の金額を計算
    case element.movie.price_code
    when Movie::REGULAR
      this_amount += 2
      this_amount += (element.days_rented - 2) * 1.5 if element.days_rented > 2
    when Movie::NEW_RELEASE
      this_amount += element.days_rented * 3
    when Movie::CHILDRENS
      this_amount += 1.5
      this_amount += (element.days_rented - 3) * 1.5 if element.days_rented > 3
    end
  end
end

# 変数名の変更
class Customer
  def amount_for(rental)
    result = 0
    # 各行の金額を計算
    case rental.movie.price_code
    when Movie::REGULAR
      result += 2
      result += (rental.days_rented - 2) * 1.5 if rental.days_rented > 2
    when Movie::NEW_RELEASE
      result += rental.days_rented * 3
    when Movie::CHILDRENS
      result += 1.5
      result += (result.days_rented - 3) * 1.5 if rental.days_rented > 3
    end
  end
end

# amount_forはCustomerの情報を使っていない

# Step 2 メソッドの移動
class Rental
  def charge
    result = 0
    # 各行の金額を計算
    case rental.movie.price_code
    when Movie::REGULAR
      result += 2
      result += (rental.days_rented - 2) * 1.5 if rental.days_rented > 2
    when Movie::NEW_RELEASE
      result += rental.days_rented * 3
    when Movie::CHILDRENS
      result += 1.5
      result += (result.days_rented - 3) * 1.5 if rental.days_rented > 3
    end
  end
end

# 呼び出しもとを変更する
class Customer
  def statement

    total_amount, frequent_renter_points = 0, 0
    result = "Rental Record for #{@name}\n"

    @rentals.each do |element|
      this_amount = element.charge
      # レンタルポイントを加算
      frequent_renter_points += 1

      # 新作２日間レンタルでボーナスポイントを加算
      if element.movie.price_code == Movie.NEW_RELEASE && element.days_rented > 1
        frequent_renter_points += 1
      end

      # このレンタルの料金を表示
      result += "\t" + element.movie.title + "\t" + this_amount.to_s + "\n"
    end

    # フッター行を追加
    result += "Amount owed is #{total_amount}\n"
    result += "You earned #{frequent_renter_points} frequent renter points"
    result
  end
end

# 一時変数の利用をやめる
class Customer
  def statement

    total_amount, frequent_renter_points = 0, 0
    result = "Rental Record for #{@name}\n"

    @rentals.each do |element|
      # レンタルポイントを加算
      frequent_renter_points += 1

      # 新作２日間レンタルでボーナスポイントを加算
      if element.movie.price_code == Movie.NEW_RELEASE && element.days_rented > 1
        frequent_renter_points += 1
      end

      # このレンタルの料金を表示
      result += "\t" + element.movie.title + "\t" + element.charge.to_s + "\n"
      total_amount += element.charge
    end

    # フッター行を追加
    result += "Amount owed is #{total_amount}\n"
    result += "You earned #{frequent_renter_points} frequent renter points"
    result
  end
end

# レンタルポイントの計算もメソッドに切り出す
class Customer
  def statement

    total_amount, frequent_renter_points = 0, 0
    result = "Rental Record for #{@name}\n"

    @rentals.each do |element|
      frequent_renter_points += element.frequent_renter_points

      # このレンタルの料金を表示
      result += "\t" + element.movie.title + "\t" + element.charge.to_s + "\n"
      total_amount += element.charge
    end

    # フッター行を追加
    result += "Amount owed is #{total_amount}\n"
    result += "You earned #{frequent_renter_points} frequent renter points"
    result
  end
end

class Rental
  # レンタルポイントを計算する
  def frequent_renter_points
  (element.movie.price_code == Movie.NEW_RELEASE && element.days_rented > 1)? 2 : 1
  end
end

# Step3 一時変数の削除
# 総額、を問い合わせるメソッドにしてしまう
class Customer
  def statement
    result = "Rental Record for #{@name}\n"

    @rentals.each do |element|
      # このレンタルの料金を表示
      result += "\t" + element.movie.title + "\t" + element.charge.to_s + "\n"
    end

    # フッター行を追加
    result += "Amount owed is #{total_charge}\n"
    result += "You earned #{frequent_renter_points} frequent renter points"
    result
  end

  private

  def total_charge
    @rentals.inject(0) { |sum, rental| sum + rental.charge }
  end

  def frequent_renter_points
    @rentals.inject(0) { |sum, rental| sum + rental.frequent_renter_points }
  end
end

# HTMLで出力したくなった
class Customer
  def html_statement
    result = "Rental Record for #{@name}\n"
    result = "<h1>Rentals for <em>#{@name}</em></h1><p>\n"

    @rentals.each do |element|
      # このレンタルの料金を表示
      result += "\t" + element.movie.title + "\t" + element.charge.to_s + "\n" + "<br>\n"
    end

    # フッター行を追加
    result += "<p>Amount owe <em>#{total_charge}</em></h1><p>\n"
    result += "On this rental you earned" +
    result += "<em>#{frequent_renter_points}</em> "
    result += "frequent renter points<p>"
    result
  end
end

# 料金計算をMovieクラスに移動する
# ビデオの種類の方が流動的なので、料金計算はMovieクラスに移動する
class Movie
  def charge(days_rented)
    result = 0
    # 各行の金額を計算
    case price_code
    when REGULAR
      result += 2
      result += (days_rented - 2) * 1.5 if days_rented > 2
    when NEW_RELEASE
      result += days_rented * 3
    when CHILDRENS
      result += 1.5
      result += (result.days_rented - 3) * 1.5 if days_rented > 3
    end
  end
end

class Rental
  def charge
    movie.charge(days_rented)
  end
end

# レンタルポイントの計算もMovieクラスに移動する
class Rental
  def frequent_renter_points
    movie.frequent_renter_points(days_rented)
  end
end

class Movie
  def frequent_renter_points(days_rented)
    (price_code == Movie.NEW_RELEASE && days_rented > 1)? 2 : 1
  end
end

# Step4 タイプコードからポリモーフィズムへ
class Movie
  # price_codeに自己カプセル化メソッドを適用して直接変数にアクセスしないようにする
  attr_reader :price_code

  # カスタムセッターにpriceの設定を移動する
  def price_code=(value)
    @price_code = value
    @price = case price_code
    when REGULAR then RegularPrice.new
    when NEW_RELEASE then NewReleasePrice.new
    when CHILDRENS then ChildrensPrice.new
  end

  def initialize(title, the_price_code)
    @title, self.price_code = title, the_price_code
  end
end

class RegularPrice
end

class NewReleasePrice
end

class ChildrensPrice
end

# 料金計算をポリモーフィズムにする
class Movie
  def charge(days_rented)
    @price.charge(days_rented)
  end
end

class RegularPrice
  def charge(days_rented)
    result = 2
    result += (days_rented - 2) * 1.5 if days_rented > 2
    result
  end
end

class NewReleasePrice
  def charge(days_rented)
    days_rented * 3
  end
end

class ChildrensPrice
  def charge(days_rented)
    result = 1.5
    result += (result.days_rented - 3) * 1.5 if days_rented > 3
    result
  end
end

# レンタルポイントの計算もポリモーフィズムにする
# 新作はメソッドを定義してそれ以外はモジュールをincludeする
# 評価軸は「新作かどうか」のため、子供向けと一般はレンタルポイントの観点では同じ扱いになる
class Movie
  def frequent_renter_points(days_rented)
    (price_code == Movie.NEW_RELEASE && days_rented > 1)? 2 : 1
  end
end

module DefaultPrice
  def frequent_renter_points(days_rented)
    1
  end
end

class RegularPrice
  include DefaultPrice
end

class NewReleasePrice
  def frequent_renter_points(days_rented)
    days_rented > 1 ? 2 : 1
  end
end

class ChildrenPrice
  incude DefaultPrice
end

class Movie
  def frequent_renter_points(days_rented)
    @price.frequent_renter_points(days_rented)
  end
end

# 呼び出し元にPriceのクラスを渡させるようにする
class Movie
  attr_writer :price
end

movie = Movie.new("Star Wars", RegularPrice.new)