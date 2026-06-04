import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_closet_app/product/data/model/user_model.dart';
import 'package:smart_closet_app/product/data/repositories/auth_repository.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/enums/auth_status_enum.dart';
import 'package:smart_closet_app/product/utils/extension/firebase_error_ext.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _repository = AuthRepository();
    _init();
  }

  late final AuthRepository _repository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
  User? _firebaseUser;
  UserModel? _backendUser;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _firebaseUser;
  UserModel? get backendUser => _backendUser;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isLoggedIn => _firebaseUser != null;

  void _init() {
    _auth.authStateChanges().listen((user) async {
      _firebaseUser = user;
      if (user != null) {
        _backendUser = await _repository.syncWithBackend(user);
      } else {
        _backendUser = null;
      }
      notifyListeners();
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    _setLoading();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseUser = credential.user;

      if (_firebaseUser != null) {
        _backendUser = await _repository.syncWithBackend(_firebaseUser!);
      }

      _setSuccess();
    } on FirebaseAuthException catch (e) {
      _setError(e.readableMessageKey);
    } catch (e) {
      _setError(LocaleKeys.errorGeneral);
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      _firebaseUser = credential.user;

      if (_firebaseUser != null) {
        _backendUser = await _repository.register(
          firebaseUid: _firebaseUser!.uid,
          name: name,
          email: email,
        );
      }

      _setSuccess();
    } on FirebaseAuthException catch (e) {
      _setError(e.readableMessageKey);
    } catch (e) {
      _setError(LocaleKeys.errorGeneral);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoading();
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        _status = AuthStatus.idle;
        notifyListeners();
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      _firebaseUser = userCredential.user;

      if (_firebaseUser != null) {
        _backendUser = await _repository.syncWithBackend(_firebaseUser!);
        _backendUser ??= await _repository.register(
          firebaseUid: _firebaseUser!.uid,
          name: _firebaseUser!.displayName ?? '',
          email: _firebaseUser!.email ?? '',
        );
      }

      _setSuccess();
    } on FirebaseAuthException catch (e) {
      _setError(e.readableMessageKey);
    } catch (e) {
      _setError(LocaleKeys.errorGeneral);
    }
  }

  Future<void> updateDisplayName(String name) async {
    _setLoading();
    try {
      await _firebaseUser?.updateDisplayName(name);
      await _firebaseUser?.reload();
      _firebaseUser = _auth.currentUser;
      _setSuccess();
    } catch (e) {
      _setError(LocaleKeys.errorGeneral);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _setLoading();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _setSuccess();
    } on FirebaseAuthException catch (e) {
      _setError(e.readableMessageKey);
    } catch (e) {
      _setError(LocaleKeys.errorGeneral);
    }
  }

  Future<void> signOut() async {
    _setLoading();
    try {
      await _auth.signOut();
      _firebaseUser = null;
      _backendUser = null;
      _setSuccess();
    } catch (e) {
      _setError(e.toString());
    }
  }

  void resetStatus() {
    _status = AuthStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setSuccess() {
    _status = AuthStatus.success;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}
