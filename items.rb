class Item
  attr_accessor :id, :sku, :description, :stock, :price
  
  def initialize (id, sku, description, stock, price)
    @id = id
    @sku = sku
    @description = description
    @price = price
    @stock = stock
  end


  def as_json(options={})
    {
    id: @id,
    sku: @sku,
    description: @description,
    price: @price,
    stock: @stock,
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

  def self.from_json(an_string)
  
        data = JSON.parse(an_string)
        #valido datos
        is_valid_data = (data['sku'].is_a? String) && (data['description'].is_a? String) && (data['price'].is_a? Float) && (data['stock'].is_a? Integer)
        #me llega algo como {"sku": "12345-WH-XS", "description": "Women hoodie - White - XS", "price": 23.48, "stock": 8}
        if (is_valid_data) then
          r = Random.new
          id = r.rand(10...42) 
          self.new(id, data['sku'], data['description'], data['price'], data['stock'])
        else 
          nil
        end
  rescue JSON::ParserError
    nil
  end

  def update!(an_string)  
        data = JSON.parse(an_string)
        is_valid_data = (data['sku'].is_a? String) || (data['description'].is_a? String) || (data['price'].is_a? Float) || (data['stock'].is_a? Integer)
        #me llega algo como {"sku": "12345-WH-XS", "description": "Women hoodie - White - XS", "price": 23.48, "stock": 8}
        if (is_valid_data) then
          self.sku = data['sku'] unless data['sku'].nil?
          self.description = data['description'] unless data['description'].nil?
          self.price = data['price'] unless data['price'].nil?
          self.stock = data['stock'] unless data['stock'].nil?
          self
        else 
          nil
        end
  rescue JSON::ParserError
    nil
  end

end