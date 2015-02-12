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
  Map<String, Object > sites_map = {};
  print(sites);
  int site_index = 1;
  UA_MAP.forEach((k,v) {
    List<String> tmp = [];
    // Select by the index of UA_MAP.
    sites.where((i) => (i[1] == site_index)).toList().forEach((single_site) {
      // No better way instead of using []?.
      tmp.add(single_site[0]);
    });
    sites_map[k] = tmp;
    site_index++;
  });
  Map formData = {
      "version": "1.0",
      "keys": UA_MAP.keys.toList(),
      "uas": UA_MAP,
      "sites": sites_map
  };
  return new JsonEncoder.withIndent('    ').convert(formData);
}
