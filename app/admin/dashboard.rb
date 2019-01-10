ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  all_user_count = User.all.count
  free_user_count = User.where(pay_regi_status: 0).count
  charge_user_count = User.where(pay_regi_status: 1).count
  premium_user_count = User.where(pay_regi_status: 2).count
  now = Date.current
  age = {}
  for num in 1..8 do
    from = now.ago(((num+1)*10).years)
    to = now.ago((num*10).years)
    age["#{(num*10).to_s}代"] = UserProfile.where(birthday:from...to).count
  end

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: 'custom-class' do
        h3 '会員データ'
        panel "" do
            table do
              thead do
                tr do
                  %w[ 総会員数 無料会員数 従量課金会員数 定期課金会員数 ].each &method(:th)
                end
              end
              tbody do
                tr do
                  [all_user_count, free_user_count, charge_user_count, premium_user_count].each &method(:td)
                end
              end
            end
            columns do
                pie_chart ({ "無料会員数": free_user_count, "従量課金会員数": charge_user_count, "定期課金会員数": premium_user_count })
            end
        end
        h3 '会員プロフィールデータ'
        columns do
            column do
                panel "性別" do
                    pie_chart UserProfile.group(:sex).count
                end
            end
            column do
                panel "職業" do
                    pie_chart UserProfile.group(:work_place).count
                end
            end
            column do
                panel "職種" do
                    pie_chart UserProfile.group(:job).count
                end
            end
        end
        columns do
            column do
                panel "専門ジャンル" do
                    pie_chart UserProfile.group(:specialized_field).count
                end
            end
            column do
                panel "都道府県" do
                    pie_chart UserProfile.group(:location).count
                end
            end
            column do
                panel "年齢層" do
                    pie_chart age
                end
            end
        end
    end
  end # content
end
