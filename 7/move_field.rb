class Account
  def interest_for_amount_days(amount, days)
    @interest_rate * amount * days / 365
  end
end

# AccountTypeにinterest_rateを移動
class AccountType
  attr_accessor :interest_rate
end

# ソースオブジェクトはターゲットオブジェクトを利用する
class Account
  def interest_for_amount_days(amount, days)
    @account_type.interest_rate * amount * days / 365
  end
end

# 自己カプセル化フィールドを使う
class  Account
  # attr_accessor :interest_rate

  def interest_for_amount_days(amount, days)
    interest_rate * amount * days / 365
  end

  def interest_rate 
    @account_type.interest_rate
  end
  # delegateでもいい
end


