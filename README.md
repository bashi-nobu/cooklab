# README

## アプリケーション概要

**3分動画でレベルアップ！プロの料理人向け技術研鑽の動画サイト**

各分野の一流の料理人が実践する各種調理工程における基礎技術を動画を通じて学習できるサイト。
飲食店/レストランで働く料理人をターゲットとしており、ユーザーは無料会員登録することで動画を視聴することができる。
また有料会員(月額負担)になることで有料会員限定の動画の視聴・全動画のレシピ閲覧・お気に入り機能(登録数に制限なし)といったサービスを利用することもできる。

<主な機能>
- お気に入り機能
各動画に対してユーザーはお気に入り登録ができ、マイページで自分のお気に入り動画を一覧で確認することができる。

- レコメンド機能
自ユーザーおよび他ユーザーのお気に入り登録履歴をもとに動画閲覧画面にてレコメンド動画を紹介する。

- タグ付け機能
管理者は各動画の投稿時にはタグ付けを行うことでタグに基づいた動画検索を行うことができる。

- 動画検索機能
料理人・ジャンル(タグ)・キーワード 軸で動画の検索を行うことができる。

- 記事検索機能
ジャンル・キーワード 軸で記事の検索を行うことができる。

- 動画管理機能/記事管理機能
動画&記事の投稿/編集/削除ができる ※動画は直接アップロードするのではなくvimeoに投稿した動画のurlを登録する。

- クレジット支払機能
Pay.jpとの連携によるクレジットカードによる定期課金。

- 管理画面(管理者専用)
gem"active-admin"を利用。この画面から動画・記事の投稿,編集を行う。



## ページ構成

