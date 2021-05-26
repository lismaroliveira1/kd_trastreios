import 'package:kd_rastreios_cp/app/i18n/resources.dart';

enum UIError {
  invalidCode,
  invalidName,
  noError,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.invalidName:
        return R.translations.invalidName;
      case UIError.invalidCode:
        return R.translations.invalidCode;
      case UIError.noError:
        return '';
    }
  }
}
