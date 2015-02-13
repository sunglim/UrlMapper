import 'dart:async';
import 'dart:io';

import 'package:mime/mime.dart' as mime;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:url_mapper/json_generator.dart';
import 'package:url_mapper/controller.dart' as controller;

void main() {
  var handler = const shelf.Pipeline().addMiddleware(shelf.logRequests())
                                      .addHandler(_jsonRequest);

  io.serve(handler, '192.168.1.103', 8088).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}

Future<shelf.Response> _jsonRequest(shelf.Request request) {
  var query = request.url.path.toString();
  if (query == "/GetAll") {
    return JsonQuery().then((String json) {
      return new Future.value(new shelf.Response.ok(json));
    });
  } else if (query == "/Get") {
    var kind = request.url.queryParameters["kind"];
    if (kind == null)
      return new Future.value(new shelf.Response.ok("How to use: http://localhost:8088/Get?kind=[ua].  e.g. http://localhost:8088/Get?kind=SP_MAIL"));
    return JsonQueryWith(kind).then((String json) {
      return new Future.value(new shelf.Response.ok(json));
    });
  } else if (query == "/Set") {
    var site = request.url.queryParameters["site"];
    var kind = request.url.queryParameters["kind"];
    if (site != null && kind != null)
      return controller.InsertSite(site, kind).then((ret){
        return new Future.value(new shelf.Response.ok(ret.toString()));
      });
    return new Future.value(new shelf.Response.ok("missing param. http://localhost:8088/Set?site=msn.com&kind=SP_DIGI"));
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
    //final File file = new File('../front/web/${resultPath}');
    final File file = new File('../front/build/web/${resultPath}');
    if (file.existsSync()) {
      return new Future.value(new shelf.Response.ok(file.openRead(), headers: headers));
    };

    return new Future.value(new shelf.Response.ok('Not found "${request.url}"'));
  }
}
