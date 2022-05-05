import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_sample/data/count_data.dart';
import 'package:riverpod_sample/logic/count_data_changed_notifier.dart';

class SoundLogic with CountDataChangedNotifier {
  static const SOUND_DATA_UP = 'sounds/up.mp3';
  static const SOUND_DATA_DOWN = 'sounds/down.mp3';
  static const SOUND_DATA_RESET = 'sounds/reset.mp3';

  final AudioCache _cache = AudioCache(
    fixedPlayer: AudioPlayer(),
  );

  void load() {
    _cache.loadAll([SOUND_DATA_UP, SOUND_DATA_DOWN, SOUND_DATA_RESET]);
  }

  @override
  void valueChanged(CountData oldValue, CountData newValue) {
    if (newValue.countUp == 0 &&
        newValue.countDown == 0 &&
        newValue.count == 0) {
      playResetSound();
    } else if (oldValue.countUp + 1 == newValue.countUp) {
      playUpSound();
    } else if (oldValue.countDown + 1 == newValue.countDown) {
      playDownSound();
    }
  }

  void playUpSound() {
    _cache.play(SOUND_DATA_UP);
  }

  void playDownSound() {
    _cache.play(SOUND_DATA_DOWN);
  }

  void playResetSound() {
    _cache.play(SOUND_DATA_RESET);
  }
}
