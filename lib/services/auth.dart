import 'package:citypetro/auhenticate/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth= FirebaseAuth.instance;
  User _userFromFirebaseUser(FirebaseUser user){
    return user!=null?User(uid: user.uid,name: user.displayName):null;
  }

  Stream<User> get user{
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user)=> _userFromFirebaseUser(user));
         .map(_userFromFirebaseUser);
}
  //sign in anom
 Future signInAnom() async{
   try{
     AuthResult result = await _auth.signInAnonymously();
     FirebaseUser user = result.user;
     return _userFromFirebaseUser(user);
   }catch(e){
     print(e.toString());
     return null;
   }
 }

 Future updateProfile(String name,FirebaseUser user)async{
    try{
      UserUpdateInfo data = UserUpdateInfo();
      data.displayName=name;
      user.updateProfile(data);
    }catch(e){
      print(e.toString());
    }
 }

 Future signInWithEmailAndPassword(String email,String password)async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      //await this.updateProfile('Garry', user);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
 }

 //signout
Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
}

}