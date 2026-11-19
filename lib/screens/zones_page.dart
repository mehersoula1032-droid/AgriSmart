import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrismart/models/zone.dart';
import 'package:agrismart/providers/zones_provider.dart';
import 'package:agrismart/screens/zone_detail_page.dart';
import 'package:agrismart/screens/zone_form_page.dart';
import 'package:agrismart/widgets/fiche_exploitation.dart';
import 'package:agrismart/widgets/resume_exploitation.dart';
import 'package:agrismart/widgets/zone_card.dart';

class ZonesPage extends StatelessWidget {
  const ZonesPage({super.key});

  void _message(BuildContext context, String texte) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texte)),
    );
  }

  Future<void> _ajouter(BuildContext context) async {
    final noms = context.read<ZonesProvider>().noms();
    final nouvelle = await Navigator.push<Zone>(
      context,
      MaterialPageRoute(
        builder: (_) => ZoneFormPage(nomsExistants: noms),
      ),
    );
    if (nouvelle == null || !context.mounted) return;
    context.read<ZonesProvider>().ajouter(nouvelle);
    _message(context, 'Zone ajoutée');
  }

  Future<void> _ouvrirDetail(BuildContext context, Zone zone) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ZoneDetailPage(zoneNom: zone.nom),
      ),
    );
  }

  Future<void> _confirmerSuppression(BuildContext context, Zone zone) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la zone ?'),
        content: Text('La zone ${zone.nom} sera supprimée définitivement.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirme != true || !context.mounted) return;
    context.read<ZonesProvider>().supprimer(zone);
    _message(context, 'Zone supprimée');
  }

  Widget _carte(BuildContext context, Zone zone) {
    final provider = context.read<ZonesProvider>();
    return ZoneCard(
      zone: zone,
      onIncrementer: () => provider.modifierHumidite(zone, 5),
      onDecrementer: () => provider.modifierHumidite(zone, -5),
      onTap: () => _ouvrirDetail(context, zone),
      onLongPress: () => _confirmerSuppression(context, zone),
    );
  }

  @override
  Widget build(BuildContext context) {
    final zones = context.watch<ZonesProvider>().zones;

    // 🛠️ El vert el s7iḥ wel wa7id mta' el TP (Color(0xFF386641)) l'application l-kol
    const vertTp = Color(0xFF386641);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriSmart', style: TextStyle(color: Colors.white)),
        backgroundColor: vertTp,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: vertTp,
        onPressed: () => _ajouter(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          FicheExploitation(humiditeMoyenne: humiditeMoyenne(zones)),
          ResumeExploitation(zones: zones),
          Expanded(
            child: zones.isEmpty
                ? const Center(child: Text('Aucune zone pour le moment'))
                : ListView.separated(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: zones.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) => _carte(context, zones[index]),
            ),
          ),
        ],
      ),
    );
  }
}