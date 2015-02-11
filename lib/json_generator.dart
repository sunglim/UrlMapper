library url_mapper.json_generator;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:url_mapper/database.dart';
import 'package:url_mapper/json_constants.dart';

Future<List> JsonFromGetAll() {
  String dbPath = './test.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database.open(dbPath, create: true)
      .then((_) => database.getUsers());
  }
  print("Return NULL ERROR ");
  return new Future.value();
}

Future<String> JsonQuery() {
  String dbPath = './test.db';
    File dbFile = new File(dbPath);
    if (dbFile.existsSync()) {
      Database database = new Database(1);
      return database.open(dbPath, create: true)
        .then((_) => database.getUsers()).then((sites) {
        return new Future.value(GenearteJsonFromDatabase(sites));
      });
    }
    print("Return NULL ERROR ");
    return new Future.value();
}

String GenearteJsonFromDatabase(List sites) {
  Map<String, List<String> > sites_map;

  Map formData = {
      "version": "1.0",
      "keys": UA_MAP.keys.toList(),
      "uas": UA_MAP,
      "sites": sites.toString()
  };
  return new JsonEncoder.withIndent('  ').convert(formData);
}
