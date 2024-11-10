import 'package:flutter/material.dart';
import 'package:yinyoga_customer/models/course_model.dart';

class CategoryCard extends StatelessWidget {
  final Course course;

  CategoryCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(course.imageUrl), // Assuming you have an imageUrl field
          Text(course.courseName),
          Text('Capacity: ${course.capacity}'),
          Text('Price: ${course.price}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // Add to cart logic
                },
              ),
              ElevatedButton(
                onPressed: () {
                  // Booking logic
                },
                child: Text('Booking Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
