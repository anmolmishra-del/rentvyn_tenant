import 'package:flutter/material.dart';
import 'package:rentvyn_tenant/core/constants/app_colors.dart';

class ExplorePgsView extends StatefulWidget {
  const ExplorePgsView({super.key, required bool isNested});

  @override
  State<ExplorePgsView> createState() => _ExplorePgsViewState();
}

class _ExplorePgsViewState extends State<ExplorePgsView> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allHostels = const [
    {
      'name': 'Stanza Living Premium Boys PG',
      'location': 'Sector 62, Noida',
      'price': '₹14,500/mo',
      'rating': 4.9,
      'gender': 'Boys Only',
      'color': Colors.blue,
    },
    {
      'name': 'Nest & Co Premium Girls PG',
      'location': 'Sector 22, Gurgaon',
      'price': '₹12,500/mo',
      'rating': 4.8,
      'gender': 'Girls Only',
      'color': Colors.pink,
    },
    {
      'name': 'Zolo Stay Luxury Co-Living',
      'location': 'Whitefield, Bangalore',
      'price': '₹15,000/mo',
      'rating': 4.6,
      'gender': 'Co-living',
      'color': Colors.indigo,
    },
    {
      'name': 'Saraswati Hostel & PG',
      'location': 'Katraj, Pune',
      'price': '₹8,500/mo',
      'rating': 4.2,
      'gender': 'Boys Only',
      'color': Colors.teal,
    },
  ];

  List<Map<String, dynamic>> _filteredHostels = [];

  @override
  void initState() {
    super.initState();
    _filteredHostels = _allHostels;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredHostels = _allHostels;
      } else {
        _filteredHostels = _allHostels.where((hostel) {
          final name = hostel['name'].toString().toLowerCase();
          final location = hostel['location'].toString().toLowerCase();
          return name.contains(query) || location.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white, // Pure white background
      appBar: AppBar(
        title: const Text('Explore Hostels & PGs', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: theme.iconTheme,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or area...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ),
          // Filter Chips Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All Rooms', true, theme),
                  _buildFilterChip('Single Sharing', false, theme),
                  _buildFilterChip('Double Sharing', false, theme),
                  _buildFilterChip('AC Rooms', false, theme),
                  _buildFilterChip('Gym Facility', false, theme),
                ],
              ),
            ),
          ),
          // Hostels list
          Expanded(
            child: _filteredHostels.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No PGs found matching your search',
                          style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _filteredHostels.length,
                    itemBuilder: (context, index) {
                      final hostel = _filteredHostels[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            // Image Thumbnail simulation
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: hostel['color'].withOpacity(0.1),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.home_filled,
                                  color: hostel['color'],
                                  size: 40,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: hostel['color'].withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            hostel['gender'],
                                            style: TextStyle(
                                              color: hostel['color'],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                                            Text(
                                              '${hostel['rating']}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      hostel['name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      hostel['location'],
                                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          hostel['price'],
                                          style: TextStyle(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {},
        backgroundColor: Colors.white,
        selectedColor: theme.colorScheme.primary.withOpacity(0.15),
        checkmarkColor: theme.colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected ? theme.colorScheme.primary : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? theme.colorScheme.primary.withOpacity(0.3) : Colors.grey[300]!,
          ),
        ),
      ),
    );
  }
}
