import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/models/message.dart';
import 'package:elderly_care/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get Users Stream
  Stream<List<UserModel>> getUsersStream() {
    return _firestore.collection("USERS").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        return UserModel(
          uid: doc.id,
          fullName: data['FullName'] ?? '',
          email: data['Email'] ?? '',
          phoneNo: data['Phone'] ?? '',
          address: data['Address'] ?? '',
          role: data['Role'] ?? 'customer',
        );
      }).toList();
    });
  }

  // Retrieve current user model
  Future<UserModel?> getCurrentUserModel() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        Get.snackbar("Error", "No user is logged in.");
        return null;
      }

      final docSnapshot =
          await _firestore.collection('USERS').doc(currentUser.uid).get();
      if (docSnapshot.exists) {
        return UserModel.fromSnapshot(docSnapshot);
      } else {
        Get.snackbar("Error", "No user data found for UID: ${currentUser.uid}");
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching user model: $e");
      return null;
    }
  }

  Future<void> sendMessage(String receiverID, String message) async {
    try {
      String senderID = FirebaseAuth.instance.currentUser!.uid;
      String senderEmail = FirebaseAuth.instance.currentUser!.email!;

      List<String> ids = [senderID, receiverID];
      ids.sort(); // Sort to ensure consistent chat room ID
      String chatRoomID = ids.join('_');

      // Create a message object
      Message newMessage = Message(
        senderID: senderID,
        senderEmail: senderEmail,
        receiverID: receiverID,
        message: message,
        timestamp: Timestamp.now(),
      );

      // Save message to Firestore
      await _firestore
          .collection('CHAT_ROOM')
          .doc(chatRoomID)
          .collection('MESSAGES')
          .add(newMessage
              .toMap()); // Add the message to the Firestore collection

      print("Message sent to Firestore: ${newMessage.toMap()}");
    } catch (e) {
      print("Error sending message to Firestore: $e");
      throw e;
    }
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String senderID, String receiverID) {
    try {
      if (senderID.isEmpty || receiverID.isEmpty) {
        Get.snackbar("Error", "Sender or Receiver ID is empty");
        return Stream.empty();
      }

      List<String> ids = [senderID, receiverID];
      ids.sort(); // Ensure consistent chat room ID
      String chatRoomID = ids.join('_');

      return _firestore
          .collection("CHAT_ROOM")
          .doc(chatRoomID)
          .collection("MESSAGES")
          .orderBy("timestamp", descending: false)
          .snapshots();
    } catch (e) {
      Get.snackbar("Error", "Error fetching messages: $e");
      return Stream.empty(); // Return empty stream in case of error
    }
  }
}
