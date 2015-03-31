// Copyright (c) 2015, Sungguk Lim. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library delete;

import 'dart:html';

import 'package:front2/constants.dart';

void deleteItem(String branch, String site) {
  var url = URI_DELETE + "?site=" + site;
  if (branch != null) {
    url += "&branch=" + branch;
  }
  var request = HttpRequest.getString(url).then((output) {
    window.location.assign(HOME_EXPECTED);
  })
  .catchError((Error error) {
    querySelector('#insert_msg').text = "Error to delete.";
  });
}
