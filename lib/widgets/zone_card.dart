import 'package:flutter/material.dart';
import 'package:agrismart/models/zone.dart';

class ZoneCard extends StatelessWidget {
  final Zone zone;
  final VoidCallback onTap;
  final VoidCallback onLongPress; // <--- Exercice 2 sathi (Appui long)
  final VoidCallback onIncrementer;
  final VoidCallback onDecrementer;

  const ZoneCard({
    super.key,
    required this.zone,
    required this.onTap,
    required this.onLongPress,
    required this.onIncrementer,
    required this.onDecrementer,
  });

  @override
  Widget build(BuildContext context) {
    final bool besoin = zone.besoinIrrigation;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: onLongPress, // <--- InkWell var appui long
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zone.nom,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Culture : ${zone.culture}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Humidité : ${zone.humidite.toStringAsFixed(1)}% | Seuil : ${zone.seuil.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: besoin ? Colors.red : Colors.grey[700],
                        fontWeight: besoin ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: onDecrementer,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: onIncrementer,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}