import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:system_settings/system_settings.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo_locator;
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../controller/general_controller.dart';
import '../../utils/colors.dart';
import '../home/logic.dart';
import 'state.dart';

class EditProfileLogic extends GetxController {
  final state = EditProfileState();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController websiteAddressController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController openTimeController = TextEditingController();
  TextEditingController closeTimeController = TextEditingController();
  File? shopImage;
  String? downloadURL;
  String? longitudeString;
  String? latitudeString;

  Future<firebase_storage.UploadTask?> uploadFile(
      File? file, BuildContext context, String? id) async {
    if (file == null) {
      try {
        FirebaseFirestore.instance.collection('shop').doc(id).update({
          'address': addressController.text,
          'lng': longitude,
          'lat': latitude,
          'website_address': websiteAddressController.text,
          'about': aboutController.text,
          'name': nameController.text,
          'open_time': openTimeController.text,
          'close_time': closeTimeController.text,
          'image': downloadURL,
        });
        Get.find<GeneralController>().updateFormLoader(false);
        Get.back();
        Get.snackbar(
          'SUCCESS!',
          'Shop Updated Successfully...',
          colorText: Colors.white,
          backgroundColor: customThemeColor.withOpacity(0.7),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(15),
        );
      } on FirebaseException catch (e) {
        Get.find<GeneralController>().updateFormLoader(false);
        Get.snackbar(
          e.code,
          '',
          colorText: Colors.white,
          backgroundColor: customThemeColor.withOpacity(0.7),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(15),
        );
        log(e.toString());
      }
      Get.find<HomeLogic>().currentShop();
      return null;
    } else {
      firebase_storage.UploadTask uploadTask;

      final String pictureReference =
          "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(pictureReference);

      uploadTask = ref.putFile(shopImage!);

      downloadURL = await (await uploadTask).ref.getDownloadURL();
      log('URL---->>$downloadURL');
      try {
        FirebaseFirestore.instance.collection('shop').doc(id).update({
          'address': addressController.text,
          'lng': longitude,
          'lat': latitude,
          'website_address': websiteAddressController.text,
          'about': aboutController.text,
          'name': nameController.text,
          'open_time': openTimeController.text,
          'close_time': closeTimeController.text,
          'image': downloadURL,
        });
        Get.find<GeneralController>().updateFormLoader(false);
        Get.back();
        Get.snackbar(
          'SUCCESS!',
          'Shop Updated Successfully...',
          colorText: Colors.white,
          backgroundColor: customThemeColor.withOpacity(0.7),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(15),
        );
      } on FirebaseException catch (e) {
        Get.find<GeneralController>().updateFormLoader(false);
        Get.snackbar(
          e.code,
          '',
          colorText: Colors.white,
          backgroundColor: customThemeColor.withOpacity(0.7),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(15),
        );
        log(e.toString());
      }
      Get.find<HomeLogic>().currentShop();
      return Future.value(uploadTask);
    }
  }

  setData(DocumentSnapshot? shopModel) {
    nameController = TextEditingController(text: shopModel!.get('name'));
    addressController = TextEditingController(text: shopModel.get('address'));
    aboutController = TextEditingController(text: shopModel.get('about'));
    openTimeController =
        TextEditingController(text: shopModel.get('open_time'));
    closeTimeController =
        TextEditingController(text: shopModel.get('close_time'));
    websiteAddressController =
        TextEditingController(text: shopModel.get('website_address'));
    downloadURL = shopModel.get('image');
  }

  ///------------------------------------LOCATION----START-----------------

