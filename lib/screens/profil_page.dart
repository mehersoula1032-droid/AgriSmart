import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'a_propos_page.dart';
import 'package:agrismart/providers/auth_provider.dart';

class ProfilPage extends StatelessWidget {
  final int nombreZones;

  const ProfilPage({super.key, required this.nombreZones});

  @override
  Widget build(BuildContext context) {
    final texte = Theme.of(context).textTheme;
    const vertTp = Color(0xFF386641);

    final email = context.select<AuthProvider, String>(
          (a) => a.utilisateur?.email ?? '',
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: vertTp,
        foregroundColor: Colors.white,
        title: const Text('Profil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          const Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Color(0x26386641),
              child: Icon(Icons.agriculture, size: 40, color: vertTp),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Exploitation AgriSmart',
              style: texte.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Center(child: Text(email, style: const TextStyle(color: Colors.grey))),
          const SizedBox(height: 16),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.grass, color: vertTp),
            title: const Text('Zones suivies'),
            trailing: Text(
              '$nombreZones',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline, color: vertTp),
            title: const Text('À propos'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AProposPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Se déconnecter', style: TextStyle(color: Colors.red)),
            onTap: () => _confirmerDeconnexion(context),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmerDeconnexion(BuildContext context) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
    if (confirme != true || !context.mounted) return;
    await context.read<AuthProvider>().deconnexion();
  }
}