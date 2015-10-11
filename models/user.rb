class User < Sequel::Model
  plugin :validation_helpers

  def validate
    validates_presence     :login_name
    validates_presence     :nickname
    validates_presence     :email
  end
end
