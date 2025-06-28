// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:free/pages/colors.dart';

// class CommunityPage extends StatefulWidget {
//   const CommunityPage({super.key});

//   @override
//   State<CommunityPage> createState() => _CommunityPageState();
// }

// class _CommunityPageState extends State<CommunityPage> {
//   final TextEditingController _controller = TextEditingController();

//   Future<void> _addPost(String message) async {
//     if (message.isEmpty) return;

//     final user = FirebaseAuth.instance.currentUser;
//     final name = user?.displayName ?? _generateRandomUsername();

//     await FirebaseFirestore.instance.collection('posts').add({
//       'name': name,
//       'message': message,
//       'timestamp': FieldValue.serverTimestamp(),
//       'likes': 0,
//     });

//     _controller.clear();
//   }

//   Future<void> _toggleLike(DocumentSnapshot doc) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     final userId = user.uid;
//     final postRef = doc.reference;
//     final likeRef = postRef.collection('likes').doc(userId);

//     final likeDoc = await likeRef.get();

//     if (!likeDoc.exists) {
//       await likeRef.set({'liked': true});
//       await postRef.update({'likes': FieldValue.increment(1)});
//     } else {
//       await likeRef.delete();
//       await postRef.update({'likes': FieldValue.increment(-1)});
//     }
//   }

//   Future<bool> _hasLiked(DocumentSnapshot doc) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return false;

//     final likeDoc = await doc.reference.collection('likes').doc(user.uid).get();
//     return likeDoc.exists;
//   }

//   String _generateRandomUsername() {
//     final adjectives = ['Cool', 'Happy', 'Bright', 'Brave', 'Chill'];
//     final animals = ['Otter', 'Fox', 'Koala', 'Panda', 'Lion'];
//     final now = DateTime.now().millisecondsSinceEpoch;
//     return '${adjectives[now % adjectives.length]}${animals[now % animals.length]}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kPrimaryBlue,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Post Box
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.95),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         const CircleAvatar(
//                           radius: 22,
//                           backgroundColor: Colors.black26,
//                           child: Icon(Icons.person, color: Colors.black),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: TextField(
//                             controller: _controller,
//                             decoration: InputDecoration(
//                               hintText: "What's on your mind?",
//                               filled: true,
//                               fillColor: Colors.grey[200],
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () => _addPost(_controller.text.trim()),
//                         child: const Text("Post"),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Feed
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('posts')
//                       .orderBy('timestamp', descending: true)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return const Center(
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       );
//                     }

//                     final docs = snapshot.data!.docs;

//                     return ListView.builder(
//                       itemCount: docs.length,
//                       itemBuilder: (context, index) {
//                         final doc = docs[index];
//                         return FutureBuilder<bool>(
//                           future: _hasLiked(doc),
//                           builder: (context, likeSnap) {
//                             final liked = likeSnap.data ?? false;
//                             return _buildPost(doc, liked);
//                           },
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPost(DocumentSnapshot doc, bool liked) {
//     final name = doc['name'] ?? 'Anonymous';
//     final message = doc['message'] ?? '';
//     final likes = doc['likes'] ?? 0;

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.95),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             name,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//           ),
//           const SizedBox(height: 4),
//           Text(message, style: const TextStyle(fontSize: 13)),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   liked ? Icons.favorite : Icons.favorite_border,
//                   color: liked ? Colors.red : Colors.grey,
//                 ),
//                 onPressed: () => _toggleLike(doc),
//               ),
//               Text('$likes'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:free/pages/colors.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _addPost(String message) async {
    if (message.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final name = userDoc.exists && userDoc.data()!.containsKey('username')
        ? userDoc['username']
        : 'Anonymous';

    await FirebaseFirestore.instance.collection('posts').add({
      'name': name,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'likes': 0,
    });

    _controller.clear();
  }

  Future<void> _toggleLike(DocumentSnapshot doc) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userId = user.uid;
    final postRef = doc.reference;
    final likeRef = postRef.collection('likes').doc(userId);

    final likeDoc = await likeRef.get();

    if (!likeDoc.exists) {
      await likeRef.set({'liked': true});
      await postRef.update({'likes': FieldValue.increment(1)});
    } else {
      await likeRef.delete();
      await postRef.update({'likes': FieldValue.increment(-1)});
    }
  }

  Future<bool> _hasLiked(DocumentSnapshot doc) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final likeDoc = await doc.reference.collection('likes').doc(user.uid).get();
    return likeDoc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryBlue,
      body: SafeArea(
        child: Column(
          children: [
            // Post Box
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.black26,
                          child: Icon(Icons.person, color: Colors.black),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: "What's on your mind?",
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _addPost(_controller.text.trim()),
                        child: const Text("Post"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Feed
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        return FutureBuilder<bool>(
                          future: _hasLiked(doc),
                          builder: (context, likeSnap) {
                            final liked = likeSnap.data ?? false;
                            return _buildPost(doc, liked);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPost(DocumentSnapshot doc, bool liked) {
    final name = doc['name'] ?? 'Anonymous';
    final message = doc['message'] ?? '';
    final likes = doc['likes'] ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(message, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  color: liked ? Colors.red : Colors.grey,
                ),
                onPressed: () => _toggleLike(doc),
              ),
              Text('$likes'),
            ],
          ),
        ],
      ),
    );
  }
}
