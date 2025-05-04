import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iPocket/widgets/notification_item.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final user = FirebaseAuth.instance.currentUser;

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffDAA520),
        title: const Text(
          "Notifications",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:
          user == null
              ? const Center(child: Text("User not logged in"))
              : StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.email)
                        .collection('notifications')
                        .orderBy('time', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No notifications yet."));
                  }

                  var notifications =
                      snapshot.data!.docs.map((doc) {
                        var data = doc.data() as Map<String, dynamic>;
                        return {
                          "title": data["title"] ?? "No Title",
                          "message": data["message"] ?? "No Message",
                          "time": formatTimestamp(data["time"]),
                        };
                      }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return NotificationItem(
                        title: notifications[index]["title"]!,
                        message: notifications[index]["message"]!,
                        time: notifications[index]["time"]!,
                      );
                    },
                  );
                },
              ),
    );
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Unknown Time";
    DateTime dateTime = timestamp.toDate();
    return DateFormat("dd MMM, hh:mm a").format(dateTime);
  }
}
