library url_mapper;

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:sqlite/sqlite.dart';

class Database {
  SQLite _sqlite;
  int _db;
  bool _prepared;

  Map<String, dynamic> preparedStatements = {
    // note that map String values are overwritten by statement int in prepare
    'CREATEUSER': 'INSERT INTO ua_spoof (SITE, KIND, STATUS) values (?,?,?)',
    'DELETESITE': 'DELETE FROM ua_spoof WHERE site=?',
    'GETUSER': 'SELECT SITE, KIND, STATUS FROM ua_spoof WHERE KIND=?',
    'GETUSERS': 'SELECT SITE, KIND, STATUS FROM ua_spoof',
    // About Kind.
    'CREATEKIND': 'INSERT INTO ua_kind (KIND, UA) values(?, ?)',
    'DELETEKIND': 'DELETE FROM ua_kind WHERE kind=?',
    'GETKINDS': 'SELECT KIND, UA FROM ua_kind',
    // About branches.
    'CREATEBRANCH': 'INSERT INTO ua_branch (BRANCH) values(?)',
    'DELETEBRANCH': 'DELETE FROM ua_branch WHERE branch=?',
    'GETBRANCHES': 'SELECT BRANCH FROM ua_branch',
    // Insert to branch related site.
    'CREATEBRANCHSITE':
        'INSERT INTO ua_spoof_branch (BRANCH, SITE, KIND, STATUS) values (?,?,?,?)',
    'GETBRANCHSITES': 'SELECT BRANCH, SITE, KIND, STATUS FROM ua_spoof_branch',
    'GETBRANCHSITESWITH':
        'SELECT BRANCH, SITE, KIND, STATUS FROM ua_spoof_branch WHERE branch=?',
    'GETBRANCHSITESWITHDATA':
        'SELECT BRANCH, SITE, KIND, STATUS FROM ua_spoof_branch WHERE branch=? and site=?',
    'DELETEBRANCHSITE': 'DELETE FROM ua_spoof_branch WHERE branch=? AND site=?',
    // touch_sites
    'GETTOUCHSITES': 'SELECT SITE FROM touch_sites',
    'CREATETOUCHSITE': 'INSERT INTO touch_sites (SITE) values(?)',
    'DELETETOUCHSITE': 'DELETE FROM touch_sites WHERE site=?'
  };

  Database(int log) {
    _sqlite = new SQLite()..config(log: log);
    _prepared = false;
  }

  // expecting always there already exist db.
  Future<int> open(String path, {bool create: false}) {
    return _sqlite
        .open(path, create
            ? SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE
            : SQLITE_OPEN_READWRITE)
        .then((result) {
      _db = result[1];
      _sqlite.busyTimeout(_db, 500000);
      return _db;
    });
  }

  Future<int> close() {
    return Future
        .forEach(_prepared ? preparedStatements.values : [],
            (int statement) => _sqlite.finalize(_db, statement))
        .then((_) => _sqlite.close(_db).then((List result) {
      _sqlite.terminate();
      return result[0];
    }));
  }

  Future prepare() {
    _prepared = true;
    return Future.forEach(preparedStatements.keys, (key) => _sqlite
        .prepare(_db, preparedStatements[key])
        .then((List result) => preparedStatements[key] = result[1]));
  }

  Future<int> createUser(String site, String kind, String status,
      {int batchID: null}) {
    return _sqlite
        .executeNonSelect(_db, preparedStatements['CREATEUSER'],
            params: [site, kind, status], batchID: batchID)
        .then((result) => result[1]);
  }

  Future<int> deleteSite(String site) {
    return _sqlite
        .executeNonSelect(_db, preparedStatements['DELETESITE'], params: [site])
        .then((result) => result[1]);
  }

  Future<List> getUser(String kind) {
    return _sqlite
        .executeSelect(_db, preparedStatements['GETUSER'], params: [kind])
        .then((result) => result[1]);
  }

  Future<List> getUsers() {
    return _sqlite
        .executeSelect(_db, preparedStatements['GETUSERS'])
        .then((result) => result[1]);
  }

