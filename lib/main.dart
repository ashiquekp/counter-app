import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/hive_keys.dart';
import 'views/login_page.dart';
import 'views/home_page.dart';
import 'viewmodels/auth_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(HiveKeys.users);
  await Hive.openBox(HiveKeys.session);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo);
    return MaterialApp(
      title: 'Counter App',
      theme: theme,
      home: const RootGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RootGate extends ConsumerWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authViewModelProvider);
    if (user == null) {
      return const LoginPage();
    }
    return const HomePage();
  }
}
