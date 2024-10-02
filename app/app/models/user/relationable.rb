# ユーザとn対nで紐づくモデルを操作する機能を拡張するモジュール
#
# @note
#   リレーションのモデルはユーザを他のモデルとN:Nで関連づけること
#   リレーションのモデルはuser_idを持っていること
#
# 例
#   class Like
#     belongs_to :user
#     belongs_to :post
#   end
#
#   class User
#     include User::Relationable
#     has_many :likes # Likeモデルのリレーション
#     has_many_resource :likes
#   end
#
#   上記のように宣言した場合下記のメソッドが使えるようになる
#
#   - 引数のモデルに対してリレーションのレコードが存在するか
#   user.like?(post)
#   - 引数のモデルに対してリレーションのレコードが存在しない場合レコードを作成する
#   user.like(post)
#   - 引数のモデルに対してリレーションのレコードが存在する場合レコードを削除する
#   user.unlike(post)
#
module User::Relationable
  extend ActiveSupport::Concern

  class_methods do
    def has_many_resource(has_many_attr)
      related_klass = self.reflect_on_all_associations(:has_many).find { _1.name == has_many_attr }.klass
      item_attr = related_klass.reflect_on_all_associations(:belongs_to).map(&:name).find { _1 != :user }

      model_name = has_many_attr.to_s.singularize
      predicator_name = "#{model_name}?".to_sym

      define_method predicator_name, ->(a) { send(has_many_attr).pluck("#{item_attr}_id").include?(a.id) }
      define_method model_name, lambda { |a|
        return false if send(predicator_name, a)

        created = send(has_many_attr).create("#{item_attr}": a)
        created.valid?
      }
      define_method "un#{model_name}", lambda { |a|
        return false unless send(predicator_name, a)

        deleted = send(has_many_attr).find_by("#{item_attr}": a).delete
        deleted.destroyed?
      }
    end
  end
end