  Future createUsers(int nUserStart, int nUsers, {int batchID: null}) {
    int n = 0;
    return Future
        .doWhile(() => ++n == nUsers
            ? false
            : createUser('User${nUserStart + n - 1}',
                    new Random().nextInt((1 << 32) - 1).toString(),
                    batchID: batchID) !=
                0);
  }

  // About branch
  Future<int> createBranch(String branch) {
    return _sqlite
        .executeNonSelect(_db, preparedStatements['CREATEBRANCH'],
            params: [branch], batchID: null)
        .then((result) => result[1]);
  }

  Future<int> deleteBranch(String branch) {
    return _sqlite
        .executeNonSelect(_db, preparedStatements['DELETEBRANCH'],
            params: [branch])
        .then((result) => result[1]);
  }

  Future<List> getAllBranches() {
    return _sqlite
        .executeSelect(_db, preparedStatements['GETBRANCHES'])
        .then((result) => result[1]);
  }

  // About kind
  Future<int> createKind(String kind, String ua) {
    return _sqlite
        .executeNonSelect(_db, preparedStatements['CREATEKIND'],
            params: [kind, ua], batchID: null)
        .then((result) => result[1]);
  }
  Future<int> deleteKind(String kind) {
    return _sqlite
        .executeNonSelect(_db, preparedStatements['DELETEKIND'], params: [kind])
        .then((result) => result[1]);
  }
  Future<List> getAllKinds() {
    return _sqlite
        .executeSelect(_db, preparedStatements['GETKINDS'])
        .then((result) => result[1]);
  }

  Future<int> createSiteWithBranch(
      String branch, String site, String kind, String status,
      {int batchID: null}) {
    return _sqlite
        .executeNonSelect(_db, preparedStatements['CREATEBRANCHSITE'],
            params: [branch, site, kind, status], batchID: batchID)
        .then((result) => result[1]);
  }

  // select all
  Future<List> getSitesWithBranch() {
    return _sqlite
        .executeSelect(_db, preparedStatements['GETBRANCHSITES'])
        .then((result) => result[1]);
  }

  Future<List> getSitesWithBranchName(String branch) {
    return _sqlite
        .executeSelect(_db, preparedStatements['GETBRANCHSITESWITH'],
            params: [branch])
        .then((result) => result[1]);
  }

  Future<List> getSitesWIthBranchAndData(String branch, String site) {
    return _sqlite
        .executeSelect(_db, preparedStatements['GETBRANCHSITESWITHDATA'],
            params: [branch, site])
        .then((result) => result[1]);
  }

  Future<int> deleteSiteWithBranch(String branch, String site) {
    return _sqlite
        .executeNonSelect(_db, preparedStatements['DELETEBRANCHSITE'],
            params: [branch, site])
        .then((result) => result[1]);
  }

  Future createUsersBatch(int nUserStart, int nUsers) {
    int batchID = _sqlite.beginBatch();
    return _sqlite
        .executeNonSelect(_db, 'BEGIN', batchID: batchID)
        .then((_) => createUsers(nUserStart, nUsers, batchID: batchID))
        .then((_) => _sqlite.executeNonSelect(_db, 'COMMIT', batchID: batchID))
        .then((_) => _sqlite.endBatch());
  }

  Future<List> getTouchSites() {
    return _sqlite
        .executeSelect(_db, preparedStatements['GETTOUCHSITES'])
        .then((result) => result[1]);
  }

  Future<int> createTouchSite(String site) {
    int batchID = _sqlite.beginBatch();
    return _sqlite
        .executeNonSelect(_db, preparedStatements['CREATETOUCHSITE'],
            params: [site], batchID: null)
        .then((result) => result[1]);
  }

  Future<int> DeleteTouchSite(String kind) {
    return _sqlite
        .executeNonSelect(_db, preparedStatements['DELETETOUCHSITE'], params: [kind])
        .then((result) => result[1]);
  }
}

Future<List> GetAll() {
  String dbPath = './test.db';
  File dbFile = new File(dbPath);
  if (dbFile.existsSync()) {
    Database database = new Database(1);
    return database.open(dbPath, create: true).then((_) => database.getUsers());
  }
  print("Return NULL ERROR ");
  return new Future.value();
}
