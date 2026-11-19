class Zone {
  final String nom;
  final String culture;
  double humidite;
  final double seuil;

  Zone(
      this.nom,
      this.culture,
      this.humidite,
      this.seuil, {
        bool? vanneOuverte, // Paramètre optionnel pour garder la compatibilité
      });

  // La vanne s'ouvre automatiquement dès que l'humidité est inférieure au seuil
  bool get vanneOuverte => humidite < seuil;
  bool get besoinIrrigation => humidite < seuil;

  // 👇 Exercice 4: ToJson 👇
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'culture': culture,
      'humidite': humidite,
      'seuil': seuil,
    };
  }

  // 👇 Exercice 4: FromJson 👇
  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      json['nom'] as String,
      json['culture'] as String,
      (json['humidite'] as num).toDouble(),
      (json['seuil'] as num).toDouble(),
    );
  }
}

double humiditeMoyenne(List<Zone> zones) {
  if (zones.isEmpty) return 0;

  double somme = 0;

  for (final z in zones) {
    somme += z.humidite;
  }

  return somme / zones.length;
}

String diagnostic(Zone zone) {
  if (zone.besoinIrrigation) {
    return "Besoin d'irrigation";
  }

  return 'Sol correct';
}