import 'package:grinder/grinder.dart';

void main([List<String>  args]) {
  task('init', init);
  task('build', build, ['init']);

  startGrinder(args);
}

init(GrinderContext context) {
  // Verify we're running in the project root.
  if (!getDir('lib').existsSync() || !getFile('pubspec.yaml').existsSync()) {
    context.fail('This script must be run from the project root.');
  }
}

build(GrinderContext context) {
  _build_sqlite(context);
}

_build_sqlite(GrinderContext context) {
  context.log('Compile sqlite lib');
  runProcess(context, 'make', workingDirectory: 'dart-async-sqlite');
}
