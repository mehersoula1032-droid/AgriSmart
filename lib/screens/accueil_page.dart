import 'package:flutter/material.dart';
import 'package:agrismart/data/jeu_de_donnees.dart';
import 'package:agrismart/models/zone.dart';
import 'package:agrismart/widgets/fiche_exploitation.dart';
import 'package:agrismart/widgets/resume_exploitation.dart';
import 'package:agrismart/widgets/zone_card.dart';
import 'package:agrismart/widgets/zone_form.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  late List<Zone> _zones;

  @override
  void initState() {
    super.initState();
    _zones = List.from(jeuDeDonnees());
  }

  // Calcul mta' l'humidité moyenne lil FicheExploitation
  double get _humiditeMoyenne {
    if (_zones.isEmpty) return 0.0;
    final total = _zones.fold(0.0, (sum, z) => sum + z.humidite);
    return total / _zones.length;
  }

  void _ouvrirFormulaire({Zone? zone}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: ZoneForm(
            zone: zone,
            onEnregistrer: (zoneEnregistree) {
              setState(() {
                if (zone == null) {
                  _zones.add(zoneEnregistree);
                } else {
                  final index = _zones.indexOf(zone);
                  if (index != -1) {
                    _zones[index] = zoneEnregistree;
                  }
                }
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    zone == null
                        ? 'Zone ajoutée avec succès'
                        : 'Zone modifiée avec succès',
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Exercice 2 — Confirmation de suppression (AlertDialog)
  void _confirmerSuppression(Zone zone) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Supprimer la zone ${zone.nom} ?'),
        content: const Text('Voulez-vous vraiment supprimer cette zone ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _zones.remove(zone);
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Zone ${zone.nom} supprimée')),
              );
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriSmart'),
        backgroundColor: Colors.lightGreen[200],
      ),
      body: Column(
        children: [
          // 1. FicheExploitation
          FicheExploitation(humiditeMoyenne: _humiditeMoyenne),

          // 2. ResumeExploitation
          ResumeExploitation(zones: _zones),

          Expanded(
            child: ListView.builder(
              itemCount: _zones.length,
              itemBuilder: (context, index) {
                final zone = _zones[index];
                return ZoneCard(
                  zone: zone,
                  onTap: () => _ouvrirFormulaire(zone: zone),
                  onLongPress: () => _confirmerSuppression(zone),
                  onIncrementer: () {
                    setState(() {
                      zone.humidite = (zone.humidite + 5).clamp(0.0, 100.0);
                    });
                  },
                  onDecrementer: () {
                    setState(() {
                      zone.humidite = (zone.humidite - 5).clamp(0.0, 100.0);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ouvrirFormulaire(),
        child: const Icon(Icons.add),
      ),
    );
  }
}