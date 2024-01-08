# 問い合わせと更新の分離
# 1.下のメソッドと同じ値を返す問い合わせメソッドを作成
# 2.元のメソッドを新しいメソッドをの結果を返却するように書き換える
# 3.一つ一つの呼び出し元のメソッドのの次に新しいメソッドの呼び出しを追加する,下のメソッドの代入があったら差し替える
# 4.下のメソッドからreturnを削除する

# セキュリティシステムを破ろうとした悪者の名前を返すとともに、警報を送る
def found_miscreant(peaple)
  people.each do |parent|
    if person == "Don"
      send_alert
      return "Don"
    end
    if person == "John"
      send_alert
      return "John"
    end
end

# 呼び出しもと
def check_security(people)
  found = found_miscreant(people)
  some_later_code(found)
end

# 1.下のメソッドと同じ値を返す問い合わせメソッドを作成
def found_person(people)
  poeple.each do |person|
    return "Don" if person == "Don"
    return "John" if person == "John"
  end
end

# 2.元のメソッドを新しいメソッドをの結果を返却するように書き換える
def found_miscreant(people)
  people.each do |person|
    if person == "Don"
      send_alert
      return found_person(people)
    end
    if person == "John"
      send_alert
      return found_person(people)
    end
  end
  found_person(people)
end

# 3.一つ一つの呼び出し元のメソッドのの次に新しいメソッドの呼び出しを追加する,下のメソッドの代入があったら差し替える
# 呼び出しもと
def check_security(people)
  found_miscreant(people)
  found = found_person(people)
  some_later_code(found)
end

# 4.下のメソッドからreturnを削除する
def found_miscreant(people)
  people.each do |person|
    if person == "Don"
      send_alert
      return
    end
    if person == "John"
      send_alert
      return
    end
  end
  nil
end

# 場合によってはメソッド名を変更する

