import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../models/event_model.dart';
import '../widgets/event_card.dart';
import 'my_events_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<String> _colleges = [
    'All Departments',
    'Computing Education',
    'Arts and Sciences',
    'Teacher Education',
    'Business Administration',
    'Criminology Education',
    'Engineering Education',
  ];

  final List<String> _categories = [
    'All Categories',
    'Workshop',
    'Seminar',
    'Conference',
    'Career',
    'Social',
    'Academic',
    'Sports',
  ];

  // Helper method to map full department names to short names
  String _mapFullDepartmentName(String fullName) {
    switch (fullName) {
      case 'Department of Computing Education':
        return 'Computing Education';
      case 'Department of Arts and Sciences':
        return 'Arts and Sciences';
      case 'Department of Teacher Education':
        return 'Teacher Education';
      case 'Department of Business Administration Education':
        return 'Business Administration';
      case 'Department of Criminology Education':
        return 'Criminology Education';
      case 'Department of Engineering Education':
        return 'Engineering Education';
      default:
        return fullName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 212, 7, 7),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 3, 3),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/UMTC_logo.jpg',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.school, color: Colors.red, size: 20),
                );
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'UMTC Events',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Campus Event Finder',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => _showSettingsBottomSheet(),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [_buildDiscoverEventsTab(), MyEventsScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 236, 0, 0),
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover Events',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.event),
                Positioned(
                  right: 0,
                  top: 0,
                  child: StreamBuilder<List<EventModel>>(
                    stream: context
                        .read<EventProvider>()
                        .getUserRSVPEventsStream(),
                    builder: (context, snapshot) {
                      final count = snapshot.data?.length ?? 0;
                      if (count == 0) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          count.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            label: 'My Events',
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverEventsTab() {
    return Column(
      children: [
        // Filter section
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Department filter
                Consumer<EventProvider>(
                  builder: (context, eventProvider, child) {
                    return DropdownButtonFormField<String>(
                      value: eventProvider.selectedCollege,
                      decoration: const InputDecoration(
                        labelText: 'Filter by Department',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      isExpanded: true,
                      items: _colleges.map((college) {
                        return DropdownMenuItem(
                          value: college,
                          child: Text(
                            college,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          eventProvider.setCollegeFilter(value);
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                // Category filter
                Consumer<EventProvider>(
                  builder: (context, eventProvider, child) {
                    return DropdownButtonFormField<String>(
                      value: eventProvider.selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Filter by Category',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      isExpanded: true,
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(
                            category,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          eventProvider.setCategoryFilter(value);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        // Events list
        Expanded(
          child: StreamBuilder<List<EventModel>>(
            stream: context.read<EventProvider>().getEventsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final events = snapshot.data ?? [];
              final eventProvider = context.watch<EventProvider>();
              final filteredEvents = events.where((event) {
                bool collegeMatch =
                    eventProvider.selectedCollege == 'All Departments' ||
                    _mapFullDepartmentName(event.college) ==
                        eventProvider.selectedCollege;
                bool categoryMatch =
                    eventProvider.selectedCategory == 'All Categories' ||
                    event.category == eventProvider.selectedCategory;
                return collegeMatch && categoryMatch;
              }).toList();

              if (filteredEvents.isEmpty) {
                return Container(
                  color: Colors.grey[100],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No events found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Try adjusting your filters',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Container(
                color: Colors.grey[100],
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    return EventCard(event: filteredEvents[index]);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showSettingsBottomSheet() {
    final authProvider = context.read<AuthProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.red),
                title: const Text('Full Name'),
                subtitle: Text(authProvider.user?.fullName ?? ''),
                trailing: TextButton(
                  onPressed: () {
                    // TODO: Edit profile
                  },
                  child: const Text('Edit'),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.email, color: Colors.red),
                title: const Text('Email'),
                subtitle: Text(authProvider.user?.email ?? ''),
              ),
              ListTile(
                leading: const Icon(Icons.school, color: Colors.red),
                title: const Text('College'),
                subtitle: Text(authProvider.user?.college ?? ''),
              ),
              ListTile(
                leading: const Icon(Icons.book, color: Colors.red),
                title: const Text('Course/Program'),
                subtitle: Text(authProvider.user?.courseProgram ?? ''),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    authProvider.signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
