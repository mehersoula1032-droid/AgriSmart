import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrismart/providers/zones_provider.dart';
import 'package:agrismart/screens/zones_page.dart';
import 'package:agrismart/screens/statistiques_page.dart';
import 'package:agrismart/screens/profil_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final zonesProvider = context.watch<ZonesProvider>();
    final nombreZones = zonesProvider.zones.length;

    // N-hsbou el zones elli t-h-taji irrigation
    final aIrriguerCount = zonesProvider.zones.where((z) => z.besoinIrrigation).length;

    final pages = [
      const ZonesPage(),
      const StatistiquesPage(),
      ProfilPage(nombreZones: nombreZones),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF386641),
        items: [
          BottomNavigationBarItem(
            // 🛠️ St'amliyna Badge standard men ghir isInitiallyVisible bish t-tna7a el erreur
            icon: aIrriguerCount > 0
                ? Badge(
              label: Text('$aIrriguerCount'),
              child: const Icon(Icons.grass),
            )
                : const Icon(Icons.grass),
            label: 'Zones',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistiques',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}