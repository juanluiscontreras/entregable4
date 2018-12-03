# entregable4
Se incluyen todos los archivos del proyecto pedido en la práctica entregable número 4

# Cómo usarlo
clonar el repositorio
```sh
$ git clone https://github.com/juanluiscontreras/entregable4.git
```
posicionarse en el mismo y ejecutar el servidor
```sh
$ cd entregable4
$ ruby entregable4.rb
```

luego mediante cUrl, probar los distintos comandos para los endpoints solicitados. El servidor se levanta por defecto en localhost:4567

Por ejemplo, algunas URLs para probar:
```sh
curl -sSL -D - http://localhost:4567/items.json
curl -v -sSL -D -d '' -X DELETE http://localhost:4567/cart/josele/1000.json
curl -sSL -D - -X PUT http://localhost:4567/cart/josele.json -H 'Content-Type: application/json' -d '{"id": 23, "amount": 4}'
```
