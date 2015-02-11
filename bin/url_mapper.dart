import 'dart:async';
import 'dart:io';

import 'package:mime/mime.dart' as mime;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:url_mapper/json_generator.dart';

void main() {
  var handler = const shelf.Pipeline().addMiddleware(shelf.logRequests())
                                      .addHandler(_jsonRequest);

  io.serve(handler, 'localhost', 8088).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}

Future<shelf.Response> _jsonRequest(shelf.Request request) {
  if (request.url.toString() == "/GetAll") {
    return JsonQuery().then((String json) {
      return new Future.value(new shelf.Response.ok(json));
    });
  } else {
    Map headers;
    var contentType = mime.lookupMimeType(request.url.path);
    if (contentType != null) {
      headers = <String, String>{
        "Content-Type": contentType
      };
    }

    final String resultPath =
      request.url.toString() == '/' ? '/index.html' : request.url.toString();
    final File file = new File('./web/${resultPath}');
    if (file.existsSync()) {
      return new Future.value(new shelf.Response.ok(file.openRead(), headers: headers));
    };

    return new Future.value(shelf.Response.ok('Not found "${request.url}"'));
  }
}
