
require 'sinatra'
require 'json'
require_relative 'items.rb'
require_relative 'shopping_carts.rb'
require 'date'

configure do
  set :an_item, Item.new(1, '12345-WH-XS', 'Women hoodie - White - XS', 32, 143)
  one_item = Item.new(2, '3453-MS-ER', 'men shirt - black - S', 50, 100)
  second_item = Item.new(3, '8877-WP-XS', 'Women pants - White - XS', 45, 98)
  third_item = Item.new(4, '554432-MB-XS', 'Men Blazer- Blue - XL', 32, 23)
  an_array = []
  an_array << one_item
  an_array << second_item
  an_array << third_item
  set :an_array_of_items, an_array
  an_array_of_shopping_carts = []
  set :shopping_carts, an_array_of_shopping_carts
 end

before do
    content_type :json
end


#Obtención de un listado de ítems
get '/items.json' do
	status 200
	settings.an_array_of_items.to_json
end

#Obtención de un item
get '/items/*.*' do
	an_array = params['splat'] # => ["path/to/file", "xml"]
	searched_id = an_array[0]
	if an_array[1] == 'json' then
		item_result = settings.an_array_of_items.select{ |item| item.id == searched_id }
	    status 200
	    item_result.to_json
	else
		status 404
	end
end

 #Creación de un ítem
 post '/items.json' do
    item = Item.from_json(request.body.read)
    if item.nil? then
    	status 422
    else
		status 201
	    item.to_json
	end
 end

 #actualiza un item existente
put '/items/*.*' do
	an_array = params['splat'] # => ["path/to/file", "xml"]
	searched_id = an_array[0]
	if an_array[1] == 'json' then
		item_result = settings.an_array_of_items.select{ |item| item.id == searched_id }
		updated_item = item_result.update!(request.body.read)
	    status 200
	    updated_item.to_json
	else
		status 404
	end
end

#Obtención de un carrito de compras de un usuario
get '/cart/*.*' do
	an_array = params['splat'] # => ["path/to/file", "xml"]
	searched_user = an_array[0]
	if an_array[1] == 'json' && (searched_user.is_a? String) then
		cart_result = settings.shopping_carts.select{ |cart| cart['username'] == searched_user }
		if cart_result.empty? then
			#inicializo carro vacio
			a_cart = Shopping_cart.new(searched_user, [], Date.today )
			settings.shopping_carts << a_cart
		    new_shopping_cart_data = { :username => "#{searched_user}", :total_amount => 0, :date_of_creation => "#{Date.today}" }
		    status 200
		    new_shopping_cart_data.to_json
		else
			#recorro items del carro
			array_of_items_of_user = cart_result['items']
			total = array_of_items_of_user.inject(0){ |sum, temp| sum + temp.price }
		    shopping_cart_data = { :username => "#{searched_user}", :total_amount => "#{total}", :date_of_creation => "#{cart_result.date_of_creation}" }
		    status 200
		    shopping_cart_data.to_json
		end    
	else
		status 400
	end
end

 #Agregar un item al carrito de compras
 #$ curl -sSL -D - -X PUT http://localhost:4567/items.json -H 'Content-Type: application/json' -d '{"username": "jose pepe", "id": 23, "amount": 4}'
put '/cart/*.*' do
	an_array = params['splat'] # => ["path/to/file", "xml"]
	searched_user = an_array[0]
	if an_array[1] == 'json' && (searched_user.is_a? String) then
		cart_result = settings.shopping_carts.select{ |cart| cart['username'] == searched_user }
		if cart_result.empty? then
			#inicializo carro vacio
			a_cart = Shopping_cart.new(searched_user, [], Date.today )
		else
			a_cart = cart_result[0]
		end
	    #datos del item a agregar
	    parsed_json = JSON.parse(request.body.read)		    
	    item_result = settings.an_array_of_items.select{ |item| item.id == parsed_json['id'] }
	    if not item_result.empty? then
	    	for i in 1..parsed_json['cant'] do
	    		a_cart.items << item_result[0]
	    	end
		end
		settings.shopping_carts << a_cart
	    status 200
		
	else
		status 400
	end
 end

#Borrar un item del carrito de compras
 delete '/cart/*/*.*' do
	an_array = params['splat'] # => ["path/to/file", "xml"]
	searched_user = an_array[0]
	searched_id = an_array[1]
	if an_array[2] == 'json' && (searched_user.is_a? String) then
		cart_result = settings.shopping_carts.select{ |cart| cart['username'] == searched_user }
		if cart_result.empty? then
			#inicializo carro vacio
			a_cart = Shopping_cart.new(searched_user, [], Date.today )
			status 200
		else
			a_cart = cart_result[0]
		    #datos del item a borrar	    
		    item_result = a_cart['items'].select{ |item| item.id == searched_id }
			a_cart['items'].delete(item_result[0])
			settings.shopping_carts << a_cart
		    status 200
		end		
	else
		status 400
	end
 end


puts "Server iniciado, con un item de prueba"