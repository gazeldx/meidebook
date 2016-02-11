class Bookuser < Sequel::Model(:books_users)
  many_to_one :book
  many_to_one :user

  plugin :validation_helpers

  def validate
    super
    validates_unique([:book_id, :user_id])
  end
end
