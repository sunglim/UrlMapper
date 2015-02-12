// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library nav_menu;

import 'dart:html';

initNavMenu() {
  var navdrawerContainer = querySelector('.navdrawer-container');
  var appbarElement = querySelector('.app-bar');
  var menuBtn = querySelector('.menu');
  var main = querySelector('main');
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
    window.open("http://192.168.1.103:8088/GetAll", 'foo');
  }
  downBtn.onClick.listen(downloadJson);
}