  geo_locator.Position? currentPosition;
  double? latitude;
  double? longitude;
  String? currentAddress;
  String? currentArea;
  String? currentCity;
  String? currentCountry;
  saveData({String? latLong, String? place}) async {
    var data = await json.decode(latLong!);
    addressController.text = place!;
    longitudeString = data['lng'].toString();
    latitudeString = data['lat'].toString();
    latitude = double.parse(latitudeString.toString());
    longitude = double.parse(longitudeString.toString());
    center = LatLng(latitude!, longitude!);
    lastMapPosition = center;
    final GoogleMapController controller1 = await controller.future;
    controller1.moveCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: center)));
    onCameraMove(CameraPosition(target: center));
    update();
    log("Center--->>> $center");
    log("LatLong--->>> $data");
    log("LatLong Place--->>> $place");
  }

  saveLocation() async {
    List<Placemark> p = await GeocodingPlatform.instance
        .placemarkFromCoordinates(center.latitude, center.longitude);
    Placemark place = p[0];
    String getAddress =
        '${place.name}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';
    addressController.text = getAddress;
    longitudeString = center.longitude.toString();
    latitudeString = center.latitude.toString();
    update();
    Get.back();
    log('getAddress--->>${getAddress.toString()}');
  }

  Future<bool> _requestPermission(Permission permission) async {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  requestLocationPermission(BuildContext context) async {
    if (Platform.isIOS) {
      await [
        Permission.location,
        Permission.locationWhenInUse,
      ].request();
      await Permission.locationWhenInUse.request();
      ServiceStatus serviceStatus = await Permission.location.serviceStatus;
      bool enabled = (serviceStatus == ServiceStatus.enabled);

      if (!enabled) {
        log('IOS permission--->> $enabled');
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return CustomDialogBox(
        //         title: '${'location'.tr}!',
        //         titleColor: customDialogInfoColor,
        //         descriptions: 'please_turn_on_your_location'.tr,
        //         text: 'ok'.tr,
        //         functionCall: () {
        //           Navigator.pop(context);
        //           AppSettings.openLocationSettings();
        //         },
        //         img: 'assets/dialog_Info.svg',
        //       );
        //     });
      } else {
        getCurrentLocation();
      }
    } else {
      var granted = await _requestPermission(Permission.location);
      if (granted != true) {
        var granted1 = await _requestPermission(Permission.locationAlways);
        if (granted1 != true) {
          requestLocationPermission(context);
        }
        requestLocationPermission(context);
      } else {
        // _gpsService();
        getCurrentLocation();
      }
      debugPrint('requestLocationPermission $granted');
      return granted;
    }
  }

  getCurrentLocation() {
    geo_locator.Geolocator.getCurrentPosition(
            desiredAccuracy: geo_locator.LocationAccuracy.high)
        .then((geo_locator.Position position) {
      currentPosition = position;
      longitude = currentPosition!.longitude;
      latitude = currentPosition!.latitude;
      center = LatLng(latitude!, longitude!);
      lastMapPosition = center;
      log("longitude : $longitude");
      log("latitude : $latitude");
      log("address : $currentPosition");

      update();
      if (currentPosition == null) {
        getCurrentLocation();
      }
      getAddressFromLatLng();
    }).catchError((e) {
      // Get.find<GeneralController>().updateFormLoader(false);
      _gpsService();
      log('ERROR LOCATION${e.toString()}');
    });
  }

  enableLocation() async {
    await SystemSettings.location();
  }

  Future _gpsService() async {
    if (!(await geo_locator.Geolocator.isLocationServiceEnabled())) {
      enableLocation();
      return null;
    } else {
      return true;
    }
  }

  getAddressFromLatLng() async {
    try {
      List<Placemark> p = await GeocodingPlatform.instance
          .placemarkFromCoordinates(
              currentPosition!.latitude, currentPosition!.longitude);
      Placemark place = p[0];
      currentAddress =
          '${place.name}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';
      // if (addressController.text.isEmpty) {
      //   addressController.text = currentAddress!;
      // }
      currentArea = "${place.thoroughfare}";
      currentCity = place.subAdministrativeArea.toString();
      currentCountry = place.country.toString();
      log('CURRENT-ADDRESS--->>${currentAddress.toString()}');
      log('ADMINISTRATIVE--->>${place.administrativeArea.toString()}');
      log('SUB-ADMINISTRATIVE--->>${place.subAdministrativeArea.toString()}');
      log('SUB-ADMINISTRATIVE--->>${place.country.toString()}');
      log('THROUGH_FAIR--->>${place.thoroughfare.toString()}');
      log('COMPLETE_PLACE--->>${place.toJson().toString()}');
      // Get.find<GeneralController>().updateFormLoader(false);
      update();
    } catch (e) {
      // Get.find<GeneralController>().updateFormLoader(false);
      log(e.toString());
    }
  }

  ///------------------------------------LOCATION----END-----------------
  ///------------------------------------MAP-DATA----START-----------------
  late LatLng center;
  Completer<GoogleMapController> controller = Completer();

  Set<Marker> markers = {};

  late LatLng lastMapPosition = center;
  Future<void> onCameraMove(CameraPosition position) async {
    lastMapPosition = position.target;
    center = lastMapPosition;

    onAddMarkerButtonPressed();
    update();
  }

  void onAddMarkerButtonPressed() {
    markers = {};
    markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(lastMapPosition.toString()),
      position: lastMapPosition,
      infoWindow: InfoWindow(
        title: addressController.text,
        snippet: '',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    update();
  }

  ///------------------------------------MAP-DATA----END-----------------

}
