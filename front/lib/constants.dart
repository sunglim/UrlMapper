// Copyright (c) 2015, Sungguk Lim. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library constants;

const String HOME_EXPECTED = "http://192.168.1.103:8088/index.html";
const String URI_GET_ALL = "http://192.168.1.103:8088/GetAll";

// Called from the client to get Json file.
// Because from the home server, I use portforward the URI can be diffent
// between the one called internally and the one called client.
const String URI_GET_ALL_FROM_FRONT = "http://192.168.1.103:8088/GetAll";

const String URI_SET = "http://192.168.1.103:8088/Set";