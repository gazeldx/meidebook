class Book < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence :code
    validates_unique :code
    validates_min_length 5, :code
    validates_max_length 35, :code
    validates_format /\A[a-z\-_0-9]+\z/, :code, message: I18n.t('book.code_valid_combine_format')
  end
end
