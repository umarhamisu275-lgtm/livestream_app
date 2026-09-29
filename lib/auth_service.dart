import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. Yi Sign Up / Login ta Email
  Future<AuthResponse> signUpUser({required String email, required String password, required String fullName, required String username}) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'username': username,
      },
    );

    if (response.user != null) {
      // Shigar da sabon mutum a teburin users
      await _supabase.from('users').insert({
        'id': response.user!.id,
        'full_name': fullName,
        'username': username,
        'email': email,
      });
    }

    return response;
  }

  // 2. Tsarin Neman Celebrity Verification (Dokar 30k Followers ko Biyan Kudi)
  Future<void> requestCelebrityVerification({
    required String userId,
    required String platformName,
    required int followersCount,
    required String proofLink,
  }) async {
    bool isQualifiedFree = followersCount >= 30000;

    await _supabase.from('verification_requests').insert({
      'user_id': userId,
      'platform_name': platformName,
      'followers_count': followersCount,
      'proof_link': proofLink,
      'payment_status': isQualifiedFree ? 'free_qualified' : 'pending_payment',
      'amount_paid': isQualifiedFree ? 0.00 : 5.00, // $5 ko dai-daitonsa idan bashi da 30k followers
      'is_approved': isQualifiedFree, // Idan ya cika 30k ana amince masa nan take
    });

    if (isQualifiedFree) {
      // Maida mutum Celebrity a teburin users
      await _supabase.from('users').update({'is_celebrity': true}).eq('id', userId);
    }
  }
}
