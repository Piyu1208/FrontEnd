import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, String>> posts = [
    {"name": "Aayush", "message": "This is a great feature!"},
    {"name": "Piyush", "message": "Feeling better today"},
    {"name": "Rhea", "message": "Burnout is real. Thanks for the quotes."},
  ];

  final Map<String, int> likeCounts = {};
  final Map<String, bool> liked = {};

  void addPost(String name, String message) {
    setState(() {
      posts.insert(0, {"name": name, "message": message});
      likeCounts[message] = 0;
      liked[message] = false;
      _controller.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    for (var post in posts) {
      likeCounts[post["message"]!] = 0;
      liked[post["message"]!] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 152, 182, 236),
      body: SafeArea(
        child: Column(
          children: [
            // 🔝 Input Box
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.person, color: Colors.black),
                        ),
                        SizedBox(width: 12),
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
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          if (_controller.text.trim().isNotEmpty) {
                            addPost("You", _controller.text.trim());
                          }
                        },
                        child: Text("Post"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🧾 Feed — now fully expanded
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(12),
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return _communityPost(post["name"]!, post["message"]!);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _communityPost(String name, String message) {
    return GestureDetector(
      onTap: () {
        setState(() {}); // Could be expanded logic if needed later
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(message, style: TextStyle(fontSize: 13)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    liked[message]! ? Icons.favorite : Icons.favorite_border,
                    color: liked[message]! ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      liked[message] = !liked[message]!;
                      likeCounts[message] = liked[message]!
                          ? likeCounts[message]! + 1
                          : likeCounts[message]! - 1;
                    });
                  },
                ),
                Text("${likeCounts[message]}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
