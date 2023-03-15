import 'package:flash_chat/components/messages_stream.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  final _textFieldController = TextEditingController();
  User? loggedInUser;
  bool showSpinner = false;
  String? messageText;

  void getCurrentUser() {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void messagesFuture() async {
    var snapshot = await _store.collection('messages').get();
    for (QueryDocumentSnapshot document in snapshot.docs) {
      Object? messageMap = document.data();
      if(kDebugMode) {
        print(messageMap);
      }
    }
    //  we do same thing as with stream only difference is we get raw access to these things, one after another, and we have to access them ourselves
    // we have to go to the counter each time to check if the coffee is ready and to give our ticket and get the coffee
    // whereas in stream, when there's coffee ready, we get called to pick it up and we sit back till the next coffee is ready
    // think of it as like this is you waiting for only one coffee, only one message snapshot, they're not put in a list, therefore not many
    // so you get one and that's that, you have to book another to wait for another
    // with streams, you say, however many coffee there will be today, i want em, so as you make them, send em down to my table, so each time they're made
    // we don't even need to go check, it comes down to us automatically, coz there's a loop running it for us, both from the stream server and from our for loop that's looking in the package and grabbing exactly what we need
  }

  void messagesStream() async {
    await for (QuerySnapshot snapshot
        in _store.collection('messages').snapshots()) {
      // snapshots is a list of several screenshots of the documents in the collection, imagine that one screenshot is taken each time a new message appears and it's added to the snapshots list... where snapshot is one of those snapshots, so, first time, the list contains only one snapshot, and gets added on each time there's a new _store.collection('messages').add() called  the loop goes through the list and pulls one screenshot per run, and one screen shot = QuerySnapshot snapshot
      for (QueryDocumentSnapshot document in snapshot.docs) {
        // now for each screenshot, say the screenshot at index 0 meaning the first one that was taken when first message was sent, that screenshot will contain what? a list of document screenshots, so like each document has a map nau and those maps haven't been put raw, they've also been screenshotted which is the list of documents we see on the firebase database side, inside a collection, snapshot.docs refers to that list of documents, now we have access to it, so put ya hand inside the screenshot and get the documents, and as it's a list, we tap into each document with a loop, so for the document at index 0 will be the map we sent off when first message got sent, and guess what, each document is still a screenshot, so what we get is a list of the screenshot of the documents, so it's like a screenshot inside a larger screenshot, then when we get access to document 0's screenshot, document 0 being 'QueryDocumentSnapshot' document
        Object? messageMap = document
            .data(); // now finally we have access to the last layer, which is the screenshot of the map in document 1, and to access that map, it'll be the document's data, document.data
        if(kDebugMode) {
          print(messageMap);
        }
        // once we call this function, forget the print statement, but once we call this function, we simply subscribe to the stream
        // and each time a new screenshot gets taken, it adds to the snapshots() list and then loops through the list again, gets each snapshot
        // and in each snapshot which contains the documents, tap into the documents, which also contain a screenshot of the map we just sent up
        // then we tap into the document screenshot's data, and get direct raw contact with the map and it prints it or does anything we want with the map
        // NB: we only need subscribe to it, we don't need to rebuild any states or anything, it automatically listens once we sub and notifies us by doing what we asked, like "print(messageMap.data)"
      }
    }
  }
  // with this, we get access to the entire map each time there's a new message, however in the case of a chat app, we need to get add only the latest message
  //  a StreamBuilder not only creates widgets with the data it gets back, it also builds itself based on the latest snapshot from a stream
  // it basically listens to the stream you give it, and then when there's new map sent, it sorts it and finds the latest one and gives it to us or the widget
  // the AsyncSnapshot snapshot in the builder input of the StreamBuilder represents the latest data received or to quote the docs
  // "represents the most recent interaction with the stream"
  // NB: the snapshot in the builder isn't the same as the one up in the messagesStream() method, the one in the builder is flutter's AsyncSnapshot
  // and the snapshot in the method is firebase's QuerySnapshot,
  // NB: the AsyncSnapshot also contains the QuerySnapshot.
  // when you tap into the AsyncSnapshot's data (snapshot.data) you get access to the stream's QuerySnapshot, that's snapshot at index x, a.k.a latest snapshot in the list of Future<snapshots>
  // then from there you dig your way to the message text itself, but with no use for the first loop, the builder already listens to the list and updates
  // so we just take the QuerySnapshot => snapshot.data and do snapshot.data.docs directly which gives us a list then we can run the second loop to tap each document snapshot
  // builder basically listens for a new AsyncSnapshot, once there's one, it looks at our build logic(the strategy we gave the builder on how to use the data)
  // in this case, i tell it to build me a listview with message bubbles and these message bubbles will contain the text and sender name or email,
  // so builder will get new snapshot, look at logic, and run it, then use setState() to update places where i actually use UI, rebuilds the UI for me

  @override
  initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });
                await _auth.signOut();
                Navigator.popAndPushNamed(context, LoginScreen.id);
                setState(() {
                  showSpinner = false;
                });
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(userEmail: loggedInUser!.email,),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        minLines: 1,
                        maxLines: 5,
                        controller: _textFieldController,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: () async {
                          _textFieldController.clear();
                          if (messageText != null && messageText != '') {
                            if (messageText!.isNotEmpty) {
                              await _store.collection('messages').add({
                                'sender': loggedInUser!.email,
                                'text': messageText,
                                'createdAt': FieldValue.serverTimestamp(),
                              });
                            }
                          }
                        },
                        child: const Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




