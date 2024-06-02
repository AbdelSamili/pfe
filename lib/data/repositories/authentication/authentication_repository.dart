import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pfe_1/data/repositories/center/center_repository.dart';
import 'package:pfe_1/data/repositories/client/client_repository.dart';
import 'package:pfe_1/features/authentification/view/login/login_view.dart';
import 'package:pfe_1/features/authentification/view/onboarding/onboarding_view.dart';
import 'package:pfe_1/features/authentification/view/signup/center/verifyemail_center_view.dart';
import 'package:pfe_1/features/authentification/view/signup/client/verifyemail_client_view.dart';
import 'package:pfe_1/features/centre/view/navigation_menu_center.dart';
import 'package:pfe_1/features/client/view/navigation_menu_client.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  /// Get Authenticate User Data
  User? get authUser => _auth.currentUser;

  @override
  void onReady(){
    FlutterNativeSplash.remove();
    screenRedirect();
  }


  // Single method to redirect both clients and centers
  screenRedirect() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userType = await getUserType(user.uid);
        if (userType == 'client') {
          // Redirect to client screen
          if (user.emailVerified) {
            Get.offAll(() => const NavigationMenuClient());
          } else {
            Get.offAll(() => VerifyEmailClientScreen(email: user.email));
          }
        } else if (userType == 'center') {
          // Redirect to center screen
          if (user.emailVerified) {
            Get.offAll(() => const NavigationMenuCenter());
          } else {
            Get.offAll(() => VerifyEmailCenterScreen(email: user.email));
          }
        } else {
          // Handle unrecognized user type
          throw 'Unrecognized user type';
        }
      } else {
        // Handle scenario where no user is signed in
        // Redirect to login or onboarding view
        deviceStorage.writeIfNull('isFirstTime', true);
        deviceStorage.read('isFirstTime') != true ? Get.off(() => const LoginScreen()) : Get.to(() => const OnBoardingView());
      }
    } catch (e) {
      throw 'Error redirecting user: $e';
    }
  }
// Method to get the user type from Firestore based on UID
  Future<String> getUserType(String uid) async {
    try {
      final clientDoc = await FirebaseFirestore.instance.collection('Clients').doc(uid).get();
      final centerDoc = await FirebaseFirestore.instance.collection('Centers').doc(uid).get();

      if (clientDoc.exists) {
        return 'client';
      } else if (centerDoc.exists) {
        return 'center';
      } else {
        throw 'User document not found';
      }
    } catch (e) {
      throw 'Error getting user type: $e';
    }
  }

  /*=====================Email and Password Sing IN================================*/

  /// [EmailAuthentication] - Login
  Future<UserCredential> loginWithEmailAndPassword(String email,String password) async{
    try{
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    }catch(e){
      throw "Something went wrong. please try again";
    }
  }
  /// [EmailAuthentication] - Register
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try{
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    }catch(e){
      throw "Something went wrong. please try again";
    }
  }
  /// [EmailVerification]
  Future<void> sendEmailVerification() async {
    try{
      await _auth.currentUser?.sendEmailVerification();
    }catch(e){
      throw "Something went wrong. please try again";
    }
  }

  /// [EmailVerification] - Forget Password
  Future<void> sendPasswordResetEmail(String email) async {
    try{
      await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      throw "Something went wrong. please try again";
    }
  }

  /// [EmailAuthentication] - Google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

  /// [ReAuthenticate] - RE AUTHENTICATE USER
  Future<void> reAuthenticateWithEmailAndPassword(String email, String password) async {
    try {
      // Create a credential
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

      // ReAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    }catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  Future<void> logOut() async {
    try{
      await GoogleSignIn().signOut();
      await _auth.signOut();
      Get.offAll(() => const LoginScreen());
    }catch(e){
      throw "Something went wrong. please try again";
    }
  }


  /// DELETE USER - Remove user Auth and Firestore Account.
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userType = await getUserType(user.uid);
        if(userType == 'client'){
          await ClientRepository.instance.removeUserRecord(_auth.currentUser!.uid);
          await _auth.currentUser?.delete();
        }else if(userType == 'center'){
          await CenterRepository.instance.removeUserRecord(_auth.currentUser!.uid);
          await _auth.currentUser?.delete();
        }
      }
    }catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


}

