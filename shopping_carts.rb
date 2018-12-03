class Shopping_cart
  attr_accessor :username, :items, :date_creation

  def initialize (username, items, date_creation)
    @username = username
    @items = items
    @date_creation = date_creation
  end

end