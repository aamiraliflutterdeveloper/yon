class GetNotificationEntities {
  final String device;
  final int page;

  const GetNotificationEntities({
    required this.device,
    required this.page,
  });

  Map<String, dynamic> toMap() {
    return {
      'device': device,
      'page': page,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is GetNotificationEntities && runtimeType == other.runtimeType && device == other.device && page == other.page;

  @override
  int get hashCode => device.hashCode ^ page.hashCode;
}
