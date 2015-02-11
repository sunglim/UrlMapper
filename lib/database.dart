library url_mapper;

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:sqlite/sqlite.dart';

class Database {
  SQLite _sqlite;
  int _db;
  bool _prepared;

  Map<String, dynamic> preparedStatements = { // note that map String values are overwritten by statement int in prepare
    'CREATEUSER':           'INSERT INTO users (userName,password,points) values (?,?,NULL)',
    'GETUSER':              'SELECT userID,userName,points FROM users WHERE userID=?',
    'GETUSERS':             'SELECT * FROM ua_spoof',
  };

  Database(int log) {
    _sqlite = new SQLite()
      ..config(log: log);
    _prepared = false;
  }

  // expecting always there already exist db.
  Future<int> open(String path, {bool create: false}) {
    return _sqlite.open(path, create ? SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE : SQLITE_OPEN_READWRITE)
      .then((result) {
        _db = result[1];
        _sqlite.busyTimeout(_db, 500000);
        return _db;
      });
  }

  Future<int> close() {
    return Future.forEach(_prepared ? preparedStatements.values : [], (int statement) => _sqlite.finalize(_db, statement)).then((_) =>
      _sqlite.close(_db).then((List result) {
        _sqlite.terminate();
        return result[0];
      }));
  }

  Future prepare() {
    _prepared = true;
    return Future.forEach(preparedStatements.keys, (key) =>
      _sqlite.prepare(_db, preparedStatements[key]).then((List result) => preparedStatements[key] = result[1]));
  }

  Future<int> createUser(String userName, String password, {int batchID: null}) {
    //String dbPass = digestToString(new SHA1().update(UTF8.encode('sunny' + userName.toLowerCase() + password)).digest());
    return _sqlite.executeNonSelect(_db, preparedStatements['CREATEUSER'], params: [userName, password], batchID: batchID)
      .then((result) => result[1]);
  }

  Future<Map> getUser(int userID) {
    return _sqlite.executeSelect(_db, preparedStatements['GETUSER'], params: [userID]).then((result) {
      List rows = result[1];
      if (rows.length == 0)
        return null;
      List r = rows[0];
      return {'userID': r[0], 'userName': r[1], 'points': r[2]};
    });
  }

  Future<List> getUsers() {
    return _sqlite.executeSelect(_db, preparedStatements['GETUSERS']).then((result) => result[1]);
  }

  Future createUsers(int nUserStart, int nUsers, {int batchID: null}) {
    int n = 0;
    return Future.doWhile(() => ++n == nUsers ? false : createUser('User${nUserStart + n - 1}', new Random().nextInt((1 << 32) - 1).toString(), batchID: batchID) != 0);
  }

  Future createUsersBatch(int nUserStart, int nUsers) {
    int batchID = _sqlite.beginBatch();
    return _sqlite.executeNonSelect(_db, 'BEGIN', batchID: batchID)
      .then((_) => createUsers(nUserStart, nUsers, batchID: batchID))
      .then((_) => _sqlite.executeNonSelect(_db, 'COMMIT', batchID: batchID))
      .then((_) => _sqlite.endBatch());
  }
}

Future<List> GetAll() {
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