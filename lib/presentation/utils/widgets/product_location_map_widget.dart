import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProductLocationMapWidget extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  const ProductLocationMapWidget({Key? key, this.latitude = 31.5204, this.longitude = 74.3587}) : super(key: key);

  @override
  State<ProductLocationMapWidget> createState() => _ProductLocationMapWidgetState();
}

class _ProductLocationMapWidgetState extends State<ProductLocationMapWidget> {
  final markers = <Marker>{};
  MarkerId markerId = const MarkerId("YOUR-MARKER-ID");

  final Completer<GoogleMapController> _controller = Completer();
  static CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(31.5204, 74.3587),
    zoom: 10.4746,
  );

  late BitmapDescriptor classifiedLocationPin;
  late BitmapDescriptor propertyLocationPin;
  late BitmapDescriptor automotiveLocationPin;
  late BitmapDescriptor jobLocationPin;

  void setCustomPropertyPin() async {
    propertyLocationPin =
        await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(1, 1)), 'assets/images/propertyLocationMarker.png');
  }

  @override
  Widget build(BuildContext context) {
    _kGooglePlex = CameraPosition(target: LatLng(widget.latitude!, widget.longitude!), zoom: 14.4746);
    Size med = MediaQuery.of(context).size;
    return SizedBox(
      height: med.height * 0.15,
      width: med.width,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GoogleMap(
            mapType: MapType.terrain,
            zoomControlsEnabled: false,
            markers: markers,
            buildingsEnabled: true,
            zoomGesturesEnabled: true,
            compassEnabled: false,
            mapToolbarEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            trafficEnabled: true,
            liteModeEnabled: true,
            indoorViewEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setState(() {
                markers.add(Marker(markerId: markerId, position: LatLng(widget.latitude!, widget.longitude!)));
              });
            },
          ),
        ),
      ),
    );
  }
}
