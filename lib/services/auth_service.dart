import 'package:agrismart/models/utilisateur.dart';

// Erreur d'authentification, avec un message lisible par l'utilisateur
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
}

// Contrat commun : AuthProvider ne connait que cette classe.
abstract class AuthService {
  Stream<Utilisateur?> get utilisateur;

  Future<void> connexion(String email, String motDePasse);
  Future<void> inscription(String email, String motDePasse);
  Future<void> reinitialiserMotDePasse(String email);
  Future<void> deconnexion();
}