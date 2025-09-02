import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_life_muslim/core/utils/functions/location_service.dart';

import '../../../../core/shared_preferenced/shared_preferenced.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<LoadLocationEvent>(_onLoadSavedLocation);
    on<RequestLocationPermissionEvent>(_onRequestPermission);
    on<FetchCurrentLocationEvent>(_onFetchCurrentLocation);
    on<ResetLocationEvent>(_onResetLocation);
    on<RefreshLocationEvent>(_onRefreshLocation);
  }

  Future<void> _onLoadSavedLocation(
    LoadLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final data = await LocationLocator().fetchSavedLocation();
      final lat = data?["latitude"];
      final long = data?["longitude"];
      final hasValidLocation = lat != null && long != null && lat != 0.0 && long != 0.0;

      if (hasValidLocation) {
        emit(LocationHasSavedData(data!));
      } else {
        add(RequestLocationPermissionEvent());
      }
    } catch (e) {
      emit(LocationError("حدث خطأ أثناء تحميل الموقع المحفوظ: $e"));
      add(RequestLocationPermissionEvent());
    }
  }

  Future<void> _onRequestPermission(RequestLocationPermissionEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    try {
      final status = await Permission.location.request();

      if (status.isGranted) {
        emit(LocationPermissionGranted());
        add(FetchCurrentLocationEvent());
      } else if (status.isDenied) {
        emit(const LocationPermissionDenied("تم رفض إذن الوصول للموقع"));
      } else {
        emit(const LocationPermissionPermanentlyDenied("إذن الموقع مرفوض نهائياً. يرجى تمكينه من إعدادات الجهاز"));
      }
    } catch (e) {
      emit(LocationError("حدث خطأ أثناء طلب إذن الموقع: $e"));
    }
  }

  Future<void> _onFetchCurrentLocation(FetchCurrentLocationEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    try {
      final locationData = await LocationLocator().checkLocationPermissionAndSave();

      if (locationData != null) {
        emit(
          LocationSaved(
            latitude: locationData["latitude"],
            longitude: locationData["longitude"],
            city: locationData["city"],
            country: locationData["country"],
          ),
        );
      } else {
        emit(const LocationError("تعذر الحصول على الموقع الحالي"));
      }
    } on TimeoutException {
      emit(const LocationError("استغرقت عملية جلب الموقع وقتاً طويلاً"));
    } catch (e) {
      emit(LocationError("حدث خطأ: ${e.toString()}"));
    }
  }

  Future<void> _onRefreshLocation(RefreshLocationEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    try {
      final savedData = await LocationLocator().fetchSavedLocation();
      final lat = savedData?["latitude"];
      final long = savedData?["longitude"];

      if (lat != null && long != null && lat != 0.0 && long != 0.0) {
        emit(LocationHasSavedData(savedData!));
      } else {
        // فقط إذا لم تكن هناك بيانات مخزنة، اطلب موقع جديد
        final locationData = await LocationLocator().checkLocationPermissionAndSave();
        if (locationData != null) {
          await SharedPrefController.saveLocationData(
            locationData["latitude"],
            locationData["longitude"],
            locationData["city"],
            locationData["country"],
          );
          emit(LocationSaved(
            latitude: locationData["latitude"],
            longitude: locationData["longitude"],
            city: locationData["city"],
            country: locationData["country"],
          ));
        } else {
          emit(const LocationError("تعذر تحديث الموقع الحالي. تأكد من اتصالك بالإنترنت."));
        }
      }
    } on TimeoutException {
      emit(const LocationError("استغرقت عملية تحديث الموقع وقتاً طويلاً"));
    } catch (e) {
      emit(LocationError("حدث خطأ أثناء تحديث الموقع: ${e.toString()}"));
    }
  }

  Future<void> _onResetLocation(ResetLocationEvent event, Emitter<LocationState> emit) async => emit(LocationInitial());
}
