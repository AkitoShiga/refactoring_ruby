=begin
メソッドの抽出
コードの断片をmethodとして抽出する
=end

def print_owing(amount)
  print_banner
  puts "name : #{@name}"
  puts "amount : #{amount}"
end

# 以下のように抽出する

def print_owing(amount)
  print_banner
  print_details amount
end

def print_details(amount)
  puts "name : #{@name}"
  puts "amount : #{amount}"
end
