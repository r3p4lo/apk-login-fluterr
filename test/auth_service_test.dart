import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_login/services/auth_service.dart';

void main() {
  group('AuthService.errorMessage', () {
    test('menerjemahkan email yang sudah terdaftar', () {
      final error = FirebaseAuthException(code: 'email-already-in-use');

      expect(
        AuthService.errorMessage(error),
        'Email ini sudah terdaftar. Silakan login.',
      );
    });

    test('menerjemahkan kredensial login yang salah', () {
      final error = FirebaseAuthException(code: 'invalid-credential');

      expect(AuthService.errorMessage(error), 'Email atau password salah.');
    });

    test('menerjemahkan kegagalan jaringan', () {
      final error = FirebaseAuthException(code: 'network-request-failed');

      expect(
        AuthService.errorMessage(error),
        'Tidak dapat terhubung. Periksa koneksi internet Anda.',
      );
    });
  });
}
