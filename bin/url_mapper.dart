import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:dart-sqlite/sqlite.dart' as sqlite;

void main() {
  var handler = const shelf.Pipeline().addMiddleware(shelf.logRequests())
    .addHandler(_echoRequest);

  io.serve(handler, 'localhost', 8088).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}

shelf.Response _echoRequest(shelf.Request request) {
  var c = new sqlite.Database("/Users/limsungguk/program_store/trash/sqlite/ex1");
    sqlite.Row adidas = c.first("SELECT * FROM tbl1", (row) {
      var nike = row;
    });
  if (request.url.toString() == "/GetAll") {
    String json = "{'adidas': 'nike'}";
    return new shelf.Response.ok(json);
  }
  return new shelf.Response.ok('Request for "${request.url}"');
}
