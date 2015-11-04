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
  querySelector('#create_kind_btn').onClick.listen(onCreateKindBtnClick);
  querySelector('#delete_kind_btn').onClick.listen(onDeleteKindBtnClick);
  querySelector('#create_touch_site_btn').onClick.listen(OnCreateTouchSiteBtnClick);
  querySelector('#delete_touch_site_btn').onClick.listen(OnDeleteTouchSiteBtnClick);

  resetAllBranchSelect();
  resetAllKindSelect();
  resetAllTouchSiteSelect();
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

void insertCreateKindItem(String kind, String ua) {
  // Should I do Url encoding?
  var url = URI_CREATE_KIND + "?kind=" + kind + "&ua=" + ua;
  var request = HttpRequest.getString(url).then((output) {
    querySelector('#create_kind_msg').text = kind + " is created.";
    resetAllKindSelect();
  }).catchError((Error error) {
    querySelector('#create_kind_msg').text = "Already exist.";
  });
}

void insertTouchSiteItem(String site) {
  var url = URI_CREATE_TOUCH_SITE + "?site=" + site;
  var request = HttpRequest.getString(url).then((output) {
    querySelector('#create_touch_site_msg').text = site + " is created.";
    resetAllTouchSiteSelect();
  }).catchError((Error error) {
    querySelector('#create_kind_msg').text = "Already exist.";
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

void onDeleteBranchBtnClick(e) {
  SelectElement status = querySelector('#branch_delete_select');
  String delete_branch = status.options[status.selectedIndex].value;

  var url = URI_DELETE_BRANCH + "?branch=" + delete_branch;
  var request = HttpRequest.getString(url).then((output) {
    resetAllBranchSelect();
  });
}

void onCreateKindBtnClick(e) {
  var kind = querySelector('#create_kind_input');
  var ua = querySelector('#create_kind_ua_input');
  if (kind.value.isEmpty || ua.value.isEmpty) {
    kind.text = "Fill out input.";
    return;
  }
  insertCreateKindItem(kind.value.toString().trim(), ua.value.toString().trim());
}

void onDeleteKindBtnClick(e) {
  SelectElement status = querySelector('#kind_delete_select');
  String delete_kind = status.options[status.selectedIndex].value;
  bool confirm = window.confirm("Are you sure to delete " + delete_kind + "?");
  if (!confirm) return;

  var url = URI_DELETE_KIND + "?kind=" + delete_kind;
  var request = HttpRequest.getString(url).then((output) {
    resetAllKindSelect();
  });
}

void OnCreateTouchSiteBtnClick(e) {
  var ua = querySelector('#create_touch_site_input');
  if (ua.value.isEmpty) {
    return;
  }
  insertTouchSiteItem(ua.value.toString().trim());
}

void OnDeleteTouchSiteBtnClick(e) {
  SelectElement status = querySelector('#touch_site_select');
  String delete_kind = status.options[status.selectedIndex].value;
  bool confirm = window.confirm("Are you sure to delete " + delete_kind + "?");
  if (!confirm) return;

  var url = URI_DELETE_TOUCH_SITE + "?site=" + delete_kind;
  var request = HttpRequest.getString(url).then((output) {
    resetAllTouchSiteSelect();
  });
}

void resetAllKindSelect() {
  var request = HttpRequest.getString(URI_GET_ALL_KINDS).then((output) {
    SelectElement delete_select = querySelector('#kind_delete_select');
    delete_select.options.forEach((e) {
      e.remove();
    });

    // branch_insert_select is not managed page. but it also should be reset.
    SelectElement insert_select = querySelector('#kind_select');
    insert_select.options.forEach((e) {
      e.remove();
    });

    List<String> decoded = JSON.decode(output);
    decoded.forEach((e) {
      OptionElement option = new OptionElement();
      String name =
          e.toString().replaceFirst('[','').replaceFirst(']','');
      option.text = name;
      option.value = e[0].toString();
      delete_select.children.add(option);

      OptionElement option_clone = new OptionElement();
      option_clone.text = e[0].toString();
      option_clone.value = e[0].toString();
      insert_select.children.add(option_clone);
    });
  });
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

    resetOverrideCheck(decoded);

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

resetOverrideCheck(List branch_list) {
  var override_div = querySelector('#override_list');
  var override_manual_div = querySelector('#override_manual_list');
  override_div.children.clear();
  branch_list.forEach((e) {
    ButtonElement button = new ButtonElement();
    String branch_name =
          e.toString().replaceFirst('[','').replaceFirst(']','');
    button.name = branch_name;
    button.text= branch_name;
    button.onClick.listen(_buttonListener);
    button.id = branch_name + "_branch_btn";
    override_div.children.add(button);

    AnchorElement anchor = new AnchorElement();
    anchor.text = " " + branch_name + " ";
    anchor.onClick.listen(_manualOverrideListener);
    override_manual_div.children.add(anchor);
  });
}

void resetAllTouchSiteSelect() {
  var select = querySelector('#touch_site_select');
  select.children.clear();

  var request = HttpRequest.getString(URI_GET_ALL_TOUCH_SITES).then((output) {
    List<String> decoded = JSON.decode(output);

    SelectElement insert_select = querySelector('#touch_site_select');
    decoded.forEach((e) {
      OptionElement option = new OptionElement();
      String touch_site =
          e.toString().replaceFirst('[','').replaceFirst(']','');
      option.text = touch_site;
      option.value = touch_site;
      insert_select.children.add(option);
    });
  }).catchError((Error error) {});
}

_buttonListener(e) {
  var target = e.target;
  var url = URI_GET_ALL_FROM_FRONT + "?branch=" + target.text;
  window.open(url, 'foo');
}

_manualOverrideListener(e) {
  var target = e.target;
  var override_input = querySelector('#manual_override_query');
  override_input.value = override_input.value + target.text + " + ";
}
