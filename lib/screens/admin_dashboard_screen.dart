import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../models/event_model.dart';
import 'create_event_screen.dart';
import 'event_analytics_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic>? _stats;
  String _selectedFilter = 'all'; // 'all', 'upcoming', 'past'

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      final stats = await context.read<EventProvider>().getEventStatistics();
      setState(() {
        _stats = stats;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading statistics: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () async {
            await context.read<AuthProvider>().signOut();
          },
        ),
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Manage events and track attendance',
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
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateEventScreen(),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              if (value == 'logout') {
                await context.read<AuthProvider>().signOut();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [_buildOverviewTab(), _buildAllEventsTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'All Events',
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    if (_stats == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Events',
                  _stats!['totalEvents'].toString(),
                  Icons.event,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Upcoming Events',
                  _stats!['upcomingEvents'].toString(),
                  Icons.upcoming,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Attendees',
                  _stats!['totalAttendees'].toString(),
                  Icons.people,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Avg. Attendance',
                  _stats!['avgAttendance'].toString(),
                  Icons.trending_up,
                  Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Top Events section
          const Text(
            'Top Events by Attendance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          if ((_stats!['topEvents'] as List<EventModel>).isEmpty)
            const Center(
              child: Text(
                'No events with attendance yet',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ...((_stats!['topEvents'] as List<EventModel>).asMap().entries.map((
              entry,
            ) {
              final index = entry.key;
              final event = entry.value;
              return _buildTopEventCard(index + 1, event);
            })),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopEventCard(int rank, EventModel event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRankColor(rank),
          child: Text(
            rank.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(event.category),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${event.attendees.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${event.capacity > 0 ? (event.attendees.length / event.capacity * 100).round() : 0}% full',
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  Widget _buildAllEventsTab() {
    return Column(
      children: [
        // Filters section
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<List<EventModel>>(
            stream: context.read<EventProvider>().getEventsStream(),
            builder: (context, snapshot) {
              final events = snapshot.data ?? [];
              final now = DateTime.now();
              final startOfToday = DateTime(now.year, now.month, now.day);
              final allCount = events.length;
              final upcomingCount = events
                  .where(
                    (e) =>
                        e.date.isAfter(startOfToday) ||
                        (e.date.year == startOfToday.year &&
                            e.date.month == startOfToday.month &&
                            e.date.day == startOfToday.day),
                  )
                  .length;
              final pastCount = events
                  .where((e) => e.date.isBefore(startOfToday))
                  .length;

              return Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _selectedFilter = 'all'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedFilter == 'all'
                            ? Colors.red
                            : Colors.grey[300],
                        foregroundColor: _selectedFilter == 'all'
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: Text('All Events ($allCount)'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          setState(() => _selectedFilter = 'upcoming'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedFilter == 'upcoming'
                            ? Colors.red
                            : Colors.grey[300],
                        foregroundColor: _selectedFilter == 'upcoming'
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: Text('Upcoming ($upcomingCount)'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _selectedFilter = 'past'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedFilter == 'past'
                            ? Colors.red
                            : Colors.grey[300],
                        foregroundColor: _selectedFilter == 'past'
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: Text('Past ($pastCount)'),
                    ),
                  ),
                ],
              );
            },
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

              final allEvents = snapshot.data ?? [];
              final now = DateTime.now();
              final startOfToday = DateTime(now.year, now.month, now.day);

              // Filter events based on selected filter
              List<EventModel> filteredEvents;
              switch (_selectedFilter) {
                case 'upcoming':
                  filteredEvents = allEvents
                      .where(
                        (e) =>
                            e.date.isAfter(startOfToday) ||
                            (e.date.year == startOfToday.year &&
                                e.date.month == startOfToday.month &&
                                e.date.day == startOfToday.day),
                      )
                      .toList();
                  break;
                case 'past':
                  filteredEvents = allEvents
                      .where((e) => e.date.isBefore(startOfToday))
                      .toList();
                  break;
                default:
                  filteredEvents = allEvents;
              }

              // Sort events - upcoming events by date ascending, past events by date descending
              if (_selectedFilter == 'upcoming') {
                filteredEvents.sort((a, b) => a.date.compareTo(b.date));
              } else if (_selectedFilter == 'past') {
                filteredEvents.sort((a, b) => b.date.compareTo(a.date));
              }

              if (filteredEvents.isEmpty) {
                String emptyMessage;
                switch (_selectedFilter) {
                  case 'upcoming':
                    emptyMessage = 'No upcoming events';
                    break;
                  case 'past':
                    emptyMessage = 'No past events';
                    break;
                  default:
                    emptyMessage = 'No events created yet';
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        emptyMessage,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      if (_selectedFilter == 'all')
                        Text(
                          'Tap the + button to create your first event',
                          style: TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  return _buildAdminEventCard(filteredEvents[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdminEventCard(EventModel event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image
          if (event.imageUrl != null && event.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: event.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(event.category),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        event.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventAnalyticsScreen(event: event),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(event),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  '${event.date.day}/${event.date.month}/${event.date.year}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  event.location,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${event.attendees.length} / ${event.capacity} attending',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    Text(
                      '${event.capacity > 0 ? (event.attendees.length / event.capacity * 100).round() : 0}% full',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                LinearProgressIndicator(
                  value: event.capacity > 0
                      ? event.attendees.length / event.capacity
                      : 0,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    event.attendees.length >= event.capacity
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'workshop':
        return Colors.blue;
      case 'seminar':
        return Colors.green;
      case 'conference':
        return Colors.purple;
      case 'career':
        return Colors.orange;
      case 'social':
        return Colors.pink;
      case 'academic':
        return Colors.indigo;
      case 'sports':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteDialog(EventModel event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text(
          'Are you sure you want to delete "${event.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await context.read<EventProvider>().deleteEvent(event.id);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Event deleted successfully'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  _loadStatistics(); // Refresh stats
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
