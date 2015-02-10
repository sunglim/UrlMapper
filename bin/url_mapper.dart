import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'dart:io';

void main() {
  final Map<String, String> _headers = {'Access-Control-Allow-Origin': '*',
                                        'Content-Type': 'text/html'};
  shelf.Response _options(shelf.Request request) => (request.method == 'OPTIONS') ?
      new shelf.Response.ok(null, headers: _headers) : null;
  
  shelf.Response _cors(shelf.Response response) => response.change(headers: _headers);

  shelf.Middleware _fixCORS = shelf.createMiddleware(
      requestHandler: _options, responseHandler: _cors);
  
  var handler = const shelf.Pipeline().addMiddleware(shelf.logRequests())
      .addMiddleware(_fixCORS)
    .addHandler(_echoRequest);

  io.serve(handler, 'localhost', 8088).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}

shelf.Response _echoRequest(shelf.Request request) {
  if (request.url.toString() == "/GetAll") {
    String json = "{'adidas': 'nike'}";
    return new shelf.Response.ok(json);
  }

  final String resultPath = request.url.toString() == '/' ? '/index.html' : request.url.toString();
        final File file = new File('./${resultPath}');
        if (file.existsSync()) {
          return new shelf.Response.ok(file.openRead());
        };
       
  return new shelf.Response.ok('Request for "${request.url}"');
}
