import 'package:flutter/foundation.dart';
import 'package:agrismart/models/meteo.dart';
import 'package:agrismart/services/meteo_service.dart';

// Les trois etats d'un chargement reseau
enum EtatMeteo { chargement, succes, erreur }

class MeteoProvider extends ChangeNotifier {
  final MeteoService _service;

  MeteoProvider({MeteoService? service}) : _service = service ?? MeteoService();

  EtatMeteo _etat = EtatMeteo.chargement;
  Meteo? _meteo;
  String _erreur = '';

  // 👇 Exercice 2: Heure 👇
  DateTime? _derniereMiseAJour;

  EtatMeteo get etat => _etat;
  Meteo? get meteo => _meteo;
  String get erreur => _erreur;
  DateTime? get derniereMiseAJour => _derniereMiseAJour; // 👈 Exercice 2

  Future<void> charger() async {
    _etat = EtatMeteo.chargement;
    notifyListeners();

    try {
      _meteo = await _service.charger();
      _derniereMiseAJour = DateTime.now(); // 👈 Exercice 2: On enregistre le temps
      _etat = EtatMeteo.succes;
    } on MeteoException catch (e) {
      _erreur = e.message;
      _etat = EtatMeteo.erreur;
    } catch (_) {
      _erreur = 'Erreur inattendue';
      _etat = EtatMeteo.erreur;
    }
    notifyListeners();
  }
}