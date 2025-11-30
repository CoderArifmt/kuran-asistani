import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class TimeService {
  DateTime get now;
}

class RealTimeService implements TimeService {
  @override
  DateTime get now => DateTime.now();
}

final timeServiceProvider = Provider<TimeService>((ref) => RealTimeService());
