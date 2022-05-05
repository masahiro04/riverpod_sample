import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_sample/data/count_data.dart';
import 'package:riverpod_sample/logic/button_animation_logic.dart';
import 'package:riverpod_sample/logic/count_data_changed_notifier.dart';
import 'package:riverpod_sample/logic/logic.dart';
import 'package:riverpod_sample/logic/sound_logic.dart';
import 'package:riverpod_sample/provider.dart';

class ViewModel {
  final Logic _logic = Logic();
  final SoundLogic _soundLogic = SoundLogic();
  late ButtonAnimationLogic _buttonAnimationLogicPlus;
  late ButtonAnimationLogic _buttonAnimationLogicMinus;
  late ButtonAnimationLogic _buttonAnimationLogicReset;

  late WidgetRef _ref;

  List<CountDataChangedNotifier> notifiers = [];

  void setRef(WidgetRef ref, TickerProvider tickerProvider) {
    _ref = ref;
    _buttonAnimationLogicPlus = ButtonAnimationLogic(tickerProvider);
    _buttonAnimationLogicMinus = ButtonAnimationLogic(tickerProvider);
    _buttonAnimationLogicReset = ButtonAnimationLogic(tickerProvider);
    _soundLogic.load();

    notifiers = [
      _soundLogic,
      _buttonAnimationLogicPlus,
      _buttonAnimationLogicMinus,
      _buttonAnimationLogicReset,
    ];
  }

  get count => _ref.watch(countDataProvider.state).state.count.toString();
  get countUp =>
      _ref.watch(countDataProvider.select((value) => value.countUp)).toString();
  get countDown => _ref
      .watch(countDataProvider.select((value) => value.countDown))
      .toString();

  get animationPlus => _buttonAnimationLogicPlus.animationScale;
  get animationMinus => _buttonAnimationLogicMinus.animationScale;
  get animationReset => _buttonAnimationLogicReset.animationScale;

  void onIncrease() {
    _logic.increase();
    update();
  }

  void onDecrease() {
    _logic.decrease();
    update();
  }

  void onReset() {
    _logic.reset();
    update();
  }

  void update() {
    CountData oldValue = _ref.watch(countDataProvider.state).state;
    _ref.watch(countDataProvider.state).state = _logic.countData;
    CountData newValue = _ref.watch(countDataProvider.state).state;

    notifiers.forEach((element) => element.valueChanged(oldValue, newValue));
  }
}
