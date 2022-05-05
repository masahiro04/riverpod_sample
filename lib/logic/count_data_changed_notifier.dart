import 'package:riverpod_sample/data/count_data.dart';

abstract class CountDataChangedNotifier {
  void valueChanged(CountData oldValue, CountData newValue);
}
