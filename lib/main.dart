import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_sample/data/count_data.dart';
import 'package:riverpod_sample/provider.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  // NOTE(okubo): ConsumerStateのなかでrefが定義されているので、シンプルにできる
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.watch(titleProvider)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(ref.watch(messageProvider).toString()),
            Text(ref.watch(countDataProvider.state).state.count.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    CountData countData =
                        ref.read(countDataProvider.state).state;
                    ref.read(countDataProvider.state).state =
                        countData.copyWith(
                            count: countData.count + 1,
                            countUp: countData.countUp + 1);
                  },
                  child: const Icon(CupertinoIcons.plus),
                ),
                FloatingActionButton(
                  onPressed: () {
                    CountData countData =
                        ref.read(countDataProvider.state).state;
                    ref.read(countDataProvider.state).state =
                        countData.copyWith(
                            count: countData.count - 1,
                            countDown: countData.countDown + 1);
                  },
                  child: const Icon(CupertinoIcons.minus),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(ref
                    .watch(countDataProvider.select((value) => value.countUp))
                    .toString()),
                Text(ref
                    .watch(countDataProvider.select((value) => value.countDown))
                    .toString()),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var testData = const CountData(count: 0, countUp: 0, countDown: 0);
          ref.read(countDataProvider.state).state = testData;
        },
        tooltip: 'Increment',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
