class Book < Sequel::Model
  one_to_many :comments
  many_to_one :user
  one_to_many :bookusers
  many_to_one :booklet, key: :isbn

  plugin :validation_helpers

  def validate
    super
    validates_presence :code
    validates_unique :code
    validates_min_length 3, :code
    validates_max_length 35, :code
    # TODO: 图书编号应该允许汉字
    validates_format /\A[a-z\-_A-Z0-9]+\z/, :code, message: I18n.t('book.code_valid_combine_format')
  end

  def info
    if self.booklet
      JSON.parse(self.booklet.douban_message)
    else
      {}
    end
  end
end
