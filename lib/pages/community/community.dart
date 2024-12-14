import 'package:elderly_care/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elderly_care/controller/profile_controller.dart';
import 'package:elderly_care/service/chat_service.dart';
import 'package:elderly_care/pages/community/chat_page.dart';
import 'package:elderly_care/pages/community/user_tile.dart';

class Community extends StatelessWidget {
  final ChatService _chatService = ChatService();
  final ProfileController profileController = Get.put(ProfileController());

  Community({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Community")),
      body: _buildUserList(),
    );
  }

  // builds a list of users except for the currently logged-in user
  Widget _buildUserList() {
    return FutureBuilder<UserModel?>(
      future: profileController.getUserData(),
      builder: (context, snapshot) {
        // Error state
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading user data."));
        }

        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // No data state
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No user data found."));
        }

        final currentUser = snapshot.data!;
        final currentUserEmail = currentUser.email;

        return StreamBuilder<List<UserModel>>(
          stream: _chatService.getUsersStream(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.hasError) {
              return const Center(child: Text("Error loading users."));
            }

            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!streamSnapshot.hasData || streamSnapshot.data!.isEmpty) {
              return const Center(child: Text("No users found."));
            }

            // Filter out the current user
            final otherUsers = streamSnapshot.data!
                .where((user) => user.email != currentUserEmail)
                .toList();

            if (otherUsers.isEmpty) {
              return const Center(child: Text("No other users available."));
            }

            return ListView.builder(
              itemCount: otherUsers.length,
              itemBuilder: (context, index) {
                final user = otherUsers[index];
                return UserTile(
                  text: user.fullName,
                  onTap: () {
                    if (user.email != null && user.uid != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            receiverEmail: user.email!,
                            receiverID: user.uid!,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Cannot start chat, email or UID is missing."),
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  // Build individual list item for each user
  Widget _buildUserListItem(Map<String, dynamic> userData,
      String currentUserEmail, BuildContext context) {
    if (userData["Email"] != currentUserEmail) {
      return UserTile(
        text: userData["Email"] ?? "Unknown User", // Fallback if email is null
        onTap: () {
          final email = userData["Email"];
          final receiverID = userData["uid"];

          if (email != null && receiverID != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverEmail: email,
                  receiverID:
                      receiverID, // Pass the Firestore document ID as UID
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Cannot start chat, email or UID is missing.")),
            );
          }
        },
      );
    } else {
      return Container();
    }
  }
}
