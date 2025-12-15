import 'package:injectable/injectable.dart';

abstract class IDateTimeProvider {
  DateTime get now;
}

@Singleton(as: IDateTimeProvider)
class SystemDateTimeProvider implements IDateTimeProvider {
  @override
  DateTime get now => DateTime.now();
}
