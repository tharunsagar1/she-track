import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shetrackv1/screens/log_mood.dart';
import 'package:shetrackv1/screens/log_period_screen.dart';
import 'package:shetrackv1/screens/profile_screen.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current date in formatted string
    final today = DateFormat('MMMM d, yyyy').format(DateTime.now());
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F9),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with user welcome and profile
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, Aanya",
                          style: GoogleFonts.poppins(
                            fontSize: 24, 
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF442C2E),
                          )
                        ),
                        const SizedBox(height: 4),
                        Text(
                          today,
                          style: GoogleFonts.poppins(
                            fontSize: 14, 
                            color: Colors.grey[600]
                          )
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.pink.shade100, width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const CircleAvatar(
                          backgroundImage: AssetImage("assets/images/profile.jpg"),
                          radius: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Cycle status card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: _buildCycleStatusCard(context),
              ),
            ),
            
            // Health insights cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your Health Today",
                          style: GoogleFonts.poppins(
                            fontSize: 18, 
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF442C2E),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/health_insights');
                          },
                          child: Text(
                            "See All",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFFE75A7C),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildHealthInsightsCards(context),
                  ],
                ),
              ),
            ),
            
            // Quick actions section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quick Actions",
                      style: GoogleFonts.poppins(
                        fontSize: 18, 
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF442C2E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildQuickActions(context),
                  ],
                ),
              ),
            ),
            
            // Wellness insights
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Wellness Insights",
                          style: GoogleFonts.poppins(
                            fontSize: 18, 
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF442C2E),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/wellness_library');
                          },
                          child: Text(
                            "View All",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFFE75A7C),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTipCards(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 0, // Home is selected
          onTap: (index) {
            if (index != 0) { // If not home
              final routes = [
                '/', // Home
                '/calendarScreen' ,
                '/track',
                '/profile',
              ];
              Navigator.pushNamed(context, routes[index]);
            }
          },
          selectedItemColor: const Color(0xFFE75A7C),
          unselectedItemColor: Colors.grey[500],
          showUnselectedLabels: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home",),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: "Calendar"),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: "Track"),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showQuickLogBottomSheet(context);
        },
        backgroundColor: const Color(0xFFE75A7C),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Quick log options bottom sheet
  void _showQuickLogBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Quick Log",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF442C2E),
                ),
              ),
              const SizedBox(height: 16),
              _buildQuickLogOption(
                context, 
                "Log Period", 
                Icons.water_drop_rounded, 
                const Color(0xFFE75A7C),
               () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  LogPeriodScreen()),
                ),
              ),
              _buildQuickLogOption(
                context, 
                "Log Mood", 
                Icons.sentiment_satisfied_alt_rounded, 
                const Color(0xFF8FC93A),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogMoodScreen()),
                ),
              ),
              _buildQuickLogOption(
                context, 
                "Log Symptoms", 
                Icons.healing_rounded, 
                const Color(0xFF4F86C6),
                () => Navigator.pushNamed(context, '/symptoms'),
              ),
              _buildQuickLogOption(
                context, 
                "Add Water", 
                Icons.water_drop_outlined, 
                const Color(0xFF2D82B5),
                () => Navigator.pushNamed(context, '/water_tracker'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Quick log option item
  Widget _buildQuickLogOption(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF442C2E),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleStatusCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/cycle_details');
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE75A7C),
              Color(0xFFD96AA7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE75A7C).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Cycle",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Day 2",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Period Phase",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "5 days remaining",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: 0.28,
                        strokeWidth: 6,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      Text(
                        "28%",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Your next period is expected on April 30",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white,
                      ),
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

  Widget _buildHealthInsightsCards(BuildContext context) {
    final insights = [
      {
        "title": "Mood",
        "value": "😊 Happy",
        "icon": Icons.sentiment_very_satisfied_rounded,
        "color": const Color(0xFF8FC93A),
        "screen": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LogMoodScreen()),
        ),
      },
      {
        "title": "Water",
        "value": "5/8 cups",
        "icon": Icons.water_drop_rounded,
        "color": const Color(0xFF2D82B5),
        "screen": () => Navigator.pushNamed(context, '/water_tracker'),
      },
      {
        "title": "Sleep",
        "value": "7h 20m",
        "icon": Icons.nightlight_round,
        "color": const Color(0xFF4F86C6),
        "screen": () => Navigator.pushNamed(context, '/sleep_tracker'),
      },
      {
        "title": "Exercise",
        "value": "20 min",
        "icon": Icons.fitness_center_rounded,
        "color": const Color(0xFFE98A15),
        "screen": () => Navigator.pushNamed(context, '/exercise_tracker'),
      },
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: insights.length,
        itemBuilder: (context, index) {
          final item = insights[index];
          return GestureDetector(
            onTap: item["screen"] as Function(),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (item["color"] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item["icon"] as IconData,
                      color: item["color"] as Color,
                      size: 22,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    item["title"] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["value"] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF442C2E),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {
        "icon": Icons.water_drop_rounded, 
        "label": "Track Period", 
        "color": const Color(0xFFE75A7C),
        "screen": '/track_period'
      },
      {
        "icon": Icons.restaurant_rounded, 
        "label": "Log Nutrition", 
        "color": const Color(0xFF8FC93A),
        "screen": '/log_nutrition'
      },
      {
        "icon": Icons.spa_rounded, 
        "label": "Mindfulness", 
        "color": const Color(0xFFEA5C2B),
        "screen": '/mindfulness'
      },
      {
        "icon": Icons.insights_rounded, 
        "label": "Health Insights", 
        "color": const Color(0xFF9BA7C0),
        "screen": '/health_insights'
      },
      {
        "icon": Icons.medication_rounded, 
        "label": "Medications", 
        "color": const Color(0xFF4F86C6),
        "screen": '/medications'
      },
      {
        "icon": Icons.edit_note_rounded, 
        "label": "Symptoms", 
        "color": const Color(0xFFD96AA7),
        "screen": '/symptoms'
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final item = actions[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, item["screen"] as String);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade100, blurRadius: 8),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (item["color"] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item["icon"] as IconData,
                    size: 24,
                    color: item["color"] as Color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item["label"].toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF442C2E),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTipCards(BuildContext context) {
    final tips = [
      {
        "icon": Icons.self_improvement_rounded,
        "title": "Mindful Breathing",
        "description": "Take 5 minutes today to breathe deeply and stretch. Your mind and body will thank you!",
        "color": const Color(0xFFF8BBD0),
        "screen": '/mindfulness'
      },
      {
        "icon": Icons.water_drop_rounded,
        "title": "Hydration Reminder",
        "description": "Try adding lemon to your water for both flavor and vitamin C boost during your period.",
        "color": const Color(0xFFBBDEFB),
        "screen": '/water_tracker'
      }
    ];

    return Column(
      children: tips.map((tip) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, tip["screen"] as String);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (tip["color"] as Color).withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    tip["icon"] as IconData,
                    size: 26,
                    color: tip["color"] as Color,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip["title"] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF442C2E),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tip["description"] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF442C2E).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
