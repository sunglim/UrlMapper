// Copyright (c) 2015, Sungguk Lim. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library select;

import 'dart:html';

// Example of hooking into the DOM and responding to changes from input fields.
initSelectFunction() {
  var input = querySelector('#name');
  TableElement table = querySelector('#result_table');
  input.onKeyUp.listen((_) {
    table.rows.forEach((TableRowElement row) {
      if (row.cells[0].innerHtml.toUpperCase().contains(
              input.value.toString().toUpperCase()) ||
          row.cells[1].innerHtml.toUpperCase().contains(
              input.value.toString().toUpperCase()) ||
          row.cells[2].innerHtml.toUpperCase().contains(
              input.value.toString().toUpperCase())) {
        row.style.display = "";  
      } else {
        row.style.display = "none";
      }
    });
  });
}
