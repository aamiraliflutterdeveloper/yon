class LatLongEntities {
  final double latitude;
  final double longitude;

  const LatLongEntities({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'lat': latitude,
      'long': longitude,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLongEntities && runtimeType == other.runtimeType && latitude == other.latitude && longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
