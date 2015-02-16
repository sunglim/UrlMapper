// Copyright (c) 2015, Sungguk Lim. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:convert';

import 'package:front2/constants.dart';
import 'package:front2/nav_menu.dart';
import 'package:front2/select.dart';
import 'package:front2/insert.dart';
import 'package:front2/delete.dart';
import 'package:route_hierarchical/client.dart';

void main() {
  initNavMenu();
  initSelectFunction();
  initInsertFunction();

  drawTable();

  // Webapps need routing to listen for changes to the URL.
  var router = new Router();
  router.root
    ..addRoute(name: 'about', path: '/about', enter: showAbout)
    ..addRoute(name: 'insert', path: '/insert', enter: showInsert)
    ..addRoute(name: 'home', defaultRoute: true, path: '/', enter: showHome);
  router.listen();
}

void drawTable() {
  var url = URI_GET_ALL_RAW;
  var request = HttpRequest.getString(url).then((output) {
    List items = JSON.decode(output);
    TableElement table = querySelector('#result_table');
    items.forEach((item) {
      //List<String> site_list = item;
      //site_list.forEach((site) {
        TableRowElement lastRow = table.insertRow(-1);
        lastRow.insertCell(0).text = item[0]; //m
        lastRow.insertCell(1).text = item[1];
        lastRow.insertCell(2).text = item[2];
        TableCellElement cell = lastRow.insertCell(3);
        SpanElement span = new SpanElement().. text = "[delete]";
        span.onClick.listen((_) {
          if (window.confirm('Are you sure to delete ' + item[0] + '?')) {
            deleteItem(item[0]);
          }
        });
        cell.insertAdjacentElement('afterBegin', span);
      //});
    });     
  });
}

void showAbout(RouteEvent e) {
  // Extremely simple and non-scalable way to show different views.
  querySelector('#home').style.display = 'none';
  querySelector('#insert').style.display = 'none';
  querySelector('#about').style.display = '';
}

void showInsert(RouteEvent e) {
  querySelector('#home').style.display = 'none';
  querySelector('#insert').style.display = '';
  querySelector('#about').style.display = 'none';
}

void showHome(RouteEvent e) {
  querySelector('#home').style.display = '';
  querySelector('#insert').style.display = 'none';
  querySelector('#about').style.display = 'none';
}
