import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrismart/models/zone.dart';
import 'package:agrismart/providers/zones_provider.dart';
import 'package:agrismart/providers/meteo_provider.dart'; // 👈 Zid hedha
import 'package:agrismart/screens/zone_form_page.dart';

class ZoneDetailPage extends StatelessWidget {
  final String zoneNom;

  const ZoneDetailPage({
    super.key,
    required this.zoneNom,
  });

  Future<void> _modifier(BuildContext context, Zone zone) async {
    final zonesProvider = context.read<ZonesProvider>();
    final nomsAutres = zonesProvider.zones
        .where((z) => z.nom != zone.nom)
        .map((z) => z.nom)
        .toList();

    final nouvelle = await Navigator.push<Zone>(
      context,
      MaterialPageRoute(
        builder: (context) => ZoneFormPage(
          zone: zone,
          nomsExistants: nomsAutres,
        ),
      ),
    );

    if (nouvelle == null || !context.mounted) return;
    zonesProvider.remplacer(zone, nouvelle);
  }

  @override
  Widget build(BuildContext context) {
    final zonesProvider = context.watch<ZonesProvider>();

    final zone = zonesProvider.zones.firstWhere(
          (z) => z.nom == zoneNom,
      orElse: () => zonesProvider.zones.first,
    );

    final couleur = zone.besoinIrrigation ? Colors.red : Colors.green;
    final longueur = zone.culture.length < 4 ? zone.culture.length : 4;
    final texte = Theme.of(context).textTheme;
    const vertTp = Color(0xFF386641);

    // 👇 Exercice 3: N-jibou l-meteo bch n7esbou el conseil 👇
    final meteoProvider = context.watch<MeteoProvider>();
    String conseilZone = '';
    if (meteoProvider.etat == EtatMeteo.succes && meteoProvider.meteo != null) {
      if (zone.besoinIrrigation) {
        if (meteoProvider.meteo!.pluieTotale >= 5) {
          conseilZone = 'Attendre la pluie';
        } else {
          conseilZone = 'Irriguer maintenant';
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: vertTp,
        foregroundColor: Colors.white,
        title: Text(zone.nom),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: vertTp.withOpacity(0.15),
                child: Text(
                  zone.culture.isNotEmpty ? zone.culture.substring(0, longueur) : '',
                  style: const TextStyle(color: vertTp, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(zone.nom, style: texte.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text(zone.culture, style: texte.bodyLarge?.copyWith(color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              '${zone.humidite.toStringAsFixed(0)} %',
              style: texte.displayMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: zone.humidite / 100,
            color: couleur,
            backgroundColor: Colors.grey[200],
            minHeight: 12,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              zone.besoinIrrigation ? 'À irriguer' : 'Sol correct',
              style: TextStyle(color: couleur, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          // 👇 Exercice 3: N-affichew el conseil houni 👇
          if (conseilZone.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  conseilZone,
                  style: TextStyle(
                    color: conseilZone == 'Attendre la pluie' ? Colors.blue : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 32),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Humidité actuelle'),
                  trailing: Text('${zone.humidite.toStringAsFixed(0)} %', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Seuil d\'irrigation'),
                  trailing: Text('${zone.seuil.toStringAsFixed(0)} %', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Vanne'),
                  trailing: Text(
                    zone.vanneOuverte ? 'Ouverte' : 'Fermée',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: zone.vanneOuverte ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: vertTp,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: () => _modifier(context, zone),
              child: const Text('Modifier cette zone', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}