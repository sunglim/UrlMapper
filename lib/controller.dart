library url_mapper.controller;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:url_mapper/database.dart';

Future<int> InsertSite(String site, String kind, String status) {
  // TODO(sungguk): Make single connection.
  String dbPath = './test.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database.open(dbPath, create: true)
      .then((_) => database.createUser(site, kind, status));
  }
  print("Return NULL ERROR.");
  return new Future.value(-1);
}

Future<int> DeleteSite(String site) {
  String dbPath = './test.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database.open(dbPath, create: true)
      .then((_) => database.deleteSite(site));
  }
  print("ERROR deleteing site.");
  return new Future.value(-1);
}

Future<String> SelectSite() {
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

// Create branch.
Future<int> InsertBranch(String branch) {
  String dbPath = './branch.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database.open(dbPath, create: true)
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
    return database.open(dbPath, create: true)
      .then((_) => database.getAllBranches()).then((branches) {
        return new Future.value(_GenearteJsonFromDatabase(branches));
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
    return database.open(dbPath, create: true)
      .then((_) => database.deleteBranch(branch));
  }
  print("ERROR deleteing branch.");
  return new Future.value(-1);
}

// Create with branch.
Future<int> InsertSiteWithBranch(String branch, String site, String kind, String status) {
  // TODO(sungguk): Make single connection.
  String dbPath = './branch_test.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database.open(dbPath, create: true)
      .then((_) => database.createSiteWithBranch(branch, site, kind, status));
  }
  print("Return NULL ERROR.");
  return new Future.value(-1);
}

String _GenearteJsonFromDatabase(List sites) {
  List<String> tmp = [];
  sites.forEach((site) {
    tmp.add(site);
  });
  return JSON.encode(tmp);
}
