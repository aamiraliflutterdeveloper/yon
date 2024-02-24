class PlatformEntity {
  late final String platform;

  PlatformEntity({required this.platform});

  Map<String, dynamic> toMap() {
    return {
      'platform': platform,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PlatformEntity && runtimeType == other.runtimeType && platform == other.platform;

  @override
  int get hashCode => platform.hashCode;
}
