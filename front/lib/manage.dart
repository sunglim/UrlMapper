// Copyright (c) 2015, Sungguk Lim. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Library for managing branches.

library manage;

import 'dart:convert';
import 'dart:html';

import 'package:front2/constants.dart';

initManageFunction() {
  var btn = querySelector('#create_branch_btn');
  btn.onClick.listen(onCreateBranchBtnClick);

  resetBranchDeleteSelect();
}

void insertCreateBranchItem(String branch) {
  var url = URI_CREATE_BRANCH + "?branch=" + branch;
  var request = HttpRequest.getString(url).then((output) {
    querySelector('#create_branch_msg').text = branch + " is created.";
  }).catchError((Error error) {
    querySelector('#create_branch_msg').text = "Already exist.";
  });

  resetBranchDeleteSelect();
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

void resetBranchDeleteSelect() {
  var url = URI_GET_ALL_BRANCHES;
  List branches;
  var request = HttpRequest.getString(url).then((output) {
    SelectElement status = querySelector('#branch_delete_select');
    status.options.forEach((e) {
      e.remove();
    });

    List<String> decoded = JSON.decode(output);
    decoded.forEach((e) {
      print(e);
      OptionElement option = new OptionElement();
      String branch_name =
          e.toString().replaceFirst('[','').replaceFirst(']','');
      option.text = branch_name;
      option.value = branch_name;
      status.children.add(option);
    });
  }).catchError((Error error) {});
}
