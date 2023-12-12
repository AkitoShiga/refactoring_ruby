# タイプコードに対して自己カプセル化フィールドを適用
# ポリモーフィックなオブジェクトの一つ一つのために空のクラスを作る
# タイプを表現する新しいインスタンス変数を作る => 委譲オブジェクト
# 古いタイプコードを使って、タイプインスタンス変数にどのタイプクラスを代入すべきかを決める
# ポリモーフィックな振る舞いが必要とされるメソッドの中から一つを選ぶ
# 新しいタイプクラスのどれかに同盟のメソッドを追加し、親オブジェクトからこのメソッドに処理を委譲する
# 委譲オブジェクトと共有しなければならない状態かもとのおbジェクトの参照を渡さなければならない

class MountainBike
  def initialize(params)
    set_state_from_hash params
  end

  def add_front_suspension(prams)
    @type_code = :front_suspension
    set_state_from_hash(params)
  end

  def add_rear_suspension(params)
    unless @type_code == :front_suspension
      raise "You can't add rear suspension unless you have front suspension"
    end
    @type_code = :full_suspension
    set_state_from_hash(params)
  end

  def off_road_ability
    result = @tire_witdh * TIRE_WIDTH_FACTOR

    if @type_code == :front_suspension || @type_code == :full_suspension
      result += @front_fork_travel * FRONT_SUSPENSION_FACTOR
    end

    if @type_code == :full_suspension
      result += @rear_fork_travel * REAR_SUSPENSION_FACTOR
    end

    result
  end

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

  private

  def set_state_frm_hash(hash)
    @base_price = hash[:base_price] if hash.has_key?(:base_price)
    if hash.has_key?(:front_suspension_price)
      @front_suspension_price = hash[:front_suspension_price]
    end
    if hash.has_key?(:rear_suspension_price)
      @base_price = hash[:rear_suspension_price]
    end
    if hash.has_key?(:commission)
      @commission = hash[:commission]
    end
    if hash.has_key?(:tire_width)
      @tire_width = hash[:tire_width]
    end
    if hash.has_key?(:rear_fork_travel)
      @rear_fork_travel = hash[:rear_fork_travel]
    end
    @type_code = hash[:type_code] if hash.has_key?(:type_code)  
  end
end

# 1. 自己カプセル化フィールドを適用

class MountainBike
  attr_reader :type_code

  def initialize(params)
    set_state_from_hash params
  end

  def type_code=(value)
    @type_code = value
  end

  def add_front_suspension(prams)
    self.type_code = :front_suspension
    set_state_from_hash(params)
  end
end

# 2. タイプコードごとに空クラスを作る
class RigidMountainBike
end

class FrontsupensionMountainBike
end

class FullSuspensionMountainBike
end

# 3. @type_codeではない新しいインスタンス変数を作る
class MountainBike

  def type_code=(value)
    @type_code = value
    # 呼び出し元を書き換えずに内部の実装を変更する市処理
    @bike_type = case type_code
    when :rigid:  RidgidMountainBike.new
    when :front_suspension: FrontsupensionMountainBike.new
    when :full_suspension: FullSuspensionMountainBike.new
  end
end

# 条件分岐に対してポリモーフィズムを使う
class RigidMountainBike
  def initialize(params)
    @tire_width = params[:tire_width]
  end

  def off_road_ability
    @tire_width * MountainBike::TIRE_WIDTH_FACTOR
  end
end

class FrontSuspensionMountainBike
end

class FullSuspensionMountainBike
end

class MountainBike

  def type_code=(value)
    @type_code = value
    # 呼び出し元を書き換えずに内部の実装を変更する市処理
    @bike_type = case type_code
      when :rigid:  RidgidMountainBike.new(:tire_width => @tire_width)
      when :front_suspension: FrontsupensionMountainBike.new
      when :full_suspension: FullSuspensionMountainBike.new
    end
  end

  def off_road_ability
    # ridgitのときだけ委譲
    return @bike_type.off_road_ability if type_code == rigid

    if @type_code == :front_suspension || @type_code == :full_suspension
      result += @front_fork_travel * FRONT_SUSPENSION_FACTOR
    end

    if @type_code == :full_suspension
      result += @rear_fork_travel * REAR_SUSPENSION_FACTOR
    end
    result
  end
