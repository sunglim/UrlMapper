import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'dart:io';
import 'package:mime/mime.dart' as mime;

void main() {
  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
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

  var path = request.url.path;
  Map headers;
  var contentType = mime.lookupMimeType(path);
  if (contentType != null) {
    headers = <String, String>{
      "Content-Type": contentType
    };
  }

  final String resultPath =
    request.url.toString() == '/' ? '/index.html' : request.url.toString();
  final File file = new File('./web/${resultPath}');
  if (file.existsSync()) {
    return new shelf.Response.ok(file.openRead(), headers: headers);
  };
       
  return new shelf.Response.ok('Request for "${request.url}"');
}
