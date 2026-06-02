import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';

extension FirebaseErrorExtension on FirebaseAuthException {
  // Locale key döndürür — kullanım noktasında .tr() çağrılmalı
  String get readableMessageKey {
    switch (code) {
      case 'user-not-found':
        return LocaleKeys.errorUserNotFound;
      case 'wrong-password':
      case 'invalid-credential':
        return LocaleKeys.errorInvalidCredentials;
      case 'email-already-in-use':
        return LocaleKeys.errorEmailInUse;
      case 'weak-password':
        return LocaleKeys.errorWeakPassword;
      case 'invalid-email':
        return LocaleKeys.validationEmailInvalid;
      case 'network-request-failed':
        return LocaleKeys.errorNoInternet;
      default:
        return LocaleKeys.errorGeneral;
    }
  }
}
