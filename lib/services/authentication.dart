import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_paul_test/services/scope.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'firebase_auth_service.dart';
//import 'mock_auth_service.dart';

class User {
  const User({
    this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
  });

  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
}

//
abstract class BaseAuth {
  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password);

  Future<String> createUserWithEmailAndPassword(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> signOut();

  Future<void> sendEmailVerification();

  Future<bool> isEmailVerified();

  Future<void> sendPasswordResetEmail(String email);
}

//class FireStoreService {
//  final Firestore _firebaseStore = Firestore.instance;
//}

class AuthService implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  get onAuthStateChanged => _firebaseAuth.onAuthStateChanged;

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final FirebaseUser user = result.user;
    return user;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
//    return user.uid;
    return user?.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }

//  Future<void> reload() async {
//    FirebaseUser user = await _firebaseAuth.currentUser().;
//    user.sendEmailVerification();
//  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}

//abstract class AuthService {
//  Future<User> currentUser();
//  Future<User> signInAnonymously();
//  Future<User> signInWithEmailAndPassword(String email, String password);
//  Future<User> createUserWithEmailAndPassword(String email, String password);
//  Future<void> sendEmailVerification();
//  Future<void> sendPasswordResetEmail(String email);
//  Future<User> signInWithEmailAndLink({String email, String link});
//  Future<bool> isSignInWithEmailLink(String link);
//  Future<void> sendSignInWithEmailLink({
//    @required String email,
//    @required String url,
//    @required bool handleCodeInApp,
//    @required String iOSBundleID,
//    @required String androidPackageName,
//    @required bool androidInstallIfNotAvailable,
//    @required String androidMinimumVersion,
//  });
//  Future<User> signInWithGoogle();
//  Future<User> signInWithFacebook();
//  Future<User> signInWithApple({List<Scope> scopes});
//  Future<void> signOut();
//  Stream<User> get onAuthStateChanged;
//  void dispose();
//}
//
//enum AuthServiceType { firebase, mock }
//
//class AuthServiceAdapter implements AuthService {
//  AuthServiceAdapter({@required AuthServiceType initialAuthServiceType})
//      : authServiceTypeNotifier =
//            ValueNotifier<AuthServiceType>(initialAuthServiceType) {
//    _setup();
//  }
//  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
////  final MockAuthService _mockAuthService = MockAuthService();
//
//  // Value notifier used to switch between [FirebaseAuthService] and [MockAuthService]
//  final ValueNotifier<AuthServiceType> authServiceTypeNotifier;
//  AuthServiceType get authServiceType => authServiceTypeNotifier.value;
//
//  AuthService get authService => _firebaseAuthService;
//
//  StreamSubscription<User> _firebaseAuthSubscription;
//  StreamSubscription<User> _mockAuthSubscription;
//
//  void _setup() {
//    // Observable<User>.merge was considered here, but we need more fine grained control to ensure
//    // that only events from the currently active service are processed
//    _firebaseAuthSubscription =
//        _firebaseAuthService.onAuthStateChanged.listen((User user) {
//      if (authServiceType == AuthServiceType.firebase) {
//        _onAuthStateChangedController.add(user);
//      }
//    }, onError: (dynamic error) {
//      if (authServiceType == AuthServiceType.firebase) {
//        _onAuthStateChangedController.addError(error);
//      }
//    });
////    _mockAuthSubscription =
////        _mockAuthService.onAuthStateChanged.listen((User user) {
////      if (authServiceType == AuthServiceType.mock) {
////        _onAuthStateChangedController.add(user);
////      }
////    }, onError: (dynamic error) {
////      if (authServiceType == AuthServiceType.mock) {
////        _onAuthStateChangedController.addError(error);
////      }
////    });
//  }
//
//  @override
//  void dispose() {
//    _firebaseAuthSubscription?.cancel();
//    _mockAuthSubscription?.cancel();
//    _onAuthStateChangedController?.close();
////    _mockAuthService.dispose();
//    authServiceTypeNotifier.dispose();
//  }
//
//  final StreamController<User> _onAuthStateChangedController =
//      StreamController<User>.broadcast();
//  @override
//  Stream<User> get onAuthStateChanged => _onAuthStateChangedController.stream;
//
//  @override
//  Future<User> currentUser() => authService.currentUser();
//
//  @override
//  Future<User> signInAnonymously() => authService.signInAnonymously();
//
//  @override
//  Future<User> createUserWithEmailAndPassword(String email, String password) =>
//      authService.createUserWithEmailAndPassword(email, password);
//
//  @override
//  Future<User> signInWithEmailAndPassword(String email, String password) =>
//      authService.signInWithEmailAndPassword(email, password);
//
//  //New
//  Future<void> sendEmailVerification() async {
//    authService.sendEmailVerification();
//  }
//

//  @override
//  Future<User> signInWithEmailAndLink({String email, String link}) =>
//      authService.signInWithEmailAndLink(email: email, link: link);
//
//  @override
//  Future<bool> isSignInWithEmailLink(String link) =>
//      authService.isSignInWithEmailLink(link);
//
//  @override
//  Future<void> sendSignInWithEmailLink({
//    String email,
//    String url,
//    bool handleCodeInApp,
//    String iOSBundleID,
//    String androidPackageName,
//    bool androidInstallIfNotAvailable,
//    String androidMinimumVersion,
//  }) =>
//      authService.sendSignInWithEmailLink(
//        email: email,
//        url: url,
//        handleCodeInApp: handleCodeInApp,
//        iOSBundleID: iOSBundleID,
//        androidPackageName: androidPackageName,
//        androidInstallIfNotAvailable: androidInstallIfNotAvailable,
//        androidMinimumVersion: androidMinimumVersion,
//      );
//
//  @override
//  Future<User> signInWithFacebook() => authService.signInWithFacebook();
//
//  @override
//  Future<User> signInWithGoogle() => authService.signInWithGoogle();
//
//  @override
//  Future<User> signInWithApple({List<Scope> scopes}) =>
//      authService.signInWithApple();
//
//  @override
//  Future<void> signOut() => authService.signOut();
