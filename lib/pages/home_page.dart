import 'package:flutter/material.dart';
import 'package:free/pages/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _quote = 'Fetching your personalized quote...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://personalized-quote.onrender.com/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"text": "hello"}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final quoteText = data['quote']?['text'] ?? '';
        final author = data['quote']?['author'] ?? '';

        setState(() {
          _quote = quoteText.isNotEmpty
              ? '"$quoteText"\n\n~ $author'
              : "No quote returned.";
        });
      } else {
        setState(() {
          _quote = "Server error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _quote = "Failed to connect to server.";
      });
    }

    setState(() => _isLoading = false);
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text("Did this quote help?"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.thumb_up,
                  color: Color.fromARGB(255, 135, 255, 88),
                  size: 32,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _handleFeedback(true);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.thumb_down,
                  color: Color.fromARGB(255, 255, 88, 88),
                  size: 32,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _handleFeedback(false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleFeedback(bool isHelpful) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isHelpful ? 'Glad it helped!' : 'We’ll do better next time.',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kPrimaryBlue,
      body: SafeArea(
        child: Column(
          children: [
            // 🔝 Quote Box
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () => _showFeedbackDialog(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              _quote,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                ),
              ),
            ),

            // 🧸 Animation
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Transform.scale(
                    scale: 1.6,
                    child: Lottie.asset(
                      'lib/animations/home.json',
                      repeat: true,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

            // ⬇️ Bottom Buttons
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: (screenWidth - 54) / 2,
                      height: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/community'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Community"),
                      ),
                    ),
                    const SizedBox(width: 14),
                    SizedBox(
                      width: (screenWidth - 54) / 2,
                      height: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/chatbotpage'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Let's Talk"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
