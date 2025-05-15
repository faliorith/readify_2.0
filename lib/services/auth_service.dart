import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, User, UserCredential;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _auth = firebaseAuth,
        _firestore = firestore;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Получение профиля пользователя
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Ошибка получения данных: ${e.toString()}');
    }
  }

  // Вход
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      if (!EmailValidator.validate(email)) {
        throw Exception('Неверный email');
      }

      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Ошибка входа: ${e.toString()}');
    }
  }

  // Регистрация
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password, {
    String? name,
  }) async {
    try {
      if (!EmailValidator.validate(email)) {
        throw Exception('Неверный email');
      }

      if (password.length < 6) {
        throw Exception('Пароль слишком короткий');
      }

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (credential.user == null) {
        throw Exception('Ошибка создания пользователя');
      }

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': email.trim(),
        'name': name?.trim() ?? email.split('@')[0],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'emailVerified': false,
      });

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Ошибка регистрации: ${e.toString()}');
    }
  }

  // Выход из аккаунта
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Ошибка выхода: ${e.toString()}');
    }
  }

  // Сброс пароля
  Future<void> resetPassword(String email) async {
    try {
      if (!EmailValidator.validate(email)) {
        throw Exception('Неверный формат email');
      }

      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      throw Exception('Ошибка сброса пароля: ${e.toString()}');
    }
  }

  // Обновление профиля пользователя
  Future<void> updateProfile({
    required String userId,
    String? name,
    String? photoUrl,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) updates['name'] = name.trim();
      if (photoUrl != null) updates['photoUrl'] = photoUrl.trim();

      await _firestore.collection('users').doc(userId).update(updates);
    } catch (e) {
      throw Exception('Ошибка обновления профиля: ${e.toString()}');
    }
  }

  // Отправка письма с верификацией email
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw Exception('Ошибка отправки письма: ${e.toString()}');
    }
  }

  // Принудительное обновление данных пользователя из Firebase
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
    } catch (e) {
      throw Exception('Ошибка обновления пользователя: ${e.toString()}');
    }
  }

  // Обработка ошибок Firebase Auth
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('Пользователь не найден');
      case 'wrong-password':
        return Exception('Неверный пароль');
      case 'email-already-in-use':
        return Exception('Email уже используется');
      case 'invalid-email':
        return Exception('Неверный формат email');
      case 'weak-password':
        return Exception('Пароль слишком простой');
      case 'user-disabled':
        return Exception('Аккаунт заблокирован');
      case 'operation-not-allowed':
        return Exception('Операция не разрешена');
      case 'too-many-requests':
        return Exception('Слишком много запросов. Попробуйте позже');
      default:
        return Exception('Произошла ошибка: ${e.message}');
    }
  }
}
