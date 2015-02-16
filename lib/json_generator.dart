library url_mapper.json_generator;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:url_mapper/database.dart';
import 'package:url_mapper/constants.dart';

// TODO(sungguk): Remove database dependency.

Future<String> JsonQuery() {
  String dbPath = './test.db';
    File dbFile = new File(dbPath);
    if (dbFile.existsSync()) {
      Database database = new Database(1);
      return database.open(dbPath, create: true)
        .then((_) => database.getUsers()).then((sites) {
        return new Future.value(_GenearteJsonFromDatabase(sites));
      });
    }
    print("Return NULL ERROR.");
    return new Future.value();
}

Future<String> JsonQueryWith(String ua) {
  String dbPath = './test.db';
    File dbFile = new File(dbPath);
    if (dbFile.existsSync()) {
      Database database = new Database(1);
      return database.open(dbPath, create: true)
        .then((_) => database.getUser(ua)).then((sites) {
        return new Future.value(_GenearteJsonFromDatabase(sites));
      });
    }
    print("Return NULL ERROR.");
    return new Future.value();
}

String _GenearteJsonFromDatabase(List sites) {
  Map<String, Object > sites_map = {};
  UA_MAP.forEach((k,v) {
    List<String> tmp = [];
    // Select by the index of UA_MAP.
    sites.where((i) => (i[1] == k)).toList().forEach((single_site) {
      // No better way instead of using []?.
      if (single_site[2] == 0) // Only for status working.
        tmp.add(single_site[0]);
    });
    sites_map[k] = tmp;
  });
  Map formData = {
      "version": "1.1",
      "keys": UA_MAP.keys.toList(),
      "uas": UA_MAP,
      "sites": sites_map
  };
  return new JsonEncoder.withIndent('    ').convert(formData);
}
