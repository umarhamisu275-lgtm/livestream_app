import 'package:flutter/material.dart';
import 'auth_service.dart';

class VerificationScreen extends StatefulWidget {
  final String userId;
  const VerificationScreen({super.key, required this.userId});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _platformController = TextEditingController();
  final _followersController = TextEditingController();
  final _proofController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _submitVerification() async {
    setState(() => _isLoading = true);
    try {
      int followers = int.tryParse(_followersController.text) ?? 0;
      await _authService.requestCelebrityVerification(
        userId: widget.userId,
        platformName: _platformController.text,
        followers_count: followers,
        proofLink: _proofController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              followers >= 30000
                  ? 'Taya murna! An amince da shafinki na Celebrity nan take.'
                  : 'Sakonku ya isa. Za ku karasa biyan $5 domin kammala verification.',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kuskure ya faru: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Celebrity Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _platformController,
              decoration: const InputDecoration(labelText: 'Dandali (Facebook, TikTok, Instagram)'),
            ),
            TextField(
              controller: _followersController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Yawan Followers (Misali: 35000)'),
            ),
            TextField(
              controller: _proofController,
              decoration: const InputDecoration(labelText: 'Link na Shafta/Profile'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitVerification,
                    child: const Text('Tura Nema'),
                  ),
          ],
        ),
      ),
    );
  }
}
