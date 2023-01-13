// ignore_for_file: file_names, prefer_const_constructors, unnecessary_null_comparison, avoid_print, avoid_unnecessary_containers, duplicate_ignore, unrelated_type_equality_checks, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numeral/numeral.dart';
import 'src/sources.dart';
import '../sources.dart';

class MySearch extends StatefulWidget {
  const MySearch({Key? key}) : super(key: key);

  @override
  State<MySearch> createState() => _MySearchState();
}

class _MySearchState extends State<MySearch> {
  String? senderUserName;
  String? senderUserId;
  String? senderUserNumber;
  String? senderUserImg;
  String? targetUserName;
  String? targetUserId;
  String? targetUserNumber;
  String? targetUserImg;
  String? cherpDesc;
  String? postImg;
  int? cherpLikes;
  var totalComments;
  TextEditingController searchCorntroller = TextEditingController();
  late CallbackAction onChange;
  String isSearch = '';
  @override
  Widget build(BuildContext context) => DarkOne(
        child: Expanded(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.01,
                ),
                child: TextFormField(
                  style: sources.font_style(
                    color: Colors.white,
                    // fontSize: 18,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                  onChanged: (value) {
                    setState(() {
                      value = searchCorntroller.text;
                    });
                  },
                  controller: searchCorntroller,
                  maxLines: null,
                  cursorColor: Colors.white.withOpacity(0.7),
                  decoration: InputDecoration(
                    // Set some default text
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.07),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: MediaQuery.of(context).size.height * 0.02,
                    ),
                    labelText: "Search",

                    labelStyle: sources.font_style(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 18,
                    ),
                    enabledBorder: field_border_style,
                    focusedBorder: field_border_style,
                  ),
                ),
              ),
              // ignore: prefer_const_constructors
              searchCorntroller.text.isNotEmpty
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("your_cherps")
                          // .where('senderUserName',
                          //     isGreaterThanOrEqualTo:
                          //         searchCorntroller.text.trim())
                          .where('cherpDesc',
                              isGreaterThanOrEqualTo:
                                  searchCorntroller.text.trim())
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Something went wrong"),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CupertinoActivityIndicator(),
                          );
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text("No data found"),
                          );
                        }
                        if (snapshot != null && snapshot.data != null) {
                          print(snapshot.data!.docs.first['senderUserName']);
                          //  Expanded(child: SearchTweets(searchCorntroller));
                          return Row(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      // backgroundImage: AssetImage(path),
                                      radius: 25,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                // widget.senderUserName.toString(),
                                // name,
                                'essa',
                                style: sources.font_style(
                                  color: sources.color_TheOther,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                              ),
                            ],
                          );
                        }
                        return Container();
                      },
                    )
                  // Expanded(child: SearchTweets(searchCorntroller))
                  : Container(),
              // StreamBuilder(
              //     stream: FirebaseFirestore.instance
              //         .collection("your_cherps")
              //         .orderBy('createdAt', descending: true)
              //         .snapshots(),
              //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //       if (snapshot.hasError) {
              //         return Center(
              //           child: Text("Something went wrong"),
              //         );
              //       }
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Center(
              //           child: CupertinoActivityIndicator(),
              //         );
              //       }
              //       if (snapshot.data!.docs.isEmpty) {
              //         return Center(
              //           child: Text("No data found"),
              //         );
              //       }
              //       if (snapshot != null && snapshot.data != null) {
              //         print(snapshot.data!.docs.length);

              //         return ListView.builder(
              //             itemCount: snapshot.data!.docs.length,
              //             padding: EdgeInsets.symmetric(
              //               horizontal:
              //                   MediaQuery.of(context).size.width * 0.05,
              //             ),
              //             itemBuilder: (context, index) {
              //               // var documentId = snapshot.data!.docs[index].id;
              //               //  print('documentId $documentId');
              //               // senderUserName =
              //               //     snapshot.data!.docs[index]['senderUserName'];

              //               // senderUserImg =
              //               //     snapshot.data!.docs[index]['senderUserImg'];
              //               // cherpDesc = snapshot.data!.docs[index]['cherpDesc'];
              //               // targetUserName =
              //               //     snapshot.data!.docs[index]['targetUserName'];
              //               // targetUserImg =
              //               //     snapshot.data!.docs[index]['targetUserImg'];
              //               // postImg = snapshot.data!.docs[index]['postImg'];
              //               // cherpLikes =
              //               //     snapshot.data!.docs[index]['cherpLikes'];
              //               // var postId = snapshot.data!.docs[index]['postId'];
              //               // totalComments =
              //               //     snapshot.data!.docs[index]['cherpTotalComment'];

              //               //  getComments(postId);

              //               // List cherpLikeUserList =
              //               //     snapshot.data!.docs[index]['cherpLikeUserList'];
              //               // print(cherpLikeUserList.toString());
              //               return Container();
              //               // return theCard(
              //               //   context,
              //               //   senderUserName,
              //               //   cherpLikes!,
              //               //   documentId,
              //               //   cherpLikeUserList,
              //               //   totalComments,
              //               //   targetUserName,
              //               // );
              //               // return Column(children: [
              //               //   Expanded(
              //               //     child: Row(
              //               //       children: [
              //               //         Flexible(
              //               //           child: Padding(
              //               //             padding: const EdgeInsets.all(10.0),
              //               //             child: Container(
              //               //               decoration: BoxDecoration(
              //               //                 shape: BoxShape.circle,
              //               //                 border: Border.all(
              //               //                   color: Colors.white,
              //               //                   width: 2,
              //               //                 ),
              //               //               ),
              //               //               child: CircleAvatar(
              //               //                 // backgroundImage: AssetImage(path),
              //               //                 radius: 25,
              //               //               ),
              //               //             ),
              //               //           ),
              //               //         ),
              //               //         Text(
              //               //           // widget.senderUserName.toString(),
              //               //           '',
              //               //           // senderUserName,
              //               //           style: sources.font_style(
              //               //             color: sources.color_TheOther,
              //               //             fontSize:
              //               //                 MediaQuery.of(context).size.width *
              //               //                     0.04,
              //               //           ),
              //               //         )
              //               //       ],
              //               //     ),
              //               //   ),
              //               //   Container(
              //               //     decoration: BoxDecoration(
              //               //       color: sources.is_dark
              //               //           ? sources.color_dark.withOpacity(0.2)
              //               //           : sources.color_light,
              //               //       borderRadius: BorderRadius.circular(10),
              //               //     ),
              //               //     margin: EdgeInsets.symmetric(
              //               //       vertical:
              //               //           MediaQuery.of(context).size.height * 0.02,
              //               //     ),
              //               //     padding: EdgeInsets.symmetric(
              //               //       horizontal:
              //               //           MediaQuery.of(context).size.width * 0.05,
              //               //       vertical: MediaQuery.of(context).size.height *
              //               //           0.025,
              //               //     ),
              //               //     width: double.infinity,
              //               //     child: Column(
              //               //       children: [
              //               //         Row(
              //               //           children: [
              //               //             // getAvatar(
              //               //             //     path: sources.avatar_01,
              //               //             //     name: widget.senderUserName.toString()),
              //               //             const Padding(
              //               //               padding: EdgeInsets.all(8.0),
              //               //               child: Icon(
              //               //                   Icons.arrow_circle_right_rounded,
              //               //                   color: Colors.yellow),
              //               //             ),
              //               //             Container(), // Arrow
              //               //             // getAvatar(
              //               //             //     path: sources.avatar_02,
              //               //             //     name: widget.targetUserName.toString()),
              //               //           ],
              //               //         ), // Avatars
              //               //         Text(
              //               //           "Here is the sample text, which is going to be replaced with the actual "
              //               //           "tweet. This is just a placeholder for now. I am going to further design "
              //               //           "the application.",
              //               //           style: sources.font_style(
              //               //             color: sources.color_TheOther
              //               //                 .withOpacity(0.8),
              //               //             fontSize: 15,
              //               //             height: 1.5,
              //               //           ),
              //               //         ),
              //               //         //  // Text
              //               //         // Text(
              //               //         //   "Data",
              //               //         //   style: TextStyle(fontSize: 20, color: Colors.white),
              //               //         // ),
              //               //         Padding(
              //               //           padding: const EdgeInsets.symmetric(
              //               //               vertical: 20),
              //               //           child: ClipRRect(
              //               //             borderRadius: BorderRadius.circular(10),
              //               //             child: Image.asset(sources.image_01,
              //               //                 width: double.infinity,
              //               //                 height: 200,
              //               //                 fit: BoxFit.cover),
              //               //           ),
              //               //         ), // Image
              //               //         Row(
              //               //           // mainAxisAlignment: MainAxisAlignment.center,
              //               //           children: [
              //               //             // mainAxisAlignment: MainAxisAlignment.spaceAround,
              //               //             Row(
              //               //               children: [
              //               //                 // cherpLikeUserList.contains(user!.uid)
              //               //                 //       ? Icon(Icons.favorite, color: Colors.red)
              //               //                 //       : Icon(Icons.favorite_border, color: Colors.white),
              //               //                 const SizedBox(width: 5),
              //               //                 Text(
              //               //                   '',
              //               //                   // Numeral(cherpLikes).format().toString(),
              //               //                   style: sources.font_style(
              //               //                     color: Colors.white,
              //               //                     fontSize: 15,
              //               //                   ),
              //               //                 ),
              //               //               ],
              //               //             ),

              //               //             const SizedBox(width: 30),
              //               //             Row(
              //               //               children: [
              //               //                 Icon(Icons.comment,
              //               //                     color: Colors.white),
              //               //                 const SizedBox(width: 5),
              //               //                 totalComments == 0
              //               //                     ? Text('')
              //               //                     : Text(
              //               //                         '',
              //               //                         // Numeral(int.parse(totalComments.toString()))
              //               //                         //     .format()
              //               //                         //     .toString(),
              //               //                         style: sources.font_style(
              //               //                           color: sources
              //               //                               .color_TheOther,
              //               //                           fontSize: 15,
              //               //                         ),
              //               //                       ),
              //               //               ],
              //               //             ),

              //               //             SizedBox(width: 10),
              //               //             // Icon(Icons.message_rounded, color: sources.color_TheOther),

              //               //             // Icons
              //               //             // const Icon(Icons.share, color: Colors.white),
              //               //           ],
              //               //         ), // Icons
              //               //       ],
              //               //     ),
              //               //   ),
              //               // ]);
              //             });
              //       }
              //       return Container();
              //     }),
            ],
          ),
        ),
      );
}

// theCard(BuildContext context, senderUserName, cherpLikes, documentId,
//     cherpLikeUserList, totalComments, targetUserName) {
  
// }
