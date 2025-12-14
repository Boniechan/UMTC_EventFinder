import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final hasRSVPd = eventProvider.hasUserRSVPd(event);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                children: [
                  if (event.imageUrl != null && event.imageUrl!.isNotEmpty)
                    // Real event image
                    CachedNetworkImage(
                      imageUrl: event.imageUrl!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.blue[100],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue[300]!, Colors.blue[600]!],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.event,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  else
                    // Placeholder for event image
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue[300]!, Colors.blue[600]!],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.event,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  // Category tag
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
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
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event title
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Event description
                Text(
                  event.description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Event details
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('EEE, MMM d').format(event.date),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${event.startTime} - ${event.endTime}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Attendance info
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${event.attendees.length} attending • ${event.availableSpots} spots left',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Progress bar
                LinearProgressIndicator(
                  value: event.fillPercentage / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    event.isFull ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${event.fillPercentage.round()}% Full',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // RSVP button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: event.isFull && !hasRSVPd
                        ? null
                        : () => _handleRSVP(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasRSVPd
                          ? Colors.green
                          : const Color(0xFF8B1538),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      hasRSVPd
                          ? 'RSVP\'d'
                          : event.isFull
                          ? '50 capacity'
                          : 'RSVP Now',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
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

  void _handleRSVP(BuildContext context) {
    final eventProvider = context.read<EventProvider>();
    final hasRSVPd = eventProvider.hasUserRSVPd(event);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(hasRSVPd ? 'Cancel RSVP' : 'RSVP to Event'),
        content: Text(
          hasRSVPd
              ? 'Are you sure you want to cancel your RSVP for "${event.title}"?'
              : 'Are you sure you want to RSVP for "${event.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                if (hasRSVPd) {
                  await eventProvider.cancelRSVP(event.id);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('RSVP cancelled successfully'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                } else {
                  await eventProvider.rsvpToEvent(event.id);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('RSVP successful!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) {
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
            style: ElevatedButton.styleFrom(
              backgroundColor: hasRSVPd
                  ? Colors.orange
                  : const Color(0xFF8B1538),
            ),
            child: Text(hasRSVPd ? 'Cancel RSVP' : 'Confirm RSVP'),
          ),
        ],
      ),
    );
  }
}
