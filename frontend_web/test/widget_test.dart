import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_web/main.dart';

void main() {
  testWidgets('Auth screen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const BibliothequeWebApp());
    await tester.pump();

    expect(find.text('UPB BIBLIO'), findsOneWidget);
    expect(find.text('ESPACE ADMINISTRATION'), findsOneWidget);
    expect(find.text('ACCÉDER'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Auth screen shows error when identifiant is empty', (WidgetTester tester) async {
    await tester.pumpWidget(const BibliothequeWebApp());
    await tester.pump();

    await tester.tap(find.text('ACCÉDER'));
    await tester.pump();

    expect(find.text('Veuillez entrer votre identifiant'), findsOneWidget);
  });
}
