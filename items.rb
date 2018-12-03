class Item
  attr_accessor :id, :sku, :description, :stock, :price
  @id=12

  @json_schema = "{ 'sku': 'string', 'description': 'string', 'price': 'number', 'stock': 'number'}"

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
    if self.valid_json?(an_string) then
        data = JSON.parse(an_string)
        #valido datos
        is_valid_data = (data['sku'].is_a? String) && (data['description'].is_a? String) && (data['price'].is_a? Float) && (data['stock'].is_a? Integer)
        #me llega algo como {"sku": "12345-WH-XS", "description": "Women hoodie - White - XS", "price": 23.48, "stock": 8}
        if (is_valid_data) then
          id++
          self.new(id, data['sku'], data['description'], data['price'], data['stock'])
        else 
          nil
        end
    else
      nil
    end
  end

  def update!(an_string)
    if self.valid_json?(an_string) then
        data = JSON.parse(an_string)
        is_valid_data = (data['sku'].is_a? String) || (data['description'].is_a? String) || (data['price'].is_a? Float) || (data['stock'].is_a? Integer)
        #me llega algo como {"sku": "12345-WH-XS", "description": "Women hoodie - White - XS", "price": 23.48, "stock": 8}
        if (is_valid_data) then
          self.sku = data['sku'] unless data['sku'].nil?
          self.description = data['description'] unless data['description'].nil?
          self.price = data['price'] unless data['price'].nil?
          self
        else 
          nil
        end
    else
      nil
    end
  end

  def self.validate(data)
    data.each do |key,value| 
        if array_of_measu[2] != "NaN" && array_of_measu[2] != "-"
          prec_of_the_day << array_of_measu[2].to_f 
        end
      end
  end 

  def valid_json?(data)
    #JSON.parse(json)
    return JSON::Validator.validate(schema, data)
  rescue JSON::ParserError => e
    return false
end
end