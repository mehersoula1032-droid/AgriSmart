import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:agrismart/main.dart';
import 'package:agrismart/providers/auth_provider.dart';
import 'package:agrismart/providers/zones_provider.dart';
import 'package:agrismart/services/auth_locale_service.dart';

void main() {
  testWidgets('Au démarrage, on voit l\'écran de connexion',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (_) => AuthProvider(AuthLocaleService())),
              ChangeNotifierProvider(create: (_) => ZonesProvider()),
            ],
            child: const AgriSmartApp(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Se connecter'), findsOneWidget);
      });
}