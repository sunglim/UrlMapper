// Copyright (c) 2015, Sungguk Lim. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library insert;

import 'dart:html';

import 'package:front2/constants.dart';

initInsertFunction() {
  var insertSubmitBtn = querySelector('#insert_submit');
  insertSubmitBtn.onClick.listen(onInsertBtnClick);
}

void insertItem(String site, String kind, String status) {
  var url = URI_SET + "?site=" + site + "&kind=" + kind + "&status=" + status;
  var request = HttpRequest.getString(url).then((output) {
    window.location.assign(HOME_EXPECTED);
  })
  .catchError((Error error) {
    querySelector('#insert_msg').text = "Already exist.";
  });
}

void onInsertBtnClick(e) {
  var site = querySelector('#site_input');
  var msg = querySelector('#insert_msg');
  msg.text = "";
  if (site.value.isEmpty) {
    msg.text = "Fill out site input.";
    return;
  }
  SelectElement kind = querySelector('#kind_select');
  SelectElement status = querySelector('#status_select');
  insertItem(site.value.toString().trim(),
             kind.options[kind.selectedIndex].value,
             status.options[status.selectedIndex].value);
}
