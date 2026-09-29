import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. Zuba Kuɗi a Wallet (Deposit)
  Future<void> fundWallet({
    required String userId,
    required double amount,
    required String currency, // 'NGN' ko 'USD'
    required String reference,
  }) async {
    // Shigar da maganar biyan kudi a teburin transactions
    await _supabase.from('transactions').insert({
      'user_id': userId,
      'amount': amount,
      'currency': currency,
      'transaction_type': 'deposit',
      'status': 'completed',
    });

    // Kara kudin a wallet din mutum
    final userResponse = await _supabase.from('users').select().eq('id', userId).single();
    
    if (currency == 'NGN') {
      double currentBalance = (userResponse['wallet_balance_ngn'] ?? 0.0).toDouble();
      await _supabase.from('users').update({
        'wallet_balance_ngn': currentBalance + amount,
      }).eq('id', userId);
    } else {
      double currentBalance = (userResponse['wallet_balance_usd'] ?? 0.0).toDouble();
      await _supabase.from('users').update({
        'wallet_balance_usd': currentBalance + amount,
      }).eq('id', userId);
    }
  }

  // 2. Yanke Kudin Kiran Sirri (Deduce Call Rate Per Minute)
  Future<bool> chargeForCall({
    required String callerId,
    required String celebrityId,
    required double ratePerMinuteUsd,
  }) async {
    final caller = await _supabase.from('users').select().eq('id', callerId).single();
    double callerUsd = (caller['wallet_balance_usd'] ?? 0.0).toDouble();

    // Idan kudin kiran ba su kai ba, tsarin zai ki yarda
    if (callerUsd < ratePerMinuteUsd) {
      return false;
    }

    // Rage kudi daga wanda ke kira
    await _supabase.from('users').update({
      'wallet_balance_usd': callerUsd - ratePerMinuteUsd,
    }).eq('id', callerId);

    // Mawa Celebrity kudin kiran
    final celeb = await _supabase.from('users').select().eq('id', celebrityId).single();
    double celebUsd = (celeb['wallet_balance_usd'] ?? 0.0).toDouble();
    await _supabase.from('users').update({
      'wallet_balance_usd': celebUsd + ratePerMinuteUsd,
    }).eq('id', celebrityId);

    return true;
  }
}
