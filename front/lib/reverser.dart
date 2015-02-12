// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library reverser;

import 'dart:html';

// Example of hooking into the DOM and responding to changes from input fields.
initReverser() {
  //var output = querySelector('#out');
  var input = querySelector('#name');
  TableElement table = querySelector('#result_table');
  input.onKeyUp.listen((_) {
    table.rows.forEach((TableRowElement row) {
      if (row.cells[0].innerHtml.toUpperCase().contains(
              input.value.toString().toUpperCase())) {
        row.style.display = "";  
      } else {
        row.style.display = "none";
      }
    });
    //output.text = input.value.split('').reversed.join();
  });
}
