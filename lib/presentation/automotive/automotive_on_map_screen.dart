import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'dart:math';
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/searched_textfield.dart';
import 'package:app/presentation/utils/widgets/wide_product_card_widget.dart';
import 'package:app/presentation/widgets_screens/product_detail_screen.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class AutomotiveOnMapScreen extends StatefulWidget {
  const AutomotiveOnMapScreen({Key? key}) : super(key: key);

  @override
  State<AutomotiveOnMapScreen> createState() => _AutomotiveOnMapScreenState();
}

class _AutomotiveOnMapScreenState extends State<AutomotiveOnMapScreen>
    with BaseMixin {
  TextEditingController searchController = TextEditingController();
  // late BitmapDescriptor pinLocationIcon;
  // Set<Marker> markers = {};
  // late List<Marker> markers;
  late List<Marker> markers;
  List<AutomotiveProductModel> automotiveAds = [];
  List<AutomotiveProductModel> _foundautomotiveAds = [];
  bool isDataFetching = false;

  // final Completer<GoogleMapController> _controller = Completer();
  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(31.5204, 74.3587),
  //   zoom: 14.4746,
  // );

  List<LatLng> points = [];

  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  final PopupController _popupController = PopupController();

  double? latitude, longitude;

  void getNearByAutomotive(
      {required double latitude, required double longitude}) async {
    var screenHeight = window.physicalSize.height / window.devicePixelRatio;
    var screenWidth = window.physicalSize.width / window.devicePixelRatio;
    AutomotiveViewModel automotiveViewModel =
        context.read<AutomotiveViewModel>();
    setState(() {
      isDataFetching = true;
    });
    final result = await automotiveViewModel.getNearByAutomotiveAds(
        latitude: latitude, longitude: longitude);
    result.fold((l) {}, (r) {
      d('NEAR BY PROPERTY ADS : ${r.automotiveAdsList}');
      automotiveAds = r.automotiveAdsList!;
      _foundautomotiveAds = automotiveAds;
      print(automotiveAds.length);
      print("hahahhahhha $_foundautomotiveAds");
      automotiveViewModel.changeNearByAutomotive(r.automotiveAdsList!);
      markers.add(
          Marker(
            anchorPos: AnchorPos.align(AnchorAlign.center),
            height: 30,
            width: 30,
            point: points[0],
            builder: (ctx) => const Icon(Icons.pin_drop),
          )
      );
      for (int i = 0; i < r.automotiveAdsList!.length; i++) {
        markers.add(Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point:  LatLng(double.parse(r.automotiveAdsList![i].latitude.toString()), double.parse(r.automotiveAdsList![i].longitude.toString())),
          builder: (ctx) => const Icon(Icons.pin_drop),
        ));
        // var newLat = double.parse(r.automotiveAdsList![i].latitude!) + -(Random().nextDouble() * 0.0005) * Math.cos((+a*i) / 180 * Math.PI);  //x
        //
        // // var newLat = double.parse(r.automotiveAdsList![i].latitude!) + -(Random().nextDouble() * 0.0005) * Math.cos((+a*i) / 180 * Math.PI);  //x
        // var newLng = pos.lng() + -(Math.random() * 0.0005).toFixed(4) * Math.sin((+a*i) / 180 * Math.PI);

        // markers.add(
        //   Marker(
        //       markerId: MarkerId(r.automotiveAdsList![i].id.toString()),
        //       icon: pinLocationIcon,
        //       position: LatLng(
        //           double.parse(r.automotiveAdsList![i].latitude.toString()),
        //           // double.parse(r.automotiveAdsList![i].latitude.toString()),
        //           double.parse(r.automotiveAdsList![i].longitude.toString())),
        //       onTap: () {
        //         setState(() {
        //           customInfoWindowController.addInfoWindow!(
        //             GestureDetector(
        //               onTap: () {
        //                 Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (context) => ProductDetailScreen(
        //                       automotiveProduct: r.automotiveAdsList![i],
        //                       productType: 'Automotive',
        //                     ),
        //                   ),
        //                 );
        //               },
        //               child: Container(
        //                 height: screenHeight * 0.08,
        //                 width: screenWidth * 0.8,
        //                 decoration: BoxDecoration(
        //                   color: CustomAppTheme().primaryColor.withOpacity(0.7),
        //                   borderRadius: BorderRadius.circular(8),
        //                 ),
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(3.0),
        //                   child: Row(
        //                     children: <Widget>[
        //                       Container(
        //                         width: screenWidth * 0.16,
        //                         decoration: BoxDecoration(
        //                           color: CustomAppTheme().lightGreyColor,
        //                           borderRadius: BorderRadius.circular(8),
        //                           image: DecorationImage(
        //                             image: NetworkImage(r.automotiveAdsList![i]
        //                                 .imageMedia![0].image
        //                                 .toString()),
        //                             fit: BoxFit.cover,
        //                           ),
        //                         ),
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.only(left: 10),
        //                         child: Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           mainAxisAlignment:
        //                               MainAxisAlignment.spaceEvenly,
        //                           children: <Widget>[
        //                             SizedBox(
        //                               width: screenWidth * 0.55,
        //                               child: Text(
        //                                 r.automotiveAdsList![i].name.toString(),
        //                                 overflow: TextOverflow.ellipsis,
        //                                 maxLines: 1,
        //                                 style: CustomAppTheme()
        //                                     .normalText
        //                                     .copyWith(
        //                                         fontSize: 12,
        //                                         fontWeight: FontWeight.w600,
        //                                         color: CustomAppTheme()
        //                                             .backgroundColor),
        //                               ),
        //                             ),
        //                             SizedBox(
        //                               width: screenWidth * 0.55,
        //                               child: Text(
        //                                 '${r.automotiveAdsList![i].currency!.code} ${r.automotiveAdsList![i].price}',
        //                                 overflow: TextOverflow.ellipsis,
        //                                 maxLines: 1,
        //                                 style: CustomAppTheme()
        //                                     .normalText
        //                                     .copyWith(
        //                                         fontSize: 12,
        //                                         fontWeight: FontWeight.w600,
        //                                         color: CustomAppTheme()
        //                                             .backgroundColor),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             LatLng(
        //                 double.parse(
        //                     r.automotiveAdsList![i].latitude.toString()),
        //                 double.parse(
        //                     r.automotiveAdsList![i].longitude.toString())),
        //           );
        //         });
        //       }),
        // );
      }
      setState(() {
        isDataFetching = false;
      });
      d('Markers : $markers');
    });
  }


  @override
  void initState() {
    super.initState();
    isDataFetching = true;
    d('Latitude :::: ${iPrefHelper.retrieveUser()!.latitude}');
    // setCustomMapPin();
    if (iPrefHelper.retrieveUser()!.latitude != null &&
        iPrefHelper.retrieveUser()!.latitude!.isNotEmpty) {
      // moveCameraToSavedLocation();
      getNearByAutomotive(
          latitude: double.parse(iPrefHelper.retrieveUser()!.latitude!),
          longitude: double.parse(iPrefHelper.retrieveUser()!.longitude!));
    } else {
      determinePosition();
    }

    points.add(LatLng(double.parse(iPrefHelper.retrieveUser()!.latitude!), double.parse(iPrefHelper.retrieveUser()!.longitude!)));
      // LatLng(double.parse(iPrefHelper.retrieveUser()!.latitude!, double.parse(iPrefHelper.retrieveUser()!.longitude!))),
      // LatLng(double.parse(iPrefHelper.retrieveUser()!.latitude!, double.parse(iPrefHelper.retrieveUser()!.longitude!))),
  }

  List<AutomotiveProductModel> searchAds(String enteredKeyword, List<AutomotiveProductModel> automotiveAds) {
    List<AutomotiveProductModel> results = [];
    results = automotiveAds
        .where((ad) =>
    ad.name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
        .toList();
    return results;
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: med.height * 0.55,
              decoration: BoxDecoration(
                color: CustomAppTheme().lightGreyColor,
              ),
              child: Stack(
                children: <Widget>[

                  FlutterMap(
                    options: MapOptions(
                      // center: points[0],
                      zoom: 5,
                      maxZoom: 15,
                      onTap: (_, __) => _popupController
                          .hideAllPopups(), // Hide popup when the map is tapped.
                    ),
                    children: <Widget>[
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerClusterLayerWidget(
                        options: MarkerClusterLayerOptions(
                          spiderfyCircleRadius: 80,
                          spiderfySpiralDistanceMultiplier: 2,
                          circleSpiralSwitchover: 12,
                          maxClusterRadius: 120,
                          rotate: true,
                          size: const Size(40, 40),
                          anchor: AnchorPos.align(AnchorAlign.center),
                          fitBoundsOptions: const FitBoundsOptions(
                            padding: EdgeInsets.all(50),
                            maxZoom: 15,
                          ),
                          markers: markers,
                          polygonOptions: const PolygonOptions(
                              borderColor: Colors.blueAccent,
                              color: Colors.black12,
                              borderStrokeWidth: 3),
                          popupOptions: PopupOptions(
                              popupState: PopupState(),
                              popupSnap: PopupSnap.markerTop,
                              popupController: _popupController,
                              popupBuilder: (_, marker) => Container(
                                width: 200,
                                height: 100,
                                color: Colors.white,
                                child: GestureDetector(
                                  onTap: () => debugPrint('Popup tap!'),
                                  child: Text(
                                    'Container popup for marker at ${marker.point}',
                                  ),
                                ),
                              )),
                          builder: (context, markers) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue),
                              child: Center(
                                child: Text(
                                  markers.length.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  // GoogleMap(
                  //   mapType: MapType.terrain,
                  //   markers: markers,
                  //   zoomControlsEnabled: false,
                  //   buildingsEnabled: true,
                  //   compassEnabled: false,
                  //   initialCameraPosition: _kGooglePlex,
                  //   onMapCreated: (GoogleMapController controller) {
                  //     _controller.complete(controller);
                  //     customInfoWindowController.googleMapController =
                  //         controller;
                  //   },
                  //   onCameraMove: (position) {
                  //     customInfoWindowController.onCameraMove!();
                  //   },
                  //   onTap: (position) {
                  //     customInfoWindowController.hideInfoWindow!();
                  //   },
                  // ),
                  // CustomInfoWindow(
                  //   controller: customInfoWindowController,
                  //   height: med.height * 0.08,
                  //   width: med.width * 0.8,
                  //   offset: 50,
                  // ),
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 45.0, left: 15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: CustomAppTheme().backgroundColor,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 0.3,
                                blurRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(Icons.arrow_back_ios_rounded,
                              size: 17, color: CustomAppTheme().blackColor),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: med.height * 0.5,
                ),
                Container(
                  height: med.height * 0.5,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: med.height * 0.05,
                        ),
                        SizedBox(
                          width: med.width,
                          height: med.height * 0.048,
                          child: RoundedTextField(
                            controller: searchController,
                            onChanged: (value) {
                              _foundautomotiveAds = searchAds(value, automotiveAds);
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Automotive',
                              style: CustomAppTheme()
                                  .headingText
                                  .copyWith(fontSize: 16),
                            ),
                            const Spacer(),
                            /*Text(
                              'View All',
                              style: CustomAppTheme().normalText.copyWith(fontSize: 12, color: CustomAppTheme().secondaryColor),
                            ),*/
                          ],
                        ),
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        Expanded(
                          child: isDataFetching
                              ? ListView.builder(
                                  itemCount: 4,
                                  padding: const EdgeInsets.only(bottom: 10),
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Shimmer.fromColors(
                                        baseColor:
                                            CustomAppTheme().lightGreyColor,
                                        highlightColor:
                                            CustomAppTheme().backgroundColor,
                                        child: Container(
                                          height: med.height * 0.15,
                                          width: med.width,
                                          decoration: BoxDecoration(
                                            color:
                                                CustomAppTheme().lightGreyColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : _foundautomotiveAds.isEmpty ? const Center(child: Text("No Adds Found")) : ListView.builder(
                                  itemCount: _foundautomotiveAds.length,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(bottom: 10),
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    print(_foundautomotiveAds[index].name);
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProductDetailScreen(
                                              automotiveProduct: _foundautomotiveAds[index],
                                              productType: 'Automotive',
                                            ),
                                          ),
                                        );
                                      },
                                      child: WideProductCard(
                                          automotiveProduct:
                                          _foundautomotiveAds[index]),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // void setCustomMapPin() async {
  //   pinLocationIcon = await BitmapDescriptor.fromAssetImage(
  //       const ImageConfiguration(size: Size(1, 1)),
  //       'assets/images/automotiveLocationMarker.png');
  // }



  // moveCameraToSavedLocation() async {
  //   GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //     target: LatLng(double.parse(iPrefHelper.retrieveUser()!.latitude!),
  //         double.parse(iPrefHelper.retrieveUser()!.longitude!)),
  //     zoom: 12,
  //   )));
  // }

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
      Navigator.pop(context);
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
      Navigator.pop(context);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position);

    // await getCurrentLocation();
    return await Geolocator.getCurrentPosition();
  }

  // Future<void> getCurrentLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   latitude = position.latitude;
  //   longitude = position.longitude;
  //   GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //     target: LatLng(latitude!, longitude!),
  //     zoom: 12,
  //   )));
  //   getNearByAutomotive(latitude: latitude!, longitude: longitude!);
  //   d("Latitude: $latitude and Longitude: $longitude");
  // }
}
