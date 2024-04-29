// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Api/Config.dart';
import '../home/home.dart';
import '../utils/colornotifire.dart';
import 'chat_bubble.dart';
import 'chat_service.dart';

class ChatPage extends StatefulWidget {
  final String resiverUserId;
  final String resiverUseremail;
  final String proPic;

  const ChatPage({Key? key,

    required this.resiverUserId,
    required this.resiverUseremail,
    required this.proPic,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();

  ChatServices chatservices = ChatServices();

  final ScrollController _controller = ScrollController(initialScrollOffset: 50.0);

  void sendMessage() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');

    if (controller.text.isNotEmpty) {
      collectionReference.doc(widget.resiverUserId).get().then((value) async {
        var fields;

        fields = value.data();

        if (fields["isOnline"] == false) {
          sendPushMessage(
              controller.text, getData.read("UserLogin")["name"], fmctoken);
        } else {
          print("user online");
        }

        await chatservices.sendMessage(
            receiverId: widget.resiverUserId, messeage: controller.text);

        controller.clear();

        _controller.jumpTo(_controller.position.maxScrollExtent);
      });
      // service.showNotification(
      //     id: 0, title: senderemail, body: controller.text);
    }
  }

  String fmctoken = "";
  Future<dynamic> isMeassageAvalable(String uid) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    collectionReference.doc(uid).get().then((value) {
      var fields;
      fields = value.data();
      setState(() {
        fmctoken = fields["token"];
      });
    });
  }


  @override
  void initState() {
    super.initState();
    print(widget.resiverUserId);
    print(widget.resiverUseremail);
    print(widget.proPic);
    isMeassageAvalable(widget.resiverUserId);
    if (getData.read("UserLogin")["id"] == null) {
    } else {
      isUserOnlie(getData.read("UserLogin")["id"], true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    isUserOnlie(getData.read("UserLogin")["id"], false);
  }

  void _scrollDown() {
    _controller.animateTo(_controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    // _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  late ColorNotifire notifire;

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifire.backgrounde,
      appBar: appbar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInpurt(),
        ],
      ),
    );
  }

  PreferredSizeWidget appbar() {
    return AppBar(
      backgroundColor: notifire.backgrounde,
      // centerTitle: true,
      elevation: 0,
      leading: BackButton(
        color: notifire.textcolor,
        onPressed: () {
          Get.back();
        },
      ),
      title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(widget.resiverUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(
                widget.resiverUseremail,
                style:  TextStyle(
                  fontSize: 18,
                  color: notifire.textcolor,
                ),
              );
            } else {
              Map data = snapshot.data!.data() as Map;

              return Row(
                children: [
                  widget.proPic == "null"
                      ? const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 20,
                          backgroundImage: AssetImage(
                            "assets/images/profile-default.png",
                          ))
                      : CircleAvatar(radius: 15, backgroundColor: Colors.transparent, backgroundImage: NetworkImage("${Config.base_url}${widget.proPic}")),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.resiverUseremail,
                        style:  TextStyle(
                          fontSize: 18,
                          color: notifire.textcolor,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      data["isOnline"] == false
                          ? const SizedBox()
                          : const Text(
                              "Online",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            ),
                    ],
                  ),
                ],
              );
            }
          }),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot<Object?>>(
        stream: chatservices.getMessage(
            userId: widget.resiverUserId,
            otherUserId: getData.read("UserLogin")["id"]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              controller: _controller,
              children: snapshot.data!.docs
                  .map((document) => _buildMessageiteam(document))
                  .toList(),
            );
          }
        });
  }

  Widget _buildMessageiteam(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollDown();
    });
    var alingmentt = (data["senderid"] == getData.read("UserLogin")["id"])
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alingmentt,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data["senderid"] == getData.read("UserLogin")["id"])
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            // Text(data["senderEmail"],
            //     style: TextStyle(
            //         fontSize: 12,
            //         fontFamily: FontFamily.gilroyLight,
            //         color: blueColor)),
            // // Text(data["message"])
            // const SizedBox(
            //   height: 5,
            // ),

            ChatBubble(
              chatColor: (data["senderid"] == getData.read("UserLogin")["id"])
                  ? Colors.black
                  : Colors.grey.shade100,
              textColor: (data["senderid"] == getData.read("UserLogin")["id"])
                  ? Colors.white
                  : Colors.black,
              message: data["message"],
              alingment: (data["senderid"] == getData.read("UserLogin")["id"])
                  ? false
                  : true,
            ),
            const SizedBox(height: 5,),
            Text(
                DateFormat('hh:mm a')
                    .format(DateTime.fromMicrosecondsSinceEpoch(
                        data["timestamp"].microsecondsSinceEpoch))
                    .toString(),
                style:  TextStyle(
                  fontSize: 10,
                  color: notifire.textcolor,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInpurt() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: notifire.textcolor),
              decoration: InputDecoration(

                  // fillColor: Colors.grey.shade100,
                  // filled: true,
                  isDense: true,
                  contentPadding: const EdgeInsets.all(12),
                  suffixIcon: IconButton(
                      onPressed: sendMessage,
                      icon:  Icon(
                        Icons.send,
                        color: notifire.textcolor,
                      )),
                  hintStyle:  TextStyle(
                    fontSize: 14,
                    color: notifire.textcolor,
                  ),
                  hintText: "Say Something..",
                  border: OutlineInputBorder(
                      borderSide:  const BorderSide(color: Color(0xffF0F0F0)),
                      borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:  const BorderSide(color: Color(0xffF0F0F0)),
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:  const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12)),
                  disabledBorder: OutlineInputBorder(
                      borderSide:  const BorderSide(color: Color(0xffF0F0F0)),
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
        ],
      ),
    );
  }

  void sendPushMessage(String body, String title, String token) async {
    try {
      await http.post(
        Uri.parse(Config.notificationUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${Config.firebaseKey}',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': getData.read("UserLogin")["id"],
              'name': getData.read("UserLogin")["name"],
              'propic': getData.read("UserLogin")["pro_pic"],
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

Future<dynamic> isUserOnlie(String uid, bool isonline) async {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  collectionReference.doc(uid).update({"isOnline": isonline});
}
