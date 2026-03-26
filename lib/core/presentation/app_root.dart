import 'package:flutter/material.dart';

import '../../features/todos/presentation/pages/initial_page.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Produtos Fake API',
      theme: ThemeData(useMaterial3: true),
      home: const InitialPage(),
    );
  }
}
