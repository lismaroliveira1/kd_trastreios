import 'package:kd_rastreios_cp/app/i18n/resources.dart';

enum UIError {
  invalidCode,
  invalidFields,
  invalidName,
  unauthorized,
  badRequest,
  notFound,
  forbidden,
  unexpected,
  serverError,
  noError,
  noResponse,
  alreadyExists,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.invalidName:
        return R.translations.invalidName;
      case UIError.invalidCode:
        return R.translations.invalidCode;
      case UIError.badRequest:
        return R.translations.badRequest;
      case UIError.forbidden:
        return R.translations.forbidden;
      case UIError.notFound:
        return R.translations.notFound;
      case UIError.unauthorized:
        return R.translations.unauthorized;
      case UIError.unexpected:
        return R.translations.unexpected;
      case UIError.serverError:
        return R.translations.serverError;
      case UIError.noResponse:
        return R.translations.noResponse;
      case UIError.alreadyExists:
        return R.translations.alreadyExists;
      default:
        return '_';
    }
  }
}
