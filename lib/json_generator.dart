library url_mapper.json_generator;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:url_mapper/database.dart';
import 'package:url_mapper/controller.dart' as controller;

// TODO(sungguk): Remove database dependency.

Future<List> _GetMasterSite() {
  String dbPath = './test.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database.open(dbPath, create: true).then((_) => database.getUsers());
  }
  return new Future.value();
}

Future<String> JsonQuery() {
  return _GetMasterSite().then((sites) {
    return _GenearteJsonFromDatabase(sites);
  });
}

Future<String> JsonQueryWithSeveralBranchOverride(String branch_list) {
  return _GetMasterSite().then((sites) {
    List merged = sites;
    List<String> branches = branch_list.split(" ");

    return Future.forEach(branches, (single_branch) {
      return _GetBranchSite(single_branch).then((sites) {
        merged = _MergeBranchSite(merged, sites);
      });
    }).then((_) {
      return new Future.value(_GenearteJsonFromDatabase(merged));
    });
  });
}

Future<List> _GetBranchSite(String branch) {
  String dbPath = './branch_test.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database
        .open(dbPath, create: true)
        .then((_) => database.getSitesWithBranchName(branch));
  }
  return new Future.value();
}

Future<String> JsonQueryMergeBranch(String branch_name) {
  String dbPath = './test.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database
        .open(dbPath, create: true)
        .then((_) => database.getUsers())
        .then((sites) {
      dbPath = './branch_test.db';
      Database database2 = new Database(1);
      return database2
          .open(dbPath, create: true)
          .then((_) => database2.getSitesWithBranchName(branch_name))
          .then((branch_site) {
        List master_sites = _MergeBranchSite(sites, branch_site);
        return new Future.value(_GenearteJsonFromDatabase(master_sites));
      });
    });
  }
  print("Return NULL ERROR.");
  return new Future.value();
}

// two parameter list has different member.
List _MergeBranchSite(List master_sites, List branch_sites) {
  // Create growable;
  List merged_sites = master_sites.toList();
  branch_sites.forEach((single) {
    merged_sites.removeWhere((site) => site[0] == single[1]);
    var branch_element = [single[1], single[2], single[3]];
    merged_sites.add(branch_element);
  });
  return merged_sites;
}

Future<String> JsonQueryWith(String ua) {
  String dbPath = './test.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database
        .open(dbPath, create: true)
        .then((_) => database.getUser(ua))
        .then((sites) {
      return new Future.value(_GenearteJsonFromDatabase(sites));
    });
  }
  print("Return NULL ERROR.");
  return new Future.value();
}

/*
    return controller.SelectTouchSites().then((ret){
      return new Future.value(new shelf.Response.ok(ret.toString()));
    });
    */

Future<String> _GenearteJsonFromDatabase(List sites) {
  return controller.SelectAllKindsAsMap().then((map) {
    return controller.SelectTouchSitesAsMap().then((touch_sites) {
      Map<String, Object> sites_map = {};
      map.forEach((k, v) {
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
        "keys": map.keys.toList(),
        "touch_on": touch_sites.keys.toList(),
        "uas": map,
        "sites": sites_map
      };
      return new JsonEncoder.withIndent('    ').convert(formData);
    });
  });
}
