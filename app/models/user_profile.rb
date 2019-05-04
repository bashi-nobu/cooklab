class UserProfile < ApplicationRecord
  belongs_to :user, inverse_of: :userProfile, optional: true
  validates :birthday, date: true

  enum sex: { "未入力" => nil, "男性" => 0, "女性" => 1, "その他" => 2 }
  enum work_place: { "未入力 " => nil, "個店の飲食店" => 0, "ホテルの飲食店・レストラン" => 1, "ホテルのバンケット部門" => 2, "旅館" => 3, "ウエディング" => 4, "給食・社員食堂" => 5, "その他の調理施設" => 6, "料理教室" => 7, "料理学校(勤務)" => 8, "料理学校(学生)" => 9, "学生" => 10, "公務員" => 11, "会社員" => 12, "主婦" => 13, "その他 " => 14 }
  enum job: { "未入力  " => nil, "経営者" => 0, "管理職(料理長)" => 1, "管理職(店長)" => 2, "管理職(その他)" => 3, "調理スタッフ" => 4, "商品開発" => 5, "接客サービス" => 6, "バーテンダー" => 7, "営業職" => 8, "事務職" => 9, "その他職種" => 10 }
  enum specialized_field: { "未入力   " => nil, "和食" => 0, "懐石・会席" => 1, "寿司" => 2, "うなぎ・どじょう" => 3, "焼き鳥・鶏料理" => 4, "居酒屋" => 5, "バル" => 6, "フランス料理" => 7, "イタリア料理" => 8, "スペイン料理" => 9, "中華料理" => 10, "韓国料理" => 11, "焼肉店" => 12, "定食" => 13, "そば・うどん" => 14, "ラーメン" => 15, "カフェ" => 16, "スイーツ" => 17, "バー" => 18, "給食" => 19, "その他の分野" => 20 }
  enum location: { "未入力    " => nil, "北海道" => 0, "青森" => 1, "岩手" => 2, "秋田" => 3, "山形" => 4, "宮城" => 5, "福島" => 6, "茨城" => 7, "栃木" => 8, "群馬" => 9, "埼玉" => 10, "千葉" => 11, "神奈川" => 12, "東京(23区)" => 13, "東京(23区外)" => 14, "新潟" => 15, "富山" => 16, "石川" => 17, "福井" => 18, "山梨" => 19, "長野" => 20, "岐阜" => 21, "静岡" => 22, "愛知" => 23, "三重" => 24, "滋賀" => 25, "京都" => 26, "大阪" => 27, "兵庫" => 28, "奈良" => 29, "和歌山" => 30, "鳥取" => 31, "島根" => 32, "岡山" => 33, "広島" => 34, "山口" => 35, "徳島" => 36, "香川" => 37, "愛媛" => 38, "高知" => 39, "福岡" => 40, "佐賀" => 41, "長崎" => 42, "熊本" => 43, "大分" => 44, "宮崎" => 45, "鹿児島" => 46, "沖縄" => 47 }
end
