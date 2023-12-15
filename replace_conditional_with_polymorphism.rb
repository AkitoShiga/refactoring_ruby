# 条件分岐からポリモーフィズムへ
# オブジェクトのタイプによって振る舞いを変える条件文がある
# 条件文の分岐先をポリモーフィックに呼び出せるオブジェクトのメソッドに移す

# クライアント
ridged_bike = RigidMountainBike.new(
  type_code: :ridid,
  base_price: 300,
  commision: 0.1
)
total += rigid_bike.price

front_suspension_bike = FrontSuspensionMountainBike.new(
  type_code: :front_suspension,
  base_price: 500,
  commission: 0.1
)
total += front_suspension_bike.price

module MountainBike
  def price
    case @type_code
    when :rigid
      (1 + @commission) * @base_price 
    when :front_suspension
      (1 + @commission) * @base_price + @front_suspension_price
    when :full_suspension 
      (1 + @commission) * @base_price + @front_suspension_price + @rear_suspension_price
    end
  end
end

class RigidMountainBike
  include MountainBike
end

class FrontSuspensionMountainBike
  include MountainBike
end

class FullSuspensionMountainBike
  include MountainBike
end


# 移動させる
class RigidMountainBike
  include MountainBike
  def price
    (1 + @commission) * @base_price 
  end
end

module MountainBike
  def price
    case @type_code
    when :rigid
      raise 
    when :front_suspension
      (1 + @commission) * @base_price + @front_suspension_price
    when :full_suspension 
      (1 + @commission) * @base_price + @front_suspension_price + @rear_suspension_price
    end
  end
end

