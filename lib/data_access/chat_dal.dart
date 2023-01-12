import 'package:chatview/chatview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_z_money/business_Logic/actions/auth_actions.dart';

import '../business_Logic/models/CustomUser.dart';

class ChatAccessService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /*
   *
   */
  Stream<List<ChatUser>> getUsers() => _db
      .collection('chat_users')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ChatUser.fromJson(doc.data()))
          .toList());

  /*
   *
   */
  Future uploadMessage(String idUser, String message) async {
    final refMessages =
        _db.collection('chats/$idUser/messages');

    final newMessage = Message(
      id: idUser,  // sendto
      message: message,
      createdAt: DateTime.now(),
      sendBy: AuthActions.currUser.uid,
    );
    await refMessages.add(newMessage.toJson());

    final refUsers = _db.collection('chat_users');
    await refUsers
        .doc(idUser)
        .update({'lastMessageTime': DateTime.now()});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String idUser) =>
      _db.collection('chats/$idUser/messages')
          .snapshots();

}
