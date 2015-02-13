library url_mapper.controller;

import 'dart:async';
import 'dart:io';

import 'package:url_mapper/database.dart';

Future<int> InsertSite(String site, String kind) {
  // TODO(sungguk): Make single connection.
  String dbPath = './test.db';
    File dbFile = new File(dbPath);
    if (dbFile.existsSync()) {
      Database database = new Database(1);
      return database.open(dbPath, create: true)
        .then((_) => database.createUser(site, kind));
    }
    print("Return NULL ERROR.");
    return new Future.value(-1);
}