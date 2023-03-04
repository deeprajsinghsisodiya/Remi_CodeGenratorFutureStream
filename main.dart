import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'main.g.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

@riverpod
Future<List<String>> fetchItem(FetchItemRef ref, {required int page}) async {
  if (page > 2) return ['a', 'b'];
  await Future.delayed(const Duration(seconds: 3));
  return List.generate(50, (index) => 'Hello $page $index');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Future Stream'),
        ),
        body: ListView.builder(itemBuilder: (context, index) {
          final page = index ~/ 50;
          final itemIndex = index % 50;
          final pageValue = ref.watch(FetchItemProvider(page: page));
          return pageValue.when(
            error: (err, stack) => Text('err $err'),
            loading: () => Text('Looding..'),
            data: (items) {
              return Text(items[itemIndex]);
            },
          );
        }));
  }
}
