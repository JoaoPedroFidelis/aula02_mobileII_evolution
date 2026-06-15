import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_refatoracao_baguncado/core/presentation/app_root.dart';

void main() {
  testWidgets('Mostra tela de login quando não autenticado', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AppRoot()));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
