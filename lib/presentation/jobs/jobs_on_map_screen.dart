import 'dart:async';
import 'dart:ui';

import 'package:app/common/logger/log.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/searched_textfield.dart';
import 'package:app/presentation/utils/widgets/wide_product_card_widget.dart';
import 'package:app/presentation/widgets_screens/product_detail_screen.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class JobsOnMapScreen extends StatefulWidget {
  const JobsOnMapScreen({Key? key}) : super(key: key);

  @override
  State<JobsOnMapScreen> createState() => _JobsOnMapScreenState();
}

class _JobsOnMapScreenState extends State<JobsOnMapScreen> with BaseMixin {
  TextEditingController searchController = TextEditingController();
  late BitmapDescriptor pinLocationIcon;
  Set<Marker> markers = {};
  bool isDataFetching = false;
  List<JobProductModel> jobAds = [];
  List<JobProductModel> _foundJobAds = [];

  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.5204, 74.3587),
    zoom: 14.4746,
  );

  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  double? latitude, longitude;

  void getNearByJobs(
      {required double latitude, required double longitude}) async {
    var screenHeight = window.physicalSize.height / window.devicePixelRatio;
    var screenWidth = window.physicalSize.width / window.devicePixelRatio;
    JobViewModel jobViewModel = context.read<JobViewModel>();
    setState(() {
      isDataFetching = true;
    });
    final result = await jobViewModel.getNearByJobs(
        latitude: latitude, longitude: longitude);
    result.fold((l) {}, (r) {
      d('NEAR BY PROPERTY ADS : ${r.jobAdsList}');
      jobAds = r.jobAdsList!;
      _foundJobAds = jobAds;
      jobViewModel.changeNearByJobs(r.jobAdsList!);
      d('NEAR BY JOBS LENGTH::::: ${r.jobAdsList!.length}');
      for (int i = 0; i < r.jobAdsList!.length; i++) {
        markers.add(
          Marker(
              markerId: MarkerId(r.jobAdsList![i].id.toString()),
              icon: pinLocationIcon,
              position: LatLng(
                  double.parse(r.jobAdsList![i].latitude.toString()),
                  double.parse(r.jobAdsList![i].longitude.toString())),
              onTap: () {
                setState(() {
                  customInfoWindowController.addInfoWindow!(
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              jobProduct: r.jobAdsList![i],
                              productType: 'Job',
                              isJobAd: true,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: screenHeight * 0.08,
                        width: screenWidth * 0.8,
                        decoration: BoxDecoration(
                          color: CustomAppTheme().primaryColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: screenWidth * 0.16,
                                decoration: BoxDecoration(
                                  color: CustomAppTheme().lightGreyColor,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(r.jobAdsList![i]
                                                    .imageMedia !=
                                                null &&
                                            r.jobAdsList![i].imageMedia!
                                                .isNotEmpty
                                        ? r.jobAdsList![i].imageMedia![0].image
                                            .toString()
                                        : 'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    SizedBox(
                                      width: screenWidth * 0.55,
                                      child: Text(
                                        r.jobAdsList![i].title.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: CustomAppTheme()
                                            .normalText
                                            .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: CustomAppTheme()
                                                    .backgroundColor),
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.55,
                                      child: Text(
                                        '${r.jobAdsList![i].salaryCurrency!.code} ${r.jobAdsList![i].salaryStart} - ${r.jobAdsList![i].salaryEnd}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: CustomAppTheme()
                                            .normalText
                                            .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: CustomAppTheme()
                                                    .backgroundColor),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    LatLng(double.parse(r.jobAdsList![i].latitude.toString()),
                        double.parse(r.jobAdsList![i].longitude.toString())),
                  );
                });
              }
              // infoWindow: InfoWindow(
              //   title: r.propertyProductList![i].name,
              //   snippet: r.propertyProductList![i].streetAddress,
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => ProductDetailScreen(
              //           propertyProduct: r.propertyProductList![i],
              //           productType: 'Property',
              //         ),
              //       ),
              //     );
              //   },
              // ),
              ),
        );
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
    d('Latitidue :::: ${iPrefHelper.retrieveUser()!.latitude}');
    setCustomMapPin();
    if (iPrefHelper.retrieveUser()!.latitude != null &&
        iPrefHelper.retrieveUser()!.latitude!.isNotEmpty) {
      moveCameraToSavedLocation();
      getNearByJobs(
          latitude: double.parse(iPrefHelper.retrieveUser()!.latitude!),
          longitude: double.parse(iPrefHelper.retrieveUser()!.longitude!));
    } else {
      determinePosition();
    }
  }

  List<JobProductModel> searchAds(String enteredKeyword, List<JobProductModel> jobAds) {
    List<JobProductModel> results = [];
    results = jobAds
        .where((ad) =>
        ad.title!.toLowerCase().contains(enteredKeyword.toLowerCase()))
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
                children: [
                  GoogleMap(
                    mapType: MapType.terrain,
                    markers: markers,
                    zoomControlsEnabled: false,
                    buildingsEnabled: true,
                    compassEnabled: false,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      customInfoWindowController.googleMapController =
                          controller;
                    },
                    onCameraMove: (position) {
                      customInfoWindowController.onCameraMove!();
                    },
                    onTap: (position) {
                      customInfoWindowController.hideInfoWindow!();
                    },
                  ),
                  CustomInfoWindow(
                    controller: customInfoWindowController,
                    height: med.height * 0.08,
                    width: med.width * 0.8,
                    offset: 50,
                  ),
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 45.0, left: 15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.all(3),
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

                              setState(() {
                                _foundJobAds = searchAds(value, jobAds);
                                print(_foundJobAds.length);
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Jobs',
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
                              : _foundJobAds.isEmpty ? const Center(child: Text("No Ads Found")) :ListView.builder(
                                  itemCount: _foundJobAds.length,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(bottom: 10),
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    print(_foundJobAds[index].title);
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailScreen(
                                              jobProduct: _foundJobAds[index],
                                              productType: 'Job',
                                              isJobAd: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: WideProductCard(
                                          jobProduct: _foundJobAds[index]),
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

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(1, 1)),
        'assets/images/jobLocationMarker.png');
  }

  moveCameraToSavedLocation() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(double.parse(iPrefHelper.retrieveUser()!.latitude!),
          double.parse(iPrefHelper.retrieveUser()!.longitude!)),
      zoom: 12,
    )));
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
      zoom: 12,
    )));
    getNearByJobs(latitude: latitude!, longitude: longitude!);
    d("Latitude: $latitude and Longitude: $longitude");
  }
}
