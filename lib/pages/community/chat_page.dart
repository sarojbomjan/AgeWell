import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/authentication/user_authentication.dart';
import 'package:elderly_care/pages/community/chat_bubble.dart';
import 'package:elderly_care/pages/login/components/my_textfield.dart';
import 'package:elderly_care/service/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // controller
  final TextEditingController _messageController = TextEditingController();

  // chat and auth service
  final ChatService _chatService = ChatService();

  final UserAuthentication _authService = UserAuthentication();

  // for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  // method to send message
  void sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      try {
        print("Sending message: $message");
        await _chatService.sendMessage(widget.receiverID, message);

        _messageController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send message. Please try again.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Message cannot be empty")),
      );
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          //display all messages
          Expanded(child: _buildMessageList()),

          // user input
          _buildUserInput(),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          //errors
          if (snapshot.hasError) {
            return Center(child: Text("Error loading messages."));
          }

          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text("No messages yet.");
          }

          //return list view
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageListItem(doc))
                .toList(),
          );
        });
  }

  // build message item
  Widget _buildMessageListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // return Text(data["message"]);
    // is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    // aligns message to right if sender is current user, otherwise left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser)
        ],
      ),
    );
  }

  // Widget _buildMessageList() {
  //   String senderID = _authService.getCurrentUser()!.uid;
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: _chatService.getMessages(widget.receiverID, senderID),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return Center(child: Text("Error loading messages."));
  //       }
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(child: CircularProgressIndicator());
  //       }

  //       // Debugging: print the fetched messages
  //       print(
  //           "Messages: ${snapshot.data!.docs.map((doc) => doc.data()).toList()}");

  //       var messages = snapshot.data!.docs;
  //       return ListView.builder(
  //         controller: _scrollController,
  //         itemCount: messages.length,
  //         itemBuilder: (context, index) {
  //           var message = messages[index].data() as Map<String, dynamic>;
  //           return _buildMessageListItem(message);
  //         },
  //       );
  //     },
  //   );
  // }

  // Widget _buildMessageListItem(Map<String, dynamic> data) {
  //   bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
  //   var alignment =
  //       isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

  //   return Container(
  //     alignment: alignment,
  //     child: Column(
  //       crossAxisAlignment:
  //           isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  //       children: [
  //         ChatBubble(message: data["message"], isCurrentUser: isCurrentUser)
  //       ],
  //     ),
  //   );
  // }

  // build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextfield(
              controller: _messageController,
              hintText: "Type a message",
              labelText: "none",
              obscureText: false,
            ),
          ),

          // send button
          Container(
            decoration:
                BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(
                onPressed: sendMessage,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }
}
