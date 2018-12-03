class Item
  attr_accessor :id, :sku, :description, :stock, :price

  def initialize (id, sku, description, stock, price)
    @id = id
    @sku = sku
    @description = description
    @stock = stock
    @price = price
  end


  def as_json(options={})
    {
    id: @id,
    sku: @sku,
    description: @description,
    stock: @stock,
    price: @price,
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

  def self.from_json(an_string)
    if self.valid_json?(an_string) then
        data = JSON.parse(an_string)
        is_valid_data = validate(data)
        #me llega algo como {"sku": "12345-WH-XS", "description": "Women hoodie - White - XS", "price": 23.48, "stock": 8}
        if (is_valid_data) then
          self.new(9, data['sku'], data['description'], data['price'], data['stock'])
        else 
          nil
        end
    else
      nil
    end
  end

  # def self.is?(date, expected_day = nil)
  #   expected_day = sanitize(expected_day || 5)
  #   date.wday == expected_day ?  'Si' : 'No'
  # end

  def self.validate(data)
    all_present = data.all?

  end

  def valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
end
end