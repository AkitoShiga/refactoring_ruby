# 1.タイプコードを使っているクラスをモジュールに変える
# 2.新しいタイプクラスにモジュールをincludeする
# 3.ファクトリを作る
# 4.タイプコードを使っているメソッドをオーバーライドする

# イケてないコードをモジュールにする
# インクルードさせた元のクラスでオーバーライドする
# 大乗j部そうだったらモジュールのメソッドを消す
# モジュールになにも残らなくなったらモジュール自体消す

class MountainBike
  def initialize(params)
    params.each { |key, v alue| instance_variable_set " @#{key}", value }
  end

  def wheel_circumference
    Math::PI * (@wheel_diameter + @tire_diameter)
  end

  def off_road_ability
    result = @tire_width * TIRE_WIDTH_FACTOR

    if @type_code == :front_suspention || @type_code == :full_suspention
      result += @front_fork_travel * FRONT_SUSPENTION_FACTOR
    end

    result
  end

  def price
    case @type_code
    when :ridgid
      (1 + @commission) * @base_price
    when :front_suspention
      (1 + @commission) * @base_price + @front_suspention_price
    when :full_suspention
      (1 + @commission) * @base_price + @front_suspention_price + @rear_suspention_price
    end
  end
end

# 使用例
bike = MountainBike.new(type_code: :ridgid, tire_width: 2.5)
bike2 = MountainBike.new(type_code: :front_suspention, tire_width: 2)

# モジュールにする
module MountainBike
  def initialize(params)
    params.each { |key, v alue| instance_variable_set " @#{key}", value }
  end

  def wheel_circumference
    Math::PI * (@wheel_diameter + @tire_diameter)
  end

  def off_road_ability
    result = @tire_width * TIRE_WIDTH_FACTOR

    if @type_code == :front_suspention || @type_code == :full_suspention
      result += @front_fork_travel * FRONT_SUSPENTION_FACTOR
    end

    result
  end

  def price
    case @type_code
    when :ridgid
      (1 + @commission) * @base_price
    when :front_suspention
      (1 + @commission) * @base_price + @front_suspention_price
    when :full_suspention
      (1 + @commission) * @base_price + @front_suspention_price + @rear_suspention_price
    end
  end
end

# タイプごとにクラスを作る
class RigidMountainBike
  include MountainBike
end

class FrontSupensionMountainBike
  include MountainBike
end

class FullSuspensionMountainBike
  include MountainBike
end

# 呼び出し元を変更する
bike = FrontSuspentionMountainBike.new(
  type_code: :front_suspention,
  tire_width: 2,
  front_fork_travel: 3
)

# 条件分岐のメソッドをオーバーライドする
class RigidMountainBike
  include MountainBike

  def price
    (1 + @commission) * @base_price
  end
end

# モジュールのメソッドを変更する
module MountainBike
  def initialize(params)
    params.each { |key, v alue| instance_variable_set " @#{key}", value }
  end

  def wheel_circumference
    Math::PI * (@wheel_diameter + @tire_diameter)
  end

  def off_road_ability
    result = @tire_width * TIRE_WIDTH_FACTOR

    if @type_code == :front_suspention || @type_code == :full_suspention
      result += @front_fork_travel * FRONT_SUSPENTION_FACTOR
    end

    result
  end

  def price
    case @type_code
    when :ridgid
      raise "shouldn't get here"
    when :front_suspention
      (1 + @commission) * @base_price + @front_suspention_price
    when :full_suspention
      (1 + @commission) * @base_price + @front_suspention_price + @rear_suspention_price
    end
  end
end

# 全部書き換える
class FrontSupensionMountainBike
  include MountainBike
  def price
    (1 + @commission) * @base_price + @front_suspention_price
  end
end

class FullSuspensionMountainBike
  include MountainBike
  def price
    (1 + @commission) * @base_price + @front_suspention_price + @rear_suspention_price
  end
end


# メソッドを消す
module MountainBike
  def initialize(params)
    params.each { |key, v alue| instance_variable_set " @#{key}", value }
  end

  def wheel_circumference
    Math::PI * (@wheel_diameter + @tire_diameter)
  end

  def off_road_ability
    result = @tire_width * TIRE_WIDTH_FACTOR

    if @type_code == :front_suspention || @type_code == :full_suspention
      result += @front_fork_travel * FRONT_SUSPENTION_FACTOR
    end

    result
  end

  # def price
  #   case @type_code
  #   when :ridgid
  #     (1 + @commission) * @base_price
  #   when :front_suspention
  #     (1 + @commission) * @base_price + @front_suspention_price
  #   when :full_suspention
  #     (1 + @commission) * @base_price + @front_suspention_price + @rear_suspention_price
  #   end
  # end
end

# offroad_abilityも同様に行う
class RigidMountainBike
  include MountainBike

  def price
    (1 + @commission) * @base_price
  end

  def off_road_ability
    result = @tire_width * TIRE_WIDTH_FACTOR

    result
  end
end

class FrontSupensionMountainBike
  include MountainBike
  def price
    (1 + @commission) * @base_price + @front_suspention_price
  end

  def off_road_ability
    result = @tire_width * TIRE_WIDTH_FACTOR
    result += @front_fork_travel * FRONT_SUSPENTION_FACTOR

    result
  end
end

class FullSuspensionMountainBike
  include MountainBike
  def price
    (1 + @commission) * @base_price + @front_suspention_price + @rear_suspention_price
  end
end

  def off_road_ability
    result = @tire_width * TIRE_WIDTH_FACTOR
    result += @front_fork_travel * FRONT_SUSPENTION_FACTOR

    result
  end

  # タイプコードをとりのぞく
module MountainBike
  def initialize(params)
    params.each { |key, v alue| instance_variable_set " @#{key}", value }
  end

  def wheel_circumference
    Math::PI * (@wheel_diameter + @tire_diameter)
  end
end
