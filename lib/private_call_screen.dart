import 'dart:async';
import 'package:flutter/material.dart';
import 'payment_service.dart';

class PrivateCallScreen extends StatefulWidget {
  final String callerId;
  final String celebrityId;
  final double ratePerMinute; // Misali $3.00

  const PrivateCallScreen({
    super.key,
    required this.callerId,
    required this.celebrityId,
    this.ratePerMinute = 3.00,
  });

  @override
  State<PrivateCallScreen> createState() => _PrivateCallScreenState();
}

class _PrivateCallScreenState extends State<PrivateCallScreen> {
  Timer? _timer;
  int _secondsElapsed = 0;
  final PaymentService _paymentService = PaymentService();

  @override
  void initState() {
    super.initState();
    _startPaidCall();
  }

  void _startPaidCall() {
    // Agogon yanke kudi duk bayan minti 1 (dakika 60)
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) async {
      bool success = await _paymentService.chargeForCall(
        callerId: widget.callerId,
        celebrityId: widget.celebrityId,
        ratePerMinuteUsd: widget.ratePerMinute,
      );

      if (!success) {
        // Idan kudin wallet din mutum ya kare, a katse kiran nan take
        _endCall();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kudinka ya kare! An katse kiran sirri.')),
          );
        }
      } else {
        setState(() => _secondsElapsed += 60);
      }
    });
  }

  void _endCall() {
    _timer?.cancel();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              child: Icon(Icons.person, size: 60),
            ),
            const SizedBox(height: 20),
            const Text(
              'Kiran Sirri Tareda Celebrity',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Kudin Kira: \$${widget.ratePerMinute}/minti',
              style: const TextStyle(color: Colors.amber, fontSize: 16),
            ),
            const SizedBox(height: 40),
            FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: _endCall,
              child: const Icon(Icons.call_end, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