end

# 他の新クラスでも行う

class FrontSuspensionMountainBike
  def initialize(params)
    @tire_width = params[:tire_width]
    @front_fork_travel = params[:front_fork_travel]
  end

  def off_road_ability
    @tire_width * MountainBike::TIRE_WIDTH_FACTOR + @front_fork_travel * MountainBike::FRONT_SUSPENSION_FACTOR
  end
end

class FullSuspensionMountainBike
  def initialize(paams)
    @tire_width = params[:tire_width] 
    @front_formk_travel = params[:front_fork_travel]  
    @rear_fork_travel = params[:rear_fork_travel] 
  end

  def off_road_ability
    @tire_width * MountainBike::TIRE_WIDTH_FACTOR + 
    @front_fork_travel * MountainBike::FRONT_SUSPENSION_FACTOR +
    @rear_fork_travel * MountainBike::REAR_SUSPENSION_FACTOR
  end
end

# 4.Forwardableを使ってマウンテンバイクのoff_road_abilityの処理をタイプクラスに委ねた
class MountainBike
  extend Forwardable
  def_delegators :@bike_type, :off_road_ability
  attr_reader :type_code
end

# 5. priceも移動
class RigidMountainBike
  def initialize(params)
    @tire_width = params[:tire_width]
  end

  def off_road_ability
    @tire_width * MountainBike::TIRE_WIDTH_FACTOR
  end

  def price
    (1 + @commission) * @base_price
  end
end


class FrontSuspensionMountainBike
  def initialize(params)
    @tire_width = params[:tire_width]
    @front_fork_travel = params[:front_fork_travel]
  end

  def off_road_ability
    @tire_width * MountainBike::TIRE_WIDTH_FACTOR + @front_fork_travel * MountainBike::FRONT_SUSPENSION_FACTOR
  end

  def price
    (1 + @commission) * @base_price + @front_suspension_price
  end
end

class FullSuspensionMountainBike
  def initialize(paams)
    @tire_width = params[:tire_width] 
    @front_formk_travel = params[:front_fork_travel]  
    @rear_fork_travel = params[:rear_fork_travel] 
  end

  def off_road_ability
    @tire_width * MountainBike::TIRE_WIDTH_FACTOR + 
    @front_fork_travel * MountainBike::FRONT_SUSPENSION_FACTOR +
    @rear_fork_travel * MountainBike::REAR_SUSPENSION_FACTOR
  end

  def price
    (1 + @commission) * @base_price + @front_suspension_price + @rear_suspension_price 
  end
end

# 6. type_codeを取り除く

class MountainBike

  def add_front_suspension(prams)
    @bike_type = FrontsupensionMountainBike.new(params)
  end

  def add_rear_suspension(params)
    @bike_type = FullsupensionMountainBike.new(params)
  end


  private

  def set_state_frm_hash(hash)
    @base_price = hash[:base_price] if hash.has_key?(:base_price)
    if hash.has_key?(:front_suspension_price)
      @front_suspension_price = hash[:front_suspension_price]
    end
    if hash.has_key?(:rear_suspension_price)
      @base_price = hash[:rear_suspension_price]
    end
    if hash.has_key?(:commission)
      @commission = hash[:commission]
    end
    if hash.has_key?(:tire_width)
      @tire_width = hash[:tire_width]
    end
    if hash.has_key?(:rear_fork_travel)
      @rear_fork_travel = hash[:rear_fork_travel]
    end
    @type_code = hash[:type_code] if hash.has_key?(:type_code)  
  end
end

# 7. initializeメソッドからcase文をとりのぞき、呼び出し元でDIする
