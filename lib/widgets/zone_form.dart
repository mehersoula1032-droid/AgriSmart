import 'package:flutter/material.dart';
import 'package:agrismart/models/zone.dart';

class ZoneForm extends StatefulWidget {
  // null ajout d'une nouvelle zone, sinon modification de cette zone
  final Zone? zone;
  final void Function(Zone) onEnregistrer;
  const ZoneForm({super.key, this.zone, required this.onEnregistrer});

  @override
  State<ZoneForm> createState() => _ZoneFormState();
}

class _ZoneFormState extends State<ZoneForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _cultureCtrl = TextEditingController();
  final _humiditeCtrl = TextEditingController();
  final _seuilCtrl = TextEditingController();
  bool get _modeEdition => widget.zone != null;

  @override
  void initState() {
    super.initState();
    final zone = widget.zone;
    if (zone != null) {
      _nomCtrl.text = zone.nom;
      _cultureCtrl.text = zone.culture;
      _seuilCtrl.text = _formater(zone.seuil);
    }
  }

  // 35.0 -> "35" , 32.5 -> "32.5"
  String _formater(double n) {
    return n % 1 == 0 ? n.toStringAsFixed(0) : n.toString();
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _cultureCtrl.dispose();
    _humiditeCtrl.dispose();
    _seuilCtrl.dispose();
    super.dispose();
  }

  // Lit un nombre ("35" ou "35,5"); renvoie null si ce n'est pas un nombre
  double? _lireNombre(String? texte) {
    return double.tryParse((texte ?? '').trim().replaceAll(',', '.'));
  }

  String? _validerTexte(String? valeur) {
    // TODO 1: renvoyer un message si la valeur est vide ou a moins de
    // 2 caracteres (apres trim()), sinon renvoyer null
    if (valeur == null || valeur.trim().length < 2) {
      return 'Le texte doit contenir au moins 2 caractères';
    }
    return null;
  }

  String? _validerPourcentage(String? valeur) {
    // TODO 2: utiliser _lireNombre. Message si ce n'est pas un nombre,
    // message si le nombre est < 0 ou > 100, sinon null
    final nombre = _lireNombre(valeur);
    if (nombre == null) {
      return 'Veuillez saisir un nombre valide';
    }
    if (nombre < 0 || nombre > 100) {
      return 'La valeur doit être comprise entre 0 et 100';
    }
    return null;
  }

  void _soumettre() {
    // TODO 3: si le formulaire n'est pas valide, ne rien faire.
    // Sinon creer une Zone avec les valeurs saisies et
    // appeler widget.onEnregistrer(zone)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nom = _nomCtrl.text.trim();
    final culture = _cultureCtrl.text.trim();
    final seuil = _lireNombre(_seuilCtrl.text) ?? 0.0;

    if (_modeEdition) {
      final ancienne = widget.zone;
      final zoneModifiee = Zone(
        nom,
        culture,
        ancienne?.humidite ?? 0.0,
        seuil,
        vanneOuverte: ancienne?.vanneOuverte ?? false,
      );
      widget.onEnregistrer(zoneModifiee);
    } else {
      final humidite = _lireNombre(_humiditeCtrl.text) ?? 0.0;
      final nouvelleZone = Zone(
        nom,
        culture,
        humidite,
        seuil,
      );
      widget.onEnregistrer(nouvelleZone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _modeEdition ? 'Modifier la zone' : 'Nouvelle zone',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nomCtrl,
              decoration: const InputDecoration(
                labelText: 'Nom de la zone',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              validator: _validerTexte,
            ),
            const SizedBox(height: 12),
            // TODO 4: champ "Culture" (meme principe que le nom)
            TextFormField(
              controller: _cultureCtrl,
              decoration: const InputDecoration(
                labelText: 'Culture',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              validator: _validerTexte,
            ),
            const SizedBox(height: 12),
            // TODO 5: une Row avec deux champs cote a cote, chacun dans
            // un Expanded: "Humidité (%)" et "Seuil (%)",
            // clavier numerique, validator: _validerPourcentage
            if (!_modeEdition) ...[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _humiditeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Humidité (%)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: _validerPourcentage,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _seuilCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Seuil (%)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: _validerPourcentage,
                    ),
                  ),
                ],
              ),
            ] else ...[
              TextFormField(
                controller: _seuilCtrl,
                decoration: const InputDecoration(
                  labelText: 'Seuil (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _validerPourcentage,
              ),
            ],
            const SizedBox(height: 16),
            // TODO 6: un FilledButton "Ajouter" qui appelle soumettre
            FilledButton(
              onPressed: _soumettre,
              child: Text(_modeEdition ? 'Enregistrer' : 'Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}