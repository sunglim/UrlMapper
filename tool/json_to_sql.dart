import 'dart:io';
import 'dart:convert';

main([List<String> args]) {
  File data = args.isEmpty ? new File('data.json') : new File(args[0]);
  String raw = data.readAsStringSync();
  Map site_map = JSON.decode(raw)['sites'];
  site_map.forEach((k,v) {
    (v as List).forEach((site)
      => print("INSERT INTO ua_spoof (SITE, KIND) values('${site}', '${k}');"));
  });
}
