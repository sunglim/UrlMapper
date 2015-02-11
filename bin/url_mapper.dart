import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'dart:io';
import 'package:mime/mime.dart' as mime;
import 'package:url_mapper/database.dart' as Database;
import 'package:url_mapper/json_generator.dart';
import 'dart:async';

void main() {
  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(_jsonRequest);

  io.serve(handler, 'localhost', 8088).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}

Future<shelf.Response> _jsonRequest(shelf.Request request) {
  if (request.url.toString() == "/GetAll") {
    /*return Database.Test().then((List results) {
      return new Future.value(new shelf.Response.ok(results.toString()));
    });*/
    return JsonQuery().then((String json) {
      return new Future.value(new shelf.Response.ok(json));
    });
  } else {
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
      return new Future.value(new shelf.Response.ok(file.openRead(), headers: headers));
    };
         
    return new Future.value(shelf.Response.ok('Not found "${request.url}"'));
  }
}

shelf.Response _echoRequest(shelf.Request request) {
  print(Database.Test());
  if (request.url.toString() == "/GetAll") {
    final String resultPath = "result.json";
    final File file = new File('./web/${resultPath}');
    /*
      Database.Test().then((List results) {
          print("Read result???");
        var stream = new Stream.fromIterable(results);
        return new shelf.Response.ok(stream);
      });
      */
      return new shelf.Response.ok(file.openRead());
      //return new shelf.Response.ok(Database.Test().toString());
    //return new shelf.Response.ok("File doesn't exist.");
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
