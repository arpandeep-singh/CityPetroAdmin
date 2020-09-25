
import 'package:citypetro/reports/invoice/driver.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class DatabaseService {

  final String uid;
  final String name;

  DatabaseService({this.uid, this.name});


  Future<void> addLoad(loadData, List<String> files) async {
    Firestore.instance.collection('Users').document(uid)
        .collection('Loads')
        .add(loadData)
        .then((docRef) {
      print(docRef.documentID);
      Set<String> set = Set.from(files);
      set.forEach((url) {
        docRef.collection('files').add({'URL': url}).then((result) {
          print('URLS saved');
        });
      });
    }

    )
        .catchError((e) {
      print(e);
    });
  }

  Future<bool> insertLoad(loadData, List<String> files) async {
    bool uploaded = await Firestore.instance.collection('Users').document(uid)
        .collection('Loads').add(loadData)
        .then((docRef) {
      print(docRef.documentID);
      Set<String> set = Set.from(files);
      set.forEach((url) {
        docRef.collection('files').add({'URL': url}).then((result) {
          print('URLS saved');
        });
      });
      return true;
    }
    );
    if (uploaded == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> uploadDocument(filepath, DateTime date) async {
    StorageReference storage = FirebaseStorage.instance.ref().child(
        "PaperWork/$name/${date.toString().split(' ')[0]}/" +
            DateTime.now().toString());
    final StorageUploadTask uploadTask = storage.putFile(File(filepath));
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    return (await downloadUrl.ref.getDownloadURL());
  }

  Future<List<String>> insertLinks(List<File> fileList, List<String> linkList,
      DateTime date) async {
    for (File file in fileList) {
      linkList.add(await this.uploadFileAndGetURL(file, date));
    }
    return linkList;
  }

  Future<List<String>> getLinks(List<File> fileList, DateTime date) async {
    List<String> linkList = [];

    final List<String> list = await insertLinks(fileList, linkList, date);

    return list;
  }

  Future<bool> submitLoad(loadData, List<File> fileList, DateTime date) async {
    return await getLinks(fileList, date).then((list) {
      print('List Size ${list.length}');
      return this.insertLoad(loadData, list);
    });
  }

  Future<String> uploadFileAndGetURL(File file, DateTime date) async {
    StorageReference storage = FirebaseStorage.instance.ref().child(
        "PaperWork/$name/${date.toString().split(' ')[0]}/" +
            DateTime.now().toString());
    final StorageUploadTask uploadTask = storage.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    return (await downloadUrl.ref.getDownloadURL());
  }

  Future<String> uploadInvoiceAndGetURL(File file, String driverName,
      String fileName) async {
    StorageReference storage = FirebaseStorage.instance.ref().child(
        'Invoices/$driverName/$fileName');
    final StorageUploadTask uploadTask = storage.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    return (await downloadUrl.ref.getDownloadURL());
  }

  Future<bool> submitInvoice(String url, String period) async {
    print(url);
    bool uploaded = await Firestore.instance.collection('Users').document(uid)
        .collection('Invoices').document(period).setData({
      'URL': url,
      'period': period
    })
        .then((results) {
      return true;
    }
    );
    return uploaded;
  }


  Future<Driver> getDriver(String id) async {
    var doc = await Firestore.instance.collection('Users').document(id).get();

    Driver driver = new Driver(name: doc.data['name'],
        email: doc.data['email'],
        contact: doc.data['contact']);
    return driver;
  }


  getSites() async {
    return await Firestore.instance.collection('Rates').getDocuments();
  }

  Future<bool> modifyLoad(loadData, String driverID, String documentID) async {

      try {
        await Firestore.instance.collection('Users').document(driverID)
            .collection('Loads').document(documentID)
            .updateData(
            {
              'city': loadData['city'],
              "comments": loadData['comments'],
              "order": loadData['order'],
              "rate": loadData['rate'],
              "splitLoads": loadData['splitLoads'],
              "stationID": loadData['stationID'],
              "terminal": loadData['terminal'],
              "totalRate": loadData['totalRate'],
              "truck": loadData['truck'],
              "waiting": loadData['waiting'],
              "waitingCost": loadData['waitingCost']
            }
        )
            .then((_) {
          print("success!");

        });
        return true;
      }catch(error) {
        return false;
      }

 }

 Future<bool> updateRate(String docID,rates)async{

    try {
      bool status = await Firestore.instance.collection('Rates').document(docID).updateData({
        "city": rates['city'],
        "rateToronto": rates['toronto'],
        "rateOakville": rates['oakville'],
        "rateHamilton": rates['hamilton'],
        "rateNanticoke": rates['nanticoke'],

      }).then((_){
        print("Success!");
        return true;
      }).catchError((error){
        return false;
      });
     return status;
    }catch(error){
      return false;
    }
 }

  Future<bool> addSite(String stationID, rates)async{

    try {
      bool status = await Firestore.instance.collection('Rates').document(stationID).setData({
        "city": rates['city'],
        "rateToronto": rates['toronto'],
        "rateOakville": rates['oakville'],
        "rateHamilton": rates['hamilton'],
        "rateNanticoke": rates['nanticoke'],
        "stationID":rates['stationID']

      }).then((_){
        print("Success!");
        return true;
      }).catchError((error){
        return false;
      });
      return status;
    }catch(error){
      return false;
    }
  }



  }
