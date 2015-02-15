// Copyright (c) 2015, Sungguk Lim. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library constants;

const String IP_ADDRESS = "http://192.168.1.103:8088/";
const String HOME_EXPECTED = "${IP_ADDRESS}index.html";
String URI_GET_ALL = IP_ADDRESS + "GetAll";

// Called from the client to get Json file.
// Because from the home server, I use portforward the URI can be diffent
// between the one called internally and the one called client.
String URI_GET_ALL_FROM_FRONT = IP_ADDRESS + "GetAll";

String URI_SET = IP_ADDRESS + "Set";

String URI_DELETE = IP_ADDRESS + "Delete";
