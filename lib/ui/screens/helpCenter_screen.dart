import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final List<Map<String, String>> data = [
    {
      "title": "What is Yoga?",
      "description": "Learn about the basics of Yoga."
    },
    {
      "title": "Benefits of Yoga",
      "description": "Explore the health benefits."
    },
    {
      "title": "Beginner Yoga Tips",
      "description": "Start your journey easily."
    },
    {"title": "Yoga Class Timings", "description": "Know our schedule."},
    {"title": "Yoga for Stress Relief", "description": "Relax with Yoga."},
    {"title": "What to Wear", "description": "Dress code for classes."},
    {"title": "Advanced Yoga Poses", "description": "Challenge yourself!"},
    {
      "title": "Private Yoga Sessions",
      "description": "Get personalized sessions."
    },
    {
      "title": "Meditation with Yoga",
      "description": "Combine meditation and Yoga."
    },
    {"title": "Yoga Teacher Profiles", "description": "Meet our instructors."},
  ];

  final List<Map<String, String>> additionalData = [
    {"title": "Yoga Diet Tips", "description": "Eat right for your practice."},
    {"title": "Online Yoga Classes", "description": "Join from anywhere."},
    {"title": "Yoga History", "description": "Discover Yoga's origins."},
    {"title": "Family Yoga", "description": "Practice Yoga with kids."},
    {
      "title": "Breathing Techniques",
      "description": "Improve breathing with Yoga."
    },
    {"title": "Prenatal Yoga", "description": "Yoga for expecting mothers."},
    {"title": "Yoga Retreats", "description": "Plan your next retreat."},
    {"title": "Corporate Yoga", "description": "Bring Yoga to the workplace."},
    {
      "title": "Yoga for Flexibility",
      "description": "Improve your flexibility."
    },
    {"title": "Yoga Equipment Guide", "description": "What tools do you need?"},
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Help center",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Color(0xFF6D674B),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Height of the line
          child: Container(
            color: const Color(0xFF6D674B), // Line color
            width: 50,
            height: 1.0, // Line thickness
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Contact",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF323232),
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF323232)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          buildSearchBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ...buildFAQSection(data),
                ...buildFAQSection(additionalData),
              ],
            ),
          ),
          buildFooter(),
        ],
      ),
    );
  }

  // Search bar section
  Widget buildSearchBar() {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          height: 120,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.search, color: Colors.grey),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Search keywords",
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: const Color(0xFF323232),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          searchQuery = "";
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // FAQ Section builder
  List<Widget> buildFAQSection(List<Map<String, String>> faqData) {
    return faqData
        .where((item) =>
            item["title"]!.toLowerCase().contains(searchQuery.toLowerCase()))
        .map((item) {
      return Container(
        color: Colors.white, // Đặt màu nền trắng
        child: Column(
          children: [
            ListTile(
              title: Text(
                item["title"]!,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Color(0xFF323232),
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                item["description"]!,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Color(0xFF7B7B7B),
                ),
              ),
            ),
            Divider(
              color: const Color(0xFF7B7B7B).withOpacity(0.5),
              thickness: 1,
            ),
          ],
        ),
      );
    }).toList();
  }

  // Footer section
  Widget buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextButton.icon(
        onPressed: () {
          // Add "See More" functionality here
        },
        label: const Text("See more",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Color(0xFF323232),
            )),
        icon: const Icon(Icons.expand_more, color: Color(0xFF323232)),
      ),
    );
  }
}
