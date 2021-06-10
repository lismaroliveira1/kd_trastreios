import './strings.dart';

class EnUS implements Translations {
  String get alreadyExists => 'This package already exists';
  String get newTrackingPackage => 'New tracking package';
  String get badRequest => 'Something went wrong, try again later';
  String get unexpected => 'Something went wrong, try again later';
  String get notFound => "This isn't a valid correios package code";
  String get forbidden => 'Something is wrong, try again later';
  String get tranckindCode => 'Tracking code';
  String get packageName => 'Package name';
  String get getTracking => 'Get tracking';
  String get cancel => 'Cancel';
  String get inTransit => 'In transit';
  String get completed => 'In transit';
  String get nearbyAgencies => 'Nearby Agencies';
  String get unauthorized =>
      'Service currently unavailable, please try again later';
  String get setup => 'Setup';
  String get invalidName => 'Invalid name';
  String get invalidCode => 'Invalid tracking code';
  String get serverError => 'Internal server error, try again later';
  String get noResponse =>
      'The service did not return events for this tracking code.';
}
