part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class LoadLocationEvent extends LocationEvent {}

class LocationUpdated extends LocationEvent {
  final double latitude;
  final double longitude;

  const LocationUpdated(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}

class RequestLocationPermissionEvent extends LocationEvent {}

class FetchCurrentLocationEvent extends LocationEvent {
  final bool forceUpdate;

  const FetchCurrentLocationEvent({this.forceUpdate = false});

  @override
  List<Object> get props => [forceUpdate];
}

class ResetLocationEvent extends LocationEvent {}

class RefreshLocationEvent extends LocationEvent {}
