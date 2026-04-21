import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biblio_upb/main.dart';

void main() {
  testWidgets('Auth screen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const BibliothequeApp());
    await tester.pump();

    expect(find.text('📚 Bibliothèque UPB'), findsOneWidget);
    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Toggle vers formulaire inscription', (WidgetTester tester) async {
    await tester.pumpWidget(const BibliothequeApp());
    await tester.pump();

    await tester.tap(find.text("Pas de compte ? S'inscrire"));
    await tester.pump();

    expect(find.text('Inscription'), findsOneWidget);
    expect(find.text("S'inscrire"), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Prénom'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Nom'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
  });

  testWidgets('Retour connexion depuis inscription', (WidgetTester tester) async {
    await tester.pumpWidget(const BibliothequeApp());
    await tester.pump();

    final toggleToInscrire = find.text("Pas de compte ? S'inscrire");
    await tester.ensureVisible(toggleToInscrire);
    await tester.tap(toggleToInscrire);
    await tester.pump();

    final toggleToConnexion = find.text('Déjà un compte ? Se connecter');
    await tester.ensureVisible(toggleToConnexion);
    await tester.tap(toggleToConnexion);
    await tester.pump();

    expect(find.text('Connexion'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Identifiant'), findsOneWidget);
  });
}
