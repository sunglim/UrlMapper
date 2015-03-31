// Copyright (c) 2015, Sungguk Lim. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// Library for managing branches.

library manage;

import 'dart:convert';
import 'dart:html';

import 'package:front2/constants.dart';

initManageFunction() {
  querySelector('#create_branch_btn').onClick.listen(onCreateBranchBtnClick);
  querySelector('#delete_branch_btn').onClick.listen(onDeleteBranchBtnClick);

  resetAllBranchSelect();
}

void insertCreateBranchItem(String branch) {
  var url = URI_CREATE_BRANCH + "?branch=" + branch;
  var request = HttpRequest.getString(url).then((output) {
    querySelector('#create_branch_msg').text = branch + " is created.";
  }).catchError((Error error) {
    querySelector('#create_branch_msg').text = "Already exist.";
  });

  resetAllBranchSelect();
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

void onDeleteBranchBtnClick(e) {
  SelectElement status = querySelector('#branch_delete_select');
  String delete_branch = status.options[status.selectedIndex].value;

  var url = URI_DELETE_BRANCH + "?branch=" + delete_branch;
  var request = HttpRequest.getString(url).then((output) {
  });

  resetAllBranchSelect();
}

void resetAllBranchSelect() {
  var request = HttpRequest.getString(URI_GET_ALL_BRANCHES).then((output) {
    SelectElement delete_select = querySelector('#branch_delete_select');
    delete_select.options.forEach((e) {
      e.remove();
    });
    // branch_insert_select is not managed page. but it also should be reset.
    SelectElement insert_select = querySelector('#branch_insert_select');
    insert_select.options.forEach((e) {
      e.remove();
    });
    OptionElement master_default = new OptionElement();
    master_default.text = "Master";
    master_default.value = "Master";
    insert_select.children.add(master_default);
 
    List<String> decoded = JSON.decode(output);
    decoded.forEach((e) {
      OptionElement option = new OptionElement();
      String branch_name =
          e.toString().replaceFirst('[','').replaceFirst(']','');
      option.text = branch_name;
      option.value = branch_name;
      OptionElement option_clone = new OptionElement();
      option_clone.text = branch_name;
      option_clone.value = branch_name;
      delete_select.children.add(option);
      insert_select.children.add(option_clone);
    });
  }).catchError((Error error) {});
}
