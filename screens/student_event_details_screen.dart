import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';

class StudentEventDetailsScreen extends StatefulWidget {
  final EventModel event;

  const StudentEventDetailsScreen({super.key, required this.event});

  @override
  State<StudentEventDetailsScreen> createState() =>
      _StudentEventDetailsScreenState();
}

class _StudentEventDetailsScreenState extends State<StudentEventDetailsScreen> {
  late DateFormat dateFormat;
  late DateFormat timeFormat;

  @override
  void initState() {
    super.initState();
    dateFormat = DateFormat('MMMM d, yyyy');
    timeFormat = DateFormat('h:mm a');
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final hasRSVPd = eventProvider.hasUserRSVPd(widget.event);
    final attendancePercentage = widget.event.capacity > 0
        ? (widget.event.attendees.length / widget.event.capacity * 100)
        : 0.0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B1538),
        elevation: 0,
        title: const Text('Event Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Header
            _buildEventHeader(),
            const SizedBox(height: 24),

            // Event Details Section
            _buildDetailsSection(),
            const SizedBox(height: 24),

            // Attendance Stats
            _buildAttendanceStats(attendancePercentage),
            const SizedBox(height: 24),

            // Event Description
            _buildDescriptionSection(),
            const SizedBox(height: 24),

            // Tags Section
            if (widget.event.tags.isNotEmpty) _buildTagsSection(),
            const SizedBox(height: 24),

            // RSVP Button
            _buildRSVPButton(hasRSVPd),
          ],
        ),
      ),
    );
  }

  Widget _buildEventHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image
          if (widget.event.imageUrl != null &&
              widget.event.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                widget.event.imageUrl!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage(250);
                },
              ),
            )
          else
            _buildPlaceholderImage(250),

          // Title and Category
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(widget.event.category),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.event.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.event, color: const Color(0xFF8B1538), size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.event.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage(double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[300]!, Colors.blue[600]!],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: const Center(
        child: Icon(Icons.event, size: 80, color: Colors.white),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Event Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Date & Time
            _buildDetailRow(
              icon: Icons.calendar_today,
              title: 'Date',
              value: dateFormat.format(widget.event.date),
            ),
            const SizedBox(height: 12),

            _buildDetailRow(
              icon: Icons.access_time,
              title: 'Time',
              value: '${widget.event.startTime} - ${widget.event.endTime}',
            ),
            const SizedBox(height: 12),

            _buildDetailRow(
              icon: Icons.location_on,
              title: 'Location',
              value: widget.event.location,
            ),
            const SizedBox(height: 12),

            _buildDetailRow(
              icon: Icons.business,
              title: 'College/Department',
              value: widget.event.college,
            ),
            const SizedBox(height: 12),

            _buildDetailRow(
              icon: Icons.person,
              title: 'Organizer',
              value: widget.event.organizer,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF8B1538)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceStats(double attendancePercentage) {
    final isFull = widget.event.isFull;

    return Card(
      elevation: 2,
      color: isFull ? Colors.red[50] : Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attendance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Progress bar
            LinearProgressIndicator(
              value: widget.event.capacity > 0
                  ? widget.event.attendees.length / widget.event.capacity
                  : 0,
              minHeight: 12,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                isFull ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attending',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.event.attendees.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Capacity',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.event.capacity}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Fill Status',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${attendancePercentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isFull ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isFull ? Colors.red : Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isFull ? '🔴 FULL' : '🟢 SPOTS AVAILABLE',
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
    );
  }

  Widget _buildDescriptionSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              widget.event.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tags',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.event.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRSVPButton(bool hasRSVPd) {
    final isFull = widget.event.isFull;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isFull && !hasRSVPd
            ? null
            : () => _handleRSVP(context, hasRSVPd),
        style: ElevatedButton.styleFrom(
          backgroundColor: hasRSVPd ? Colors.green : const Color(0xFF8B1538),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          hasRSVPd
              ? '✓ RSVP\'d'
              : isFull
              ? 'Event Full - Cannot RSVP'
              : 'RSVP to Event',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  void _handleRSVP(BuildContext context, bool hasRSVPd) {
    final eventProvider = context.read<EventProvider>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(hasRSVPd ? 'Cancel RSVP' : 'RSVP to Event'),
        content: Text(
          hasRSVPd
              ? 'Are you sure you want to cancel your RSVP for "${widget.event.title}"?'
              : 'Are you sure you want to RSVP for "${widget.event.title}"?',
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
                  await eventProvider.cancelRSVP(widget.event.id);
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
                  await eventProvider.rsvpToEvent(widget.event.id);
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
}
