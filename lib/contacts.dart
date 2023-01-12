// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, library_private_types_in_public_api, avoid_print, unnecessary_null_comparison, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

void main() => runApp(FlutterContactsExample());

class FlutterContactsExample extends StatefulWidget {
  @override
  _FlutterContactsExampleState createState() => _FlutterContactsExampleState();
}

class _FlutterContactsExampleState extends State<FlutterContactsExample> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;
  User? user = FirebaseAuth.instance.currentUser;
  String? senderUserName;
  String? senderUserId;
  String? senderUserNumber;
  String? senderUserImg;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    getSenderUserDetails();
    // getTargetUserDetails();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  Future<void> getSenderUserDetails() async {
    if (user != null) {
      //  await FirebaseFirestore.instance.collection("users").get();
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where(
            "userId",
            isEqualTo: user!.uid,
          )
          .get();
      senderUserName = snapshot.docs.first['userName'];
      senderUserId = snapshot.docs.first['userId'];
      senderUserNumber = snapshot.docs.first['phoneNumber'];
      senderUserImg = snapshot.docs.first['userImg'];

      setState(() {
        print(senderUserId);
      });
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('flutter_contacts_example')),
          body: _body()));

  Widget _body() {
    if (_permissionDenied) return Center(child: Text('Permission denied'));
    if (_contacts == null) return Center(child: CircularProgressIndicator());
    return ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, i) => ListTile(
            title: Text(_contacts![i].displayName),
            onTap: () async {
              final fullContact =
                  await FlutterContacts.getContact(_contacts![i].id);
              await Get.to(() => ContactPage(fullContact!), arguments: {
                'senderUserId': senderUserId,
                'senderUserName': senderUserName,
                'senderUserImg': senderUserImg,
                'senderUserNumber': senderUserNumber,
                // 'targetUserId': targetUserId,
                // 'targetUserName': targetUserName,
                // 'targetUserImg': targetUserImg,
                // 'targetUserNumber': targetUserNumber,
              });
              // await Navigator.of(context).push(
              //     MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));
            }));
  }
}

class ContactPage extends StatefulWidget {
  final Contact contact;
  ContactPage(this.contact);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  String? targetUserName = '';
  String? targetUserId = '';
  String? targetUserNumber = '';
  String? targetUserImg = '';
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> getTargetUserDetails(String targetUserPhoneNumber) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where(
          "phoneNumber",
          isEqualTo: targetUserPhoneNumber,
        )
        .get();
    print(targetUserPhoneNumber);
    print(snapshot.docs.first['phoneNumber']);

    //   if (snapshot.docs == null) {
    //     targetUserName = '';
    //     targetUserId = '';
    //     targetUserImg = '';
    //     targetUserNumber = '';
    //     setState(() {});
    //   } else {
    //     targetUserName = snapshot.docs.first['userName'];
    //     targetUserId = snapshot.docs.first['userId'];
    //     targetUserNumber = snapshot.docs.first['phoneNumber'];
    //     targetUserImg = snapshot.docs.first['userImg'];
    //     setState(() {});
    //   }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    // getTargetUserDetails(widget.contact.phones.first.number);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(widget.contact.displayName)),
      body: Column(children: [
        Text('First name: ${widget.contact.name.first}'),
        Text('user Id: ${Get.arguments['senderUserId']}'),
        Text('Last name: ${widget.contact.name.last}'),
        Text(
            'Phone number: ${widget.contact.phones.isNotEmpty ? widget.contact.phones.first.number : '(none)'}'),
        Text(
            'Email address: ${widget.contact.emails.isNotEmpty ? widget.contact.emails.first.address : '(none)'}'),
        ElevatedButton(
            onPressed: (() async {
              // sending cherp to contact
              // await getTargetUserDetails(widget.contact.phones.first.number);

              // if (widget.contact.phones.first.number ==
              //     Get.arguments['targetUserNumber']) {
              String? postId = Uuid().v4();
              await FirebaseFirestore.instance
                  .collection("your_cherps")
                  .doc(postId)
                  .set({
                'senderUserId': Get.arguments['senderUserId'],
                'createdAt': DateTime.now(),
                'senderUserName': Get.arguments['senderUserName'],
                'senderUserNumber': Get.arguments['senderUserNumber'],
                'senderUserImg': Get.arguments['senderUserImg'],
                'postImg': '',
                'targetUserName': "targetUserName",
                'targetUserId': "targetUserId",
                'targetUserImg': "targetUserImg",
                'cherpTotalComment': '',
                'cherpLikeUserList': [],
                'postId': postId,

                // 'targetUserNumber': Get.arguments['senderUserImg'],

                'cherpLikes': 0,
                'cherpDesc': "",
                'targetUserNumber': widget.contact.phones.first.number,
                // ignore: todo
                // TODO IMP
                // 'cherpComments': [
                //   {
                //     'comments': 'test comment',
                //     'commentSenderName': Get.arguments['userName'],
                //     'commentDate': DateTime.now(),
                //   },
                // ],
              });
              log("Successfully added");
              //  else {
              //   print('user not exist');
              // }
            }),
            child: Text(
              "Cherp",
              style: TextStyle(fontSize: 23, color: Colors.white),
            ))
      ]));
}
