import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../session/auth_session.dart';
import '../../features/todos/presentation/pages/initial_page.dart';
import '../../features/todos/presentation/pages/todos_page.dart';

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DummyJSON Produtos',
      theme: ThemeData(useMaterial3: true),
      home: session.isBootstrapping
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : session.isAuthenticated
              ? const TodosPage()
              : const LoginPage(),
    );
  }
}
