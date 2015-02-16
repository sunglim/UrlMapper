import 'dart:io';
import 'dart:convert';

main([List<String> args]) {
  File data = args.isEmpty ? new File('data.json') : new File(args[0]);
  String raw = data.readAsStringSync();
  Map site_map = JSON.decode(raw)['sites'];
  print("""
CREATE TABLE ua_spoof(
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  SITE VARCHAR(255) UNIQUE,
  KIND VARCHAR(24),
  STATUS INTEGER
);
""");
  site_map.forEach((k,v) {
    (v as List).forEach((site)
      => print("INSERT INTO ua_spoof (SITE, KIND, STATUS) values('${site}', '${k}', 1);"));
  });
  print("SELECT * from ua_spoof;");
}
