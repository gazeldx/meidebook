class User < Sequel::Model
  one_to_many :books
  one_to_many :posts

  plugin :validation_helpers

  def validate
    super
    validates_presence :username
    validates_unique :username
    validates_min_length 4, :username
    validates_max_length 35, :username
    validates_format /\A[a-z_0-9]+\z/, :username, message: I18n.t(:valid_combine_format)
    validates_format /\A[a-z_\-0-9]+\z/, :domain, message: I18n.t('user.domain_valid_format')
  end

  def self.valid_domain_chars
    [('a'..'z'), ('0'..'9')].map { |i| i.to_a }.flatten - ['0', '1', 'l', 'o']
  end

  def self.default_domain
    (0...7).map { self.valid_domain_chars[rand(self.valid_domain_chars.length)] }.join
  end

  def nickname_
    self.nickname || "#{self.username.slice(0)}****#{self.username.slice(-1)}"
  end
end
