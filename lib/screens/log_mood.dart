import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogMoodScreen extends StatefulWidget {
  const LogMoodScreen({super.key});

  @override
  State<LogMoodScreen> createState() => _LogMoodScreenState();
}

class _LogMoodScreenState extends State<LogMoodScreen> {
  String? selectedMood;
  final TextEditingController _noteController = TextEditingController();

  final List<String> moods = ['😊', '😢', '😡', '😰', '😴', '😐'];
  final List<String> moodLabels = ['Happy', 'Sad', 'Angry', 'Anxious', 'Tired', 'Neutral'];

  Future<void> _saveMood() async {
    if (selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a mood.")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final moodEntry = {
      'mood': selectedMood,
      'note': _noteController.text,
      'timestamp': Timestamp.now(),
      'uid': user.uid,
    };

    await FirebaseFirestore.instance.collection('moods').add(moodEntry);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Mood logged!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Mood"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("How do you feel today?", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: List.generate(moods.length, (index) {
                final mood = moods[index];
                final label = moodLabels[index];
                final isSelected = selectedMood == mood;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMood = mood;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.pinkAccent.withOpacity(0.2) : Colors.white,
                          border: Border.all(color: isSelected ? Colors.pinkAccent : Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(mood, style: const TextStyle(fontSize: 28)),
                      ),
                      const SizedBox(height: 4),
                      Text(label, style: GoogleFonts.poppins(fontSize: 12)),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Text("Want to add a note?", style: GoogleFonts.poppins(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Write your thoughts here...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saveMood,
                child: Text("Save Mood", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}