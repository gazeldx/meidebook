class User < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence :username
    validates_unique :username
    validates_min_length 4, :username
    validates_max_length 35, :username
    validates_format /\A[a-z_0-9]+\z/, :username, message: I18n.t(:valid_combine_format)
  end
end
