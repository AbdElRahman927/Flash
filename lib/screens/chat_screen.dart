import 'package:flutter/material.dart';
import 'package:flash/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User? loggedinuser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messagetextcont = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? messagetext;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser() async {
    try {
      final userr = _auth.currentUser;
      if (userr != null) {
        loggedinuser = userr;
        print(loggedinuser?.email);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // void getmessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var messages in messages.docs) {
  //     print(messages.data());
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
               

                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Center(child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Hero(tag: 'flash',child: Image.asset('images/logo.png',height: 30,)),const Text('Chat')],)),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("messages").orderBy('timestamp',descending:false ).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {  
                  final messages = snapshot.data?.docs.reversed;
                  List<Messagebubble> messagebubbles = [];

                  // Null safety check to ensure messages are not null
                  if (messages != null) {
                    for (var message in messages) {
                      // Cast data to Map<String, dynamic>
                      final data = message.data() as Map<String, dynamic>;

                      // Access the 'text' field safely
                      final messagebubble =
                          data['text'] ?? 'No Text'; // Null-safe access
                      final messagesender = data['sender'] ?? 'No sneder';

                      final currentuser = loggedinuser?.email;

                      // Create a Text widget for each message
                      final messageWidget = Messagebubble(
                        sender: messagesender,
                        text: messagebubble,
                        isme: currentuser == messagesender,
                      );
                      messagebubbles.add(messageWidget);
                    }
                  }

                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      children: messagebubbles,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  )); // Show loading while data is being fetched
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messagetextcont,
                      onChanged: (value) {
                        messagetext = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (messagetext != null && messagetext!.isNotEmpty) {
                        // ADD TIMESTAMP WHEN SENDING A MESSAGE
                        _firestore.collection('messages').add({
                          'text': messagetext,
                          'sender': loggedinuser?.email,
                          'timestamp': FieldValue.serverTimestamp(), // TIMESTAMP ADDED
                        });
                        messagetextcont.clear(); // Clear text field
                      }
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Messagebubble extends StatelessWidget {
  const Messagebubble({super.key, this.sender, this.text,required this.isme});
  final String? sender;
  final String? text;
  final bool isme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:isme?  CrossAxisAlignment.end :CrossAxisAlignment.start ,
        children: [
          Text(
            sender.toString(),
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Material(
              borderRadius:  BorderRadius.only(
                  topLeft:isme? const Radius.circular(30): Radius.zero,
                  topRight: isme? Radius.zero :const Radius.circular(30),
                  bottomLeft: const Radius.circular(30),
                  bottomRight: const Radius.circular(30)),
              elevation: 50,
              color: isme ? Colors.lightBlueAccent : Colors.white ,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  text.toString(),
                  style:  TextStyle(color:isme ?  Colors.white :Colors.black54, fontSize: 15),
                ),
              )),
        ],
      ),
    );
  }
}