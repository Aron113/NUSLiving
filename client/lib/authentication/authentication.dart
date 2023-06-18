import 'package:NUSLiving/authentication/authentication_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  AuthResult({required this.status, required this.uid});

  AuthStatus status;
  String uid;
}

class AuthenticationService {
  final auth = FirebaseAuth.instance;
  static late AuthResult result;
  static late AuthStatus _status;

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential loginUser = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (loginUser.user!.emailVerified) {
        //Check that email address is verified
        result =
            AuthResult(status: AuthStatus.successful, uid: loginUser.user!.uid);
      } else {
        result = AuthResult(status: AuthStatus.emailNotVerified, uid: '');
      }
    } on FirebaseAuthException catch (e) {
      AuthStatus exceptionStatus = AuthExceptionHandler.handleAuthException(e);
      result = AuthResult(status: exceptionStatus, uid: '');
    }
    return result;
  }

  Future<void> resendVerificationEmail({
    required String email,
    required String password,
  }) async {
    UserCredential loginUser =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    await loginUser.user!.sendEmailVerification();
  }

  Future<AuthResult> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential newUser = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      auth.currentUser!.updateDisplayName(name);
      //_auth.currentUser!.updateProfile(displayName: username);

      newUser.user!.sendEmailVerification();

      result =
          AuthResult(status: AuthStatus.successful, uid: newUser.user!.uid);
    } on FirebaseAuthException catch (e) {
      AuthStatus ExceptionStatus = AuthExceptionHandler.handleAuthException(e);
      result = AuthResult(status: ExceptionStatus, uid: '');
    }
    return result;
  }

  Future<AuthStatus> resetPassword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
