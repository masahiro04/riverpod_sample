// import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_sample/main.dart';
import 'package:riverpod_sample/provider.dart';
import 'package:riverpod_sample/view_model.dart';

class MockViewModel extends Mock implements ViewModel {}

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  const iPhone55 = Device(
    size: Size(414, 736),
    name: 'iPhone55',
    devicePixelRatio: 3.0,
  );

  List<Device> devices = [iPhone55];
  ViewModel viewmodel = ViewModel();

  testGoldens('nomal', (tester) async {
    await tester.pumpWidgetBuilder(ProviderScope(child: Home(viewmodel)));
    await multiScreenGolden(tester, 'home_onInit', devices: devices);

    await tester.tap(find.byIcon(CupertinoIcons.plus));
    await tester.tap(find.byIcon(CupertinoIcons.plus));
    await tester.tap(find.byIcon(CupertinoIcons.minus));
    await tester.pump();

    await multiScreenGolden(tester, 'home_tapped', devices: devices);
  });

  testGoldens('viewModelTtest', (tester) async {
    var mock = MockViewModel();
    when(() => mock.count).thenReturn(123456789.toString());
    when(() => mock.countUp).thenReturn(223456789.toString());
    when(() => mock.countDown).thenReturn(323456789.toString());

    final mockTitleProvider = Provider<String>((ref) => 'mockTitle');
    final mockMessageProvider = Provider<String>((ref) => 'mockMessage');

    await tester.pumpWidgetBuilder(ProviderScope(
      child: Home(mock),
      overrides: [
        titleProvider.overrideWithProvider(mockTitleProvider),
        messageProvider.overrideWithProvider(mockMessageProvider),
      ],
    ));
    await multiScreenGolden(tester, 'home_mock', devices: devices);

    verifyNever(() => mock.onIncrease());
    verifyNever(() => mock.onDecrease());
    verifyNever(() => mock.onReset());

    await tester.tap(find.byIcon(CupertinoIcons.plus));
    verify(() => mock.onIncrease()).called(1);
    verifyNever(() => mock.onDecrease());
    verifyNever(() => mock.onReset());

    await tester.tap(find.byIcon(CupertinoIcons.minus));
    verifyNever(() => mock.onIncrease());
    verify(() => mock.onDecrease()).called(1);
    verifyNever(() => mock.onReset());

    await tester.tap(find.byIcon(Icons.refresh));
    verifyNever(() => mock.onIncrease());
    verifyNever(() => mock.onDecrease());
    verify(() => mock.onReset()).called(1);
  });
}
