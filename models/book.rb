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
    validates_max_length 35, :code
  end

  def info
    if self.booklet
      JSON.parse(self.booklet.douban_message)
    else
      {}
    end
  end
end
