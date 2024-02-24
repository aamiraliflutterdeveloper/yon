class ModuleEntities {
  final String module;

  const ModuleEntities({
    required this.module,
  });

  Map<String, dynamic> toMap() {
    return {
      'module_name': module,
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ModuleEntities && runtimeType == other.runtimeType && module == other.module;

  @override
  int get hashCode => module.hashCode;
}
