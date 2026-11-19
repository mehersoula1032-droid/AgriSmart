import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrismart/providers/zones_provider.dart';
import 'package:agrismart/providers/meteo_provider.dart'; // 👈 Zid hedha
import 'package:agrismart/theme/app_theme.dart';
import 'package:agrismart/widgets/resume_exploitation.dart';
import '../widgets/meteo_card.dart';

class StatistiquesPage extends StatelessWidget {
  const StatistiquesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final zones = context.watch<ZonesProvider>().zones;

    final tri = [...zones]..sort((a, b) => a.humidite.compareTo(b.humidite));
    final aIrriguer = zones.where((z) => z.besoinIrrigation).length;
    final pourcentage = zones.isEmpty ? 0 : (aIrriguer * 100 / zones.length).round();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Statistiques'),
      ),
      // 👇 Exercice 1: RefreshIndicator 👇
      body: RefreshIndicator(
        onRefresh: () => context.read<MeteoProvider>().charger(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(), // Darouri bch el pull yekhdem
          padding: const EdgeInsets.all(16),
          children: [
            const MeteoCard(),
            if (zones.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('Aucune donnée à afficher')),
              )
            else ...[
              ResumeExploitation(zones: zones),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '$aIrriguer zone(s) sur ${zones.length} à irriguer ($pourcentage%)',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 12),
              Text('Humidité par zone', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final z in tri)
                ListTile(
                  title: Text(z.nom),
                  subtitle: LinearProgressIndicator(
                    value: z.humidite / 100,
                    color: z.besoinIrrigation ? AppTheme.echec : AppTheme.succes,
                  ),
                  trailing: Text('${z.humidite.toStringAsFixed(0)} %'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}