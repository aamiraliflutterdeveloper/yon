import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/common/logger/log.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/add_post/mixins/add_post_mixin.dart';
import 'package:app/presentation/add_post/view_model/create_ad_post_view_model.dart';
import 'package:app/presentation/profile/edit_profile_screen.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:geocoder/geocoder.dart';

class AddLocationScreen extends StatefulWidget {
  double? lat;
  double? long;
  final int categoryIndex;
  String location;

  AddLocationScreen(
      {Key? key,
      required this.categoryIndex,
      required this.location,
      this.lat,
      this.long})
      : super(key: key);

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen>
    with AddPostMixin, BaseMixin {
  double? latitude, longitude;
  final markers = <Marker>{};
  MarkerId markerId = const MarkerId("YOUR-MARKER-ID");
  LatLng latLng = const LatLng(31.5204, 74.3587);
  final Completer<GoogleMapController> _controller = Completer();
  bool isAddressSelected = false;

  @override
  void initState() {
    streetAddressController.text = widget.location;
    latitude = widget.lat;
    longitude = widget.long;

    if (latitude != null && longitude != null) {
      getPinOnLocation();
    }

    setState(() {});

    // streetAddressController.addListener(() {
    //   if (_debounce?.isActive ?? false) _debounce?.cancel();
    //   _debounce = Timer(const Duration(milliseconds: 500), () {
    //     onChangePickup();
    //   });
    // });
    super.initState();
  }

  getPinOnLocation() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latitude!, longitude!),
      zoom: 18,
    )));
    markers.add(
        Marker(markerId: markerId, position: LatLng(latitude!, longitude!)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    final CreateAdPostViewModel createAdPostViewModel =
        context.watch<CreateAdPostViewModel>();
    final ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Add Location', context: context, onTap: () {Navigator.of(context).pop();}),
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom != 0
                ? med.height * 0.2
                : med.height * 0.65,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: CustomAppTheme().lightGreyColor,
                  ),
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: latLng, zoom: 14.34),
                    markers: markers,
                    mapType: MapType.terrain,
                    zoomControlsEnabled: false,
                    buildingsEnabled: true,
                    compassEnabled: false,
                    // myLocationEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onCameraMove: (position) async {
                      setState(() {
                        markers.add(Marker(
                            markerId: markerId, position: position.target));
                        latitude = position.target.latitude;
                        longitude = position.target.longitude;
                        d('LATITUDE : ' + position.target.latitude.toString());
                        d('LONGITUDE : ' +
                            position.target.longitude.toString());
                      });
                      // GeoData data = await Geocoder2.getDataFromCoordinates(
                      //     latitude: latitude!,
                      //     longitude: longitude!,
                      //     googleMapApiKey:
                      //         "AIzaSyBfd3J1uwYr-qhOrk8dke78tE8hMPvStXc");
                      // streetAddressController.text = data.address.toString();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15, bottom: 80),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () async {
                        await determinePosition();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: CustomAppTheme().backgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(Icons.my_location,
                              color: CustomAppTheme().blackColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom != 0
                    ? med.height * 0.15
                    : med.height * 0.6,
              ),
              Expanded(
                child: Container(
                  // height: med.height * 0.5,
                  width: med.width,
                  decoration: BoxDecoration(
                    color: CustomAppTheme().backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.8,
                        blurRadius: 5,
                        offset:
                            const Offset(0, -4), // changes position of shadow
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: med.height * 0.02,
                          ),
                          Text(
                            'Add Location',
                            style: CustomAppTheme().headingText.copyWith(
                                fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: med.height * 0.02,
                          ),
                          YouOnlineTextField(
                            headingText: 'Street Address',
                            hintText: 'Enter Street Address',
                            controller: streetAddressController,
                            onChanged: (value) {
                              setState(() {
                                getSuggession(value);
                              });
                            },
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: placesList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  var addresses = await Geocoder.local
                                      .findAddressesFromQuery(
                                          placesList[index]['description']);
                                  d('Pressed');
                                  // GeoData data = await Geocoder2.getDataFromAddress(
                                  //     address: placesList[index]['description'],
                                  //     googleMapApiKey:
                                  //         "AIzaSyBfd3J1uwYr-qhOrk8dke78tE8hMPvStXc");
                                  GoogleMapController controller =
                                      await _controller.future;
                                  controller.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                    target: LatLng(
                                        addresses.first.coordinates.latitude,
                                        addresses.first.coordinates.longitude),
                                    zoom: 18,
                                  )));
                                  latitude =
                                      addresses.first.coordinates.latitude;
                                  longitude =
                                      addresses.first.coordinates.longitude;
                                  streetAddressController.text =
                                      placesList[index]['description'];
                                  placesList = [];
                                  setState(() {});
                                },
                                child: DropdownMenuItem<String>(
                                  value: placesList[index]['description'],
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      placesList[index]['description'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: CustomAppTheme()
                                          .normalText
                                          .copyWith(
                                            letterSpacing: 0.5,
                                            color:
                                                CustomAppTheme().darkGreyColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: Platform.isIOS ? 0 : med.height * 0.05,
                          ),
                          placesList.isEmpty
                              ? SizedBox(
                                  width: med.width,
                                  child: YouOnlineButton(
                                      text: 'Save',
                                      onTap: widget.categoryIndex == -1
                                          ? () {
                                              if (streetAddressController
                                                  .text.isEmpty) {
                                                helper.showToast(
                                                    'Please set location');
                                              } else {
                                                UpdateUserProfile user =
                                                    UpdateUserProfile();
                                                user.streetAddress =
                                                    streetAddressController
                                                        .text;
                                                user.latitude =
                                                    latitude.toString();
                                                user.longitude =
                                                    longitude.toString();
                                                profileViewModel
                                                    .changeUpdateUserProfile(
                                                        user);
                                                // UserProfileModel? user = iPrefHelper.retrieveUser();
                                                // user?.latitude = latitude.toString();
                                                // user?.longitude = longitude.toString();
                                                // user?.streetAddress = streetAddressController.text;
                                                // iPrefHelper.saveUser(user!);
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const EditProfile()));
                                                Navigator.pop(context);
                                              }
                                            }
                                          : widget.categoryIndex == -2
                                              ? () {
                                                  if (streetAddressController
                                                      .text.isEmpty) {
                                                    helper.showToast(
                                                        'Please set location');
                                                  } else {
                                                    CreateBusinessProfileModel
                                                        businessProfile =
                                                        profileViewModel
                                                            .tempBusinessValues;
                                                    businessProfile
                                                            .businessLocation =
                                                        streetAddressController
                                                            .text;
                                                    businessProfile.latitude =
                                                        latitude.toString();
                                                    businessProfile.longitude =
                                                        longitude.toString();
                                                    profileViewModel
                                                        .changeTempBusinessValues(
                                                            businessProfile);
                                                    Navigator.pop(context);
                                                  }
                                                }
                                              : () {
                                                  if (widget.categoryIndex ==
                                                      0) {
                                                    if (streetAddressController
                                                        .text.isEmpty) {
                                                      helper.showToast(
                                                          'Please set location');
                                                    } else {
                                                      ClassifiedObject
                                                          classifiedData =
                                                          createAdPostViewModel
                                                              .classifiedAdData!;
                                                      classifiedData.latitude =
                                                          latitude.toString();
                                                      classifiedData.longitude =
                                                          longitude.toString();
                                                      classifiedData
                                                              .streetAddress =
                                                          streetAddressController
                                                              .text;
                                                      createAdPostViewModel
                                                          .changeClassifiedAdData(
                                                              classifiedData);
                                                      Navigator.pop(context);
                                                    }
                                                  } else if (widget
                                                          .categoryIndex ==
                                                      1) {
                                                    if (streetAddressController
                                                        .text.isEmpty) {
                                                      helper.showToast(
                                                          'Please set location');
                                                    } else {
                                                      PropertiesObject
                                                          propertiesData =
                                                          createAdPostViewModel
                                                              .propertyAdData!;
                                                      propertiesData.latitude =
                                                          latitude.toString();
                                                      propertiesData.longitude =
                                                          longitude.toString();
                                                      propertiesData
                                                              .streetAddress =
                                                          streetAddressController
                                                              .text;
                                                      createAdPostViewModel
                                                          .changePropertyAdData(
                                                              propertiesData);
                                                      Navigator.pop(context);
                                                    }
                                                  } else if (widget
                                                          .categoryIndex ==
                                                      2) {
                                                    if (streetAddressController
                                                        .text.isEmpty) {
                                                      helper.showToast(
                                                          'Please set location');
                                                    } else {
                                                      AutomotiveObject
                                                          automotiveData =
                                                          createAdPostViewModel
                                                              .automotiveAdData!;
                                                      automotiveData.latitude =
                                                          latitude.toString();
                                                      automotiveData.longitude =
                                                          longitude.toString();
                                                      automotiveData
                                                              .streetAddress =
                                                          streetAddressController
                                                              .text;
                                                      createAdPostViewModel
                                                          .changeAutomotiveAdData(
                                                              automotiveData);
                                                      Navigator.pop(context);
                                                    }
                                                  } else if (widget
                                                          .categoryIndex ==
                                                      3) {
                                                    if (streetAddressController
                                                        .text.isEmpty) {
                                                      helper.showToast(
                                                          'Please set location');
                                                    } else {
                                                      JobObject jobData =
                                                          createAdPostViewModel
                                                              .jobAdData!;
                                                      jobData.latitude =
                                                          latitude.toString();
                                                      jobData.longitude =
                                                          longitude.toString();
                                                      jobData.streetAddress =
                                                          streetAddressController
                                                              .text;
                                                      createAdPostViewModel
                                                          .changeJobAdData(
                                                              jobData);
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                }),
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: med.height * 0.03,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String sessionToken = '12345';
  var uuid = const Uuid();
  List<dynamic> placesList = [];
  Timer? _debounce;

  void getSuggession(String input) async {
    String kPlaceApiKey = "AIzaSyBfd3J1uwYr-qhOrk8dke78tE8hMPvStXc";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPlaceApiKey&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();
    d('data:::::::::$data');
    if (response.statusCode == 200) {
      setState(() {
        placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception();
    }
  }

  void onChangePickup() {
    if (sessionToken.isEmpty) {
      setState(() {
        sessionToken = uuid.v4();
      });
    }
    if (streetAddressController.text.isNotEmpty) {
      setState(() {
        getSuggession(streetAddressController.text);
      });
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(
          msg: "Location permissions are denied",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              "Location permissions are permanently denied, we cannot request permissions",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position);

    await getCurrentLocation();
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latitude!, longitude!),
      zoom: 18,
    )));
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: latitude!,
        longitude: longitude!,
        googleMapApiKey: "AIzaSyBfd3J1uwYr-qhOrk8dke78tE8hMPvStXc");
    streetAddressController.text = data.address.toString();
    setState(() {});
    d('LOCATION DATA : ' + data.address.toString());
    d("Latitude: $latitude and Longitude: $longitude");
  }
}
