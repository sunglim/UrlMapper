// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library nav_menu;

import 'dart:html';

import 'package:front2/constants.dart';

initNavMenu() {
  var navdrawerContainer = querySelector('.navdrawer-container');
  var appbarElement = querySelector('.app-bar');
  var menuBtn = querySelector('.menu');
  var main = querySelector('main');
  
  // TODO(sungguk): Refactor. Extract code which is should not belong to here.
  var downBtn = querySelector('#download');

  closeMenu(e) {
    document.body.classes.remove('open');
    appbarElement.classes.remove('open');
    navdrawerContainer.classes.remove('open');
  }

  toggleMenu(e) {
    document.body.classes.toggle('open');
    appbarElement.classes.toggle('open');
    navdrawerContainer.classes.toggle('open');
    navdrawerContainer.classes.add('opened');
  }

  main.onClick.listen(closeMenu);
  menuBtn.onClick.listen(toggleMenu);
  navdrawerContainer.onClick.listen((event) {
    if (event.target.nodeName == 'A' || event.target.nodeName == 'LI') {
      closeMenu(event);
    }
  });
  
  downloadJson(e) {
    window.open(URI_GET_ALL_FROM_FRONT, 'foo');
  }
  downBtn.onClick.listen(downloadJson);
}