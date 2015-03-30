// Copyright (c) 2015, Sungguk Lim. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Library for managing branches.

library manage;

import 'dart:html';

import 'package:front2/constants.dart';

initManageFunction() {
  var btn = querySelector('#create_branch_btn');
  btn.onClick.listen(onCreateBranchBtnClick);
}

void insertCreateBranchItem(String branch) {
  var url = URI_CREATE_BRANCH + "?branch=" + branch;
  var request = HttpRequest.getString(url).then((output) {
    querySelector('#create_branch_msg').text = branch + " is created.";
  }).catchError((Error error) {
    querySelector('#create_branch_msg').text = "Already exist.";
  });
}

void onCreateBranchBtnClick(e) {
  var site = querySelector('#create_branch_input');
  var msg = querySelector('#create_branch_msg');
  msg.text = "";
  if (site.value.isEmpty) {
    msg.text = "Fill out branch input.";
    return;
  }
  insertCreateBranchItem(site.value.toString().trim());
}
