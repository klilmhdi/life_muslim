part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationHasSavedData extends LocationState {
  final Map<String, dynamic> locationData;

  const LocationHasSavedData(this.locationData);

  @override
  List<Object?> get props => [locationData];
}

class LocationSaved extends LocationState {
  final double latitude;
  final double longitude;
  final String city;
  final String country;

  const LocationSaved({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
  });

  @override
  List<Object?> get props => [latitude, longitude, country, city];
}

class LocationPermissionGranted extends LocationState {}

class LocationPermissionDenied extends LocationState {
  final String message;

  const LocationPermissionDenied(this.message);

  @override
  List<Object?> get props => [message];
}

class LocationPermissionPermanentlyDenied extends LocationState {
  final String message;

  const LocationPermissionPermanentlyDenied(this.message);

  @override
  List<Object?> get props => [message];
}

class LocationServiceDisabled extends LocationState {
  final String message;

  const LocationServiceDisabled(this.message);

  @override
  List<Object?> get props => [message];
}

class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}
