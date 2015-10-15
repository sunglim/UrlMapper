library url_mapper.controller;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:url_mapper/database.dart';

Future<int> InsertSite(String branch, String site, String kind, String status) {
  if (branch != null) {
    return InsertSiteWithBranch(branch, site, kind, status);
  }
  // TODO(sungguk): Make single connection.
  String dbPath = './test.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database
        .open(dbPath, create: true)
        .then((_) => database.createUser(site, kind, status));
  }
  print("Return NULL ERROR.");
  return new Future.value(-1);
}

Future<int> DeleteSite(String branch, String site) {
  if (branch != null) {
    return DeleteSiteWithBranch(branch, site);
  }
  String dbPath = './test.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database
        .open(dbPath, create: true)
        .then((_) => database.deleteSite(site));
  }
  print("ERROR deleteing site.");
  return new Future.value(-1);
}

Future<int> DeleteSiteWithBranch(String branch, String site) {
  String dbPath = './branch_test.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database
        .open(dbPath, create: true)
        .then((_) => database.deleteSiteWithBranch(branch, site));
  }
  print("ERROR deleteing site.");
  return new Future.value(-1);
}

// Get Raw site data
Future<String> SelectSite() {
  String dbPath = './test.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database
        .open(dbPath, create: true)
        .then((_) => database.getUsers())
        .then((sites) {
      return new Future.value(_GenearteJsonString(sites));
    });
  }
  print("Return NULL ERROR.");
  return new Future.value();
}

// Get Raw site data with branch
Future<String> SelectSitesWithBranch() {
  String dbPath = './branch_test.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database
        .open(dbPath, create: true)
        .then((_) => database.getSitesWithBranch())
        .then((sites) {
      return new Future.value(_GenearteJsonString(sites));
    });
  }
  print("Return NULL ERROR.");
  return new Future.value();
}

// Create branch.
Future<int> InsertBranch(String branch) {
  String dbPath = './branch.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database
        .open(dbPath, create: true)
        .then((_) => database.createBranch(branch));
  }
  print("Return NULL ERROR.");
  return new Future.value(-1);
}

Future<String> SelectAllBranches() {
  String dbPath = './branch.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database
        .open(dbPath, create: true)
        .then((_) => database.getAllBranches())
        .then((branches) {
      return new Future.value(_GenearteJsonString(branches));
    });
  }
  print("Return NULL ERROR.");
  return new Future.value(-1);
}

Future<int> DeleteBranch(String branch) {
  String dbPath = './branch.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database
        .open(dbPath, create: true)
        .then((_) => database.deleteBranch(branch));
  }
  print("ERROR deleteing branch.");
  return new Future.value(-1);
}

// Create Kind.
Future<int> InsertKind(String kind, String ua) {
  String dbPath = './ua_kind.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database
        .open(dbPath, create: true)
        .then((_) => database.createKind(kind, ua));
  }
  print("Return NULL ERROR.");
  return new Future.value(-1);
}

Future<String> SelectAllKinds() {
  String dbPath = './ua_kind.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database
        .open(dbPath, create: true)
        .then((_) => database.getAllKinds())
        .then((kinds) {
      return new Future.value(_GenearteJsonString(kinds));
    });
  }
  print("Return NULL ERROR.");
  return new Future.value(-1);
}

Future<Map<String, String>> SelectAllKindsAsMap() {
  String dbPath = './ua_kind.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database
        .open(dbPath, create: true)
        .then((_) => database.getAllKinds())
        .then((kinds) {
      return new Future.value(_GenerateMap(kinds));
    });
  }
}

Map<String, String> _GenerateMap(List kinds) {
  Map<String, String> ua_map = {};
  kinds.forEach((single) {
    ua_map[single[0]] = single[1];
  });
  return ua_map;
}

Future<int> DeleteKind(String kind) {
  String dbPath = './ua_kind.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database
        .open(dbPath, create: true)
        .then((_) => database.deleteKind(kind));
  }
  print("ERROR deleteing kind.");
  return new Future.value(-1);
}

// Create with branch.
Future<int> InsertSiteWithBranch(
    String branch, String site, String kind, String status) {
  // TODO(sungguk): Make single connection.
  String dbPath = './branch_test.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);

    return database.open(dbPath, create: true).then((_) {
      return database.getSitesWIthBranchAndData(branch, site).then((result) {
        print(result);
        if (result.isNotEmpty) {
          print("Return NULL ERROR.");
          return new Future.value(-1);
        }
        return database.createSiteWithBranch(branch, site, kind, status);
      });
    });
  }
  print("Return NULL ERROR.");
  return new Future.value(-1);
}

String _GenearteJsonString(List sites) {
  List<String> tmp = [];
  sites.forEach((site) {
    tmp.add(site);
  });
  return JSON.encode(tmp);
}
