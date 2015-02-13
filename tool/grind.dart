import 'package:grinder/grinder.dart';

void main([List<String>  args]) {
  task('init', init);
  task('build', build, ['init']);
  task('run_server', run, ['build']);

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
  Pub.build(context, workingDirectory: 'front');
}

run(GrinderContext context) {
  runDartScript(context, 'url_mapper.dart', workingDirectory: 'bin');
}

_build_sqlite(GrinderContext context) {
  context.log('Compile sqlite lib');
  runProcess(context, 'make', workingDirectory: 'dart-async-sqlite');
}
