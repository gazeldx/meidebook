class User < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence :username
    validates_min_length 4, :username
    validates_max_length 35, :username
  end
end
