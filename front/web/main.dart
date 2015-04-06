// Copyright (c) 2015, Sungguk Lim. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:convert';

import 'package:front2/constants.dart';
import 'package:front2/nav_menu.dart';
import 'package:front2/select.dart';
import 'package:front2/insert.dart';
import 'package:front2/delete.dart';
import 'package:front2/manage.dart';
import 'package:route_hierarchical/client.dart';

void main() {
  initNavMenu();
  initSelectFunction();
  initInsertFunction();
  initManageFunction();
  //initHistoryFunction();

  drawTable();

  // Webapps need routing to listen for changes to the URL.
  var router = new Router();
  router.root
    ..addRoute(name: 'about', path: '/about', enter: showAbout)
    ..addRoute(name: 'insert', path: '/insert', enter: showInsert)
    ..addRoute(name: 'manage', path: '/manage', enter: showManage)
    ..addRoute(name: 'history', path: '/history', enter: showHistory)
    ..addRoute(name: 'home', defaultRoute: true, path: '/', enter: showHome);
  router.listen();
}

void drawTable() {
  var url = URI_GET_ALL_RAW;
  HttpRequest.getString(url).then((output) {
    List items = JSON.decode(output);
    TableElement table = querySelector('#result_table');
    items.forEach((item) {
      TableRowElement lastRow = table.insertRow(-1);
      lastRow.insertCell(0).text = item[1];
      lastRow.insertCell(1).text = item[0];
      lastRow.insertCell(2).text = _StatusToString(item[2]);
      lastRow.insertCell(3).text = "Master";
      TableCellElement cell = lastRow.insertCell(4);
      SpanElement span = new SpanElement().. text = "[delete]";
      span.onClick.listen((_) {
        if (window.confirm('Are you sure to delete ' + item[0] + '?')) {
          deleteItem(null, item[0]);
        }
      });
      cell.insertAdjacentElement('afterBegin', span);
    });
  });
  drawBranchRows();
}

// draw more site that have branch info.
void drawBranchRows() {
  var url = URI_GET_ALL_RAW_WITH_BRANCH;
  HttpRequest.getString(url).then((output) {
    List items = JSON.decode(output);
    TableElement table = querySelector('#result_table');
    items.forEach((item) {
      TableRowElement lastRow = table.insertRow(-1);
      lastRow.insertCell(0).text = item[2];
      lastRow.insertCell(1).text = item[1];
      lastRow.insertCell(2).text = _StatusToString(item[3]);
      lastRow.insertCell(3).text = "##  " + item[0];
      TableCellElement cell = lastRow.insertCell(4);
      SpanElement span = new SpanElement().. text = "[delete]";
      span.onClick.listen((_) {
        if (window.confirm('delete is not supported for now')) {
          deleteItem(item[0], item[1]);
        }
      });
      cell.insertAdjacentElement('afterBegin', span);
    });
  });
}

void showAbout(RouteEvent e) {
  // Extremely simple and non-scalable way to show different views.
  querySelector('#home').style.display = 'none';
  querySelector('#insert').style.display = 'none';
  querySelector('#manage').style.display = 'none';
  querySelector('#history').style.display = 'none';
  querySelector('#about').style.display = '';
}

void showHistory(RouteEvent e) {
  querySelector('#home').style.display = 'none';
  querySelector('#insert').style.display = 'none';
  querySelector('#manage').style.display = 'none';
  querySelector('#history').style.display = '';
  querySelector('#about').style.display = 'none';
}

void showManage(RouteEvent e) {
  querySelector('#home').style.display = 'none';
  querySelector('#insert').style.display = 'none';
  querySelector('#manage').style.display = '';
  querySelector('#history').style.display = 'none';
  querySelector('#about').style.display = 'none';
}

void showInsert(RouteEvent e) {
  querySelector('#home').style.display = 'none';
  querySelector('#insert').style.display = '';
  querySelector('#manage').style.display = 'none';
  querySelector('#history').style.display = 'none';
  querySelector('#about').style.display = 'none';
}

void showHome(RouteEvent e) {
  querySelector('#home').style.display = '';
  querySelector('#insert').style.display = 'none';
  querySelector('#manage').style.display = 'none';
  querySelector('#history').style.display = 'none';
  querySelector('#about').style.display = 'none';
}

String _StatusToString(status) {
  switch(status) {
    case 0:
      return "Spoofing works";
    case 1:
      return "Spoofing does not work";
    case 2:
      return "Not required(No video)";
    case 3:
      return "Not required(fine without spoofing)";
  }
}