[Top page](https://gyazo.com/bec5520def32bb1cc4bbf1e78f829317)

[My page](https://gyazo.com/8360a8a71e4e378bc9a7a57935bc2905)

[Video page](https://gyazo.com/ec5c48a6fb11a371ce5806509bb67dfc)

[Video search page](https://gyazo.com/831bb1c8a225beb27a0d4290f97e22bb)

[Article page](https://gyazo.com/95ca3f3172845e05d8e51bdca1033814)

[Article search page](https://gyazo.com/a8f6dcb0c5a485662f7ffb841adb7479)

[Account create page](https://gyazo.com/27ffb32797673c83b464810c90d04175)

[Premium account create page](https://gyazo.com/c7dfa65896fb4774abb91b72c020e3b2)



## アプリケーション要件

- usersテーブル(deviseにより生成)
各userは、deviseによるサインイン情報(email、password等)の他に、ユーザ名やプロフィールを設定できる。

- user_profilesテーブル
登録ユーザーのプロフィール情報を保存する。

- seriesesテーブル
テーマの情報(タイトル・解説・サムネイル画像など)を保存する。１つのシリーズに対して複数の動画が所属する(videosテーブル)。

- videosテーブル
動画を保存する。各動画はあるテーマに所属する。
※video_orderカラムにあるテーマ内での動画の再生順番を登録する。
※priceカラムの値が0以上の場合は有料動画。

- chefsテーブル
料理人情報(氏名/略歴など)を保存する。

- video_likesテーブル
各ユーザーの各動画に対するお気に入り登録情報を保存する中間テーブル。

- tagsテーブル
動画の投稿者はその動画にタグをつけることができる。そのタグに基づいてユーザーは動画の検索(ジャンル検索)を行うことができる。
tag_videosテーブルを中間テーブルとしてvideosテーブルとは多対多の関係。

- recipesテーブル
具材・文量を保存する。あるテーマに所属する。

- article_likesテーブル
各ユーザーの各記事に対するお気に入り登録情報を保存する中間テーブル。

- articlesテーブル
投稿された記事の情報(タイトル・文章・サムネイル画像など)を保存するテーブル。
※premiunカラムの値が"true"の場合は有料会員限定記事。

- article_tagsテーブル
記事の投稿者はその記事にタグをつけることができる。そのタグに基づいてユーザーは記事の検索(ジャンル検索)を行うことができる。
tag_articlesテーブルを中間テーブルとしてarticlesテーブルとは多対多の関係。

- noticesテーブル
サイト側からユーザーにお知らせする情報(メンテナンスなどでの利用不可時間の通知など)を保存するテーブル。
保存された情報はユーザーのマイページに表示させる。

- subscriptionテーブル
定期課金に対するユーザーのクレジットカード情報(クレジットカード情報登録時にPay.jpで作成されるcustomer_idなど)を保存するテーブル

- chargesテーブル
クレジットカードでの支払い済み情報を保存するテーブル(user/videoの中間テーブル)。
※支払い時の金額も保存


## DB設計

[ER図](https://gyazo.com/3efcc6ebc726707f87a49c64cf018371)



ユーザー管理
## usersテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|email|string|null: false, unique: true|
|password|string|null: false|
|confirmation_token|string|
|confirmed_at|datetime|
|confirmation_sent_at|datetime|
|unconfirmed_email|string|
|pay_regi_status|integer|
|provider|string|
|uid|string|
|sign_in_count|integer|default: 0, null: false|
|current_sign_in_at|datetime|
|last_sign_in_at|datetime|
|current_sign_in_ip|string|
|last_sign_in_ip|string|



### Association
- has_one :subscriptions
- has_one :user_profiles
- has_many :charges
- has_many :videos, through: :video_likes
- has_many :articles, through: :article_likes
- has_many :videos, through: :charges

## user_profilesテーブル

|Column|Type|Options|
|------|----|-------|
|user_id|references|null: false, foreign_key: true|
|sex|integer|null: false|
|work_place|integer|null: false|
|job|integer|null: false|
|specialized_field|integer|null: false|
|location|integer|null: false|
|birthday|date|null: false|

### Association
- belongs_to :user


動画管理

## Seriesesテーブル

|Column|Type|Options|
|------|----|-------|
|title|string|null: false|
|introduction|string|
|thumbnail|string|
|price|integer|default: 0|
|chef_id|references|null: false, foreign_key: true|


### Association
- has_many :videos
- belongs_to :chef


## video_likesテーブル

|Column|Type|Options|
|------|----|-------|
|video_id|references|null: false, index: true, foreign_key: true|
|user_id|references|null: false, index: true, foreign_key: true|

### Association
- belongs_to :series
- belongs_to :user


## chefsテーブル

|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|phonetic|string|null: false|
|introduction|string|null: false|
|biography|text|null: false|
|chef_avatar|string|null: false|

### Association
- has_many :serieses


## tag_videosテーブル

|Column|Type|Options|
|------|----|-------|
|video_id|references|null: false, index: true, foreign_key: true|
|tag_id|references|null: false, index: true, foreign_key: true|

### Association
- belongs_to :video
- belongs_to :tag


## tagsテーブル

|Column|Type|Options|
|------|----|-------|
|title|string|null: false|


### Association
- has_many :videos, through: :tag_videos


## recipesテーブル

|Column|Type|Options|
|------|----|-------|
|food|string|null: false|
|amount|string|null: false|
|video_id|references|null: false, foreign_key: true|

### Association
- belongs_to :videos


## videosテーブル

|Column|Type|Options|
|------|----|-------|
|title|string|null: false|
|video_url|string|null: false|
|introduction|string|null: false|
|commentary|string|null: false|
|video_order|integer|null: false|
|like_count|integer|default: 0|
|price|integer|default: 0|
|series_id|references|null: false, foreign_key: true|

### Association
- belongs_to :series
- has_many :users, through: :video_likes
- has_many :recipes
- has_many :tags, through: :tag_videos
- has_many :users, through: :charges

記事管理

## article_likesテーブル

|Column|Type|Options|
|------|----|-------|
|article_id|references|null: false, index: true, foreign_key: true|
|user_id|references|null: false, index: true, foreign_key: true|

### Association
- belongs_to :article
- belongs_to :user


## articlesテーブル

|Column|Type|Options|
|------|----|-------|
|title|string|null: false|
|content|text|null: false|
|thumbnail|string|null: false|
|like_count|integer|
|premium|boolean|null: false|

### Association
- has_many :recipes
- has_many :videos
- belongs_to :chef
- has_many :article_tags, through: :tag_articles
- has_many :users, through: :article_likes


## tag_articleテーブル

|Column|Type|Options|
|------|----|-------|
|article_id|references|null: false, index: true, foreign_key: true|
|article_tag_id|references|null: false, index: true, foreign_key: true|

### Association
- belongs_to :article
- belongs_to :article_tag


## article_tagsテーブル

|Column|Type|Options|
|------|----|-------|
|title|string|null: false|


お知らせ機能

## noticesテーブル

|Column|Type|Options|
|------|----|-------|
|title|string|null: false|
|message|text|null: false|
|end_date|date|null: false|

### Association


クレジット管理機能
## Paymentsテーブル

|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, index: true, foreign_key: true|
|customer_id|string|null: false|
|subscription_id|string|null: false|
|plan|string|
|expires_at|datetime|
|created_at|datetime|
|updated_at|datetime|

### Association
- has_one :user


## chargesテーブル

|Column|Type|Options|
|------|----|-------|
|user_id|references|null: false, index: true, foreign_key: true|
|video_id|references|null: false, index: true, foreign_key: true|
|price|integer|
|created_at|datetime|

### Association
- belongs_to :user
- belongs_to :video

