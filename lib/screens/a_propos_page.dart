import 'package:flutter/material.dart';

class AProposPage extends StatelessWidget {
  const AProposPage({super.key});

  @override
  Widget build(BuildContext context) {
    const vertTp = Color(0xFF386641);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: vertTp,
        foregroundColor: Colors.white,
        title: const Text('À propos d\'AgriSmart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Icon(Icons.agriculture, size: 60, color: vertTp),
              ),
            ),
            const Text(
              'AgriSmart',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: vertTp),
            ),
            const SizedBox(height: 8),
            const Text(
              'Version : 1.0.0',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'AgriSmart est une application mobile de gestion et de suivi des zones agricoles et de contrôle de l\'irrigation en temps réel, développée dans le cadre des TP Flutter à l\'ISET Kébili.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: vertTp,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Retour', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}