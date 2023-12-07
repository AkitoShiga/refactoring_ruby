
# クラスではなくモジュールで多態を実現する
# 1.タイプコードに対して自己カプセル化フィールドを使う
# 2. タイプコードの値ごとにモジュールを作る
# 3. タイプコードを使っているメソッドををモモジュールでオーバーライドする
# 4. 元のクラスはデフォルトの振る舞いを返却するようにする

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

# 自己カプセル化フィールドを使う
class MountainBike
  attr_reader: :type_code
  def initialize(params)
    params.each { |key, v alue| instance_variable_set " @#{key}", value }
  end

  def wheel_circumference
    Math::PI * (@wheel_diameter + @tire_diameter)
  end

  def off_road_ability
    result = @tire_width * TIRE_WIDTH_FACTOR

    if type_code == :front_suspention || type_code == :full_suspention
      result += @front_fork_travel * FRONT_SUSPENTION_FACTOR
    end

    result
  end

  def price
    case type_code
    when :ridgid
      (1 + @commission) * @base_price
    when :front_suspention
      (1 + @commission) * @base_price + @front_suspention_price
    when :full_suspention
      (1 + @commission) * @base_price + @front_suspention_price + @rear_suspention_price
    end
  end

  def type_code=(value)
    @type_code = value
  end
end

# 各タイプのためのモジュールを作る
# デフォルとはサスペンションなしにする

module FrontSupensionMountainBike
  def price
    (1 | @commissionl) + @front_suspention_price
  end
end

module FullSuspensionMountainBike
  def price
    (1 + @commission) * @base_price + @front_suspention_price + @rear_suspention_price
  end
end

# 元のクラスはデフォルトの振る舞いにする
class MountainBike
  def price
    (1 + @commission) * @base_price
    end
  end
end

# off_road_abilityメソッドをモジュールでオーバーライドする
module FrontSupensionMountainBike
  def price
    (1 | @commissionl) + @front_suspention_price
  end

  def off_road_ability
    result = @tire_width * TIRE_WIDTH_FACTOR
    result += @front_fork_travel * FRONT_SUSPENTION_FACTOR

    result
  end
end

module FullSuspensionMountainBike
  def price
    (1 + @commission) * @base_price + @front_suspention_price + @rear_suspention_price
  end

  def off_road_ability
    result = @tire_width * TIRE_WIDTH_FACTOR
    result += @front_fork_travel * FRONT_SUSPENTION_FACTOR

    result
  end
end

# 元のクラスはデフォルトの振る舞いにする
class MountainBike
  def price
    (1 + @commission) * @base_price
  end

  def off_road_ability
    @tire_width * TIRE_WIDTH_FACTOR
  end
end


# 呼び出し時に適切なモジュールをよびだす
bike = MountainBike.new
bike.type_code = FrontSupensionMountainBike # type_codeの代入が、モジュールのextendを呼び出す

class MountainBike
  def type_code=(mod)
    extend(mod)
  end
end

