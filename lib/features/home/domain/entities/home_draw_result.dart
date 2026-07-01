enum HomeDrawResultType {
  success,
  emptyPool,
  locked,
  busy,
}

class HomeDrawResult {
  const HomeDrawResult({
    required this.type,
    required this.message,
  });

  const HomeDrawResult.success({
    required String message,
  }) : this(type: HomeDrawResultType.success, message: message);

  const HomeDrawResult.emptyPool({
    required String message,
  }) : this(type: HomeDrawResultType.emptyPool, message: message);

  const HomeDrawResult.locked({
    required String message,
  }) : this(type: HomeDrawResultType.locked, message: message);

  const HomeDrawResult.busy({
    required String message,
  }) : this(type: HomeDrawResultType.busy, message: message);

  final HomeDrawResultType type;
  final String message;

  bool get isSuccess => type == HomeDrawResultType.success;
}
