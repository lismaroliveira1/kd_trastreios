part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const SPLASH = _Paths.SPLASH;
  static const SETUP = _Paths.SETUP;
}

abstract class _Paths {
  static const HOME = '/home';
  static const SPLASH = '/splash';
  static const SETUP = '/setup';
}
