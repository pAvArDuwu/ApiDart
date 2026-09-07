A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).

This sample code handles HTTP GET requests to `/` and `/echo/<message>`

## Proceso de ventas

La migración `002_create_ventas.sql` normaliza el proceso en tres tablas:

- `productos` mantiene el catálogo y el stock disponible.
- `ventas` almacena la cabecera y relaciona cada operación con un `cliente`.
- `detalle_venta` relaciona productos con ventas y conserva la cantidad, el precio unitario y el subtotal aplicados en ese momento.

Para registrar una venta se usa `POST /api/ventas` con este cuerpo:

```json
{
	"cliente_id": 1,
	"detalles": [
		{"producto_id": 1, "cantidad": 2},
		{"producto_id": 3, "cantidad": 1}
	]
}
```

El servicio ejecuta toda la operación dentro de una transacción: valida el cliente, bloquea los productos, verifica stock, inserta la venta y sus detalles, descuenta existencias y confirma el total. Si un paso falla, se revierte la operación completa.

# Running the sample

## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart run bin/server.dart
Server listening on port 8080
```

And then from a second terminal:
```
$ curl http://0.0.0.0:8080
Hello, World!
$ curl http://0.0.0.0:8080/echo/I_love_Dart
I_love_Dart
```

## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```
$ docker build . -t myserver
$ docker run -it -p 8080:8080 myserver
Server listening on port 8080
```

And then from a second terminal:
```
$ curl http://0.0.0.0:8080
Hello, World!
$ curl http://0.0.0.0:8080/echo/I_love_Dart
I_love_Dart
```

You should see the logging printed in the first terminal:
```
2021-05-06T15:47:04.620417  0:00:00.000158 GET     [200] /
2021-05-06T15:47:08.392928  0:00:00.001216 GET     [200] /echo/I_love_Dart
```
