library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'package:polymer/src/build/log_injector.dart';
import 'package:core_elements/core_input.dart' as i0;
import 'package:core_elements/core_meta.dart' as i1;
import 'package:core_elements/core_iconset.dart' as i2;
import 'package:core_elements/core_icon.dart' as i3;
import 'package:core_elements/core_iconset_svg.dart' as i4;
import 'package:core_elements/core_style.dart' as i5;
import 'package:paper_elements/paper_input_decorator.dart' as i6;
import 'package:paper_elements/paper_input.dart' as i7;
import 'package:pol/main_app.dart' as i8;
import 'index.html.0.dart' as i9;
import 'package:smoke/smoke.dart' show Declaration, PROPERTY, METHOD;
import 'package:smoke/static.dart' show useGeneratedCode, StaticConfiguration;
import 'package:pol/main_app.dart' as smoke_0;
import 'package:polymer/polymer.dart' as smoke_1;
import 'package:observe/src/metadata.dart' as smoke_2;
abstract class _M0 {} // PolymerElement & ChangeNotifier

void main() {
  useGeneratedCode(new StaticConfiguration(
      checkedMode: false,
      getters: {
        #reverseText: (o) => o.reverseText,
        #reversed: (o) => o.reversed,
      },
      setters: {
        #reversed: (o, v) { o.reversed = v; },
      },
      parents: {
        smoke_0.MainApp: _M0,
        _M0: smoke_1.PolymerElement,
      },
      declarations: {
        smoke_0.MainApp: {
          #reversed: const Declaration(#reversed, String, kind: PROPERTY, annotations: const [smoke_2.reflectable, smoke_2.observable]),
        },
      },
      names: {
        #reverseText: r'reverseText',
        #reversed: r'reversed',
      }));
  new LogInjector().injectLogsFromUrl('index.html._buildLogs');
  configureForDeployment([
      i0.upgradeCoreInput,
      i1.upgradeCoreMeta,
      i2.upgradeCoreIconset,
      i3.upgradeCoreIcon,
      i4.upgradeCoreIconsetSvg,
      i5.upgradeCoreStyle,
      i6.upgradePaperInputDecorator,
      i7.upgradePaperInput,
      () => Polymer.register('main-app', i8.MainApp),
    ]);
  i9.main();
}
