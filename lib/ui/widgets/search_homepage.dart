import 'package:flutter/material.dart';

class SearchHomePage extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSearchChanged;

  SearchHomePage({
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.onSearchChanged,
  });

  final List<String> _filterOptions = [
    'courses name',
    'class instance',
    'category'
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search by $selectedFilter',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 10),
        PopupMenuButton<String>(
          onSelected: (String newValue) {
            onFilterChanged(newValue);
          },
          icon: Icon(Icons.filter_list, color: Colors.grey),
          itemBuilder: (BuildContext context) {
            return _filterOptions.map((String value) {
              return PopupMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}
