import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/event_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload event image to Firebase Storage
  Future<String> uploadEventImage(File imageFile) async {
    try {
      final String fileName =
          'event_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child(fileName);

      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;

      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  // Create a new event
  Future<void> createEvent(EventModel event) async {
    try {
      await _firestore.collection('events').doc(event.id).set(event.toMap());
    } catch (e) {
      throw Exception('Error creating event: $e');
    }
  }

  // Get all events stream
  Stream<List<EventModel>> getEventsStream() {
    return _firestore.collection('events').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return EventModel.fromMap(doc.data());
      }).toList();
    });
  }

  // Get events by category
  Stream<List<EventModel>> getEventsByCategory(String category) {
    if (category == 'All Categories') {
      return getEventsStream();
    }
    return _firestore
        .collection('events')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return EventModel.fromMap(doc.data());
          }).toList();
        });
  }

  // Get events by college
  Stream<List<EventModel>> getEventsByCollege(String college) {
    if (college == 'All Colleges') {
      return getEventsStream();
    }
    return _firestore
        .collection('events')
        .where('college', isEqualTo: college)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return EventModel.fromMap(doc.data());
          }).toList();
        });
  }

  // Get user's RSVP'd events
  Stream<List<EventModel>> getUserRSVPEvents() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('events')
        .where('attendees', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return EventModel.fromMap(doc.data());
          }).toList();
        });
  }

  // RSVP to an event
  Future<void> rsvpToEvent(String eventId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    try {
      await _firestore.collection('events').doc(eventId).update({
        'attendees': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw Exception('Error RSVPing to event: $e');
    }
  }

  // Cancel RSVP
  Future<void> cancelRSVP(String eventId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    try {
      await _firestore.collection('events').doc(eventId).update({
        'attendees': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      throw Exception('Error canceling RSVP: $e');
    }
  }

  // Check if user has RSVP'd to an event
  bool hasUserRSVPd(EventModel event) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return false;
    return event.attendees.contains(userId);
  }

  // Delete event (admin only)
  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      throw Exception('Error deleting event: $e');
    }
  }

  // Update event
  Future<void> updateEvent(EventModel event) async {
    try {
      await _firestore.collection('events').doc(event.id).update(event.toMap());
    } catch (e) {
      throw Exception('Error updating event: $e');
    }
  }

  // Get upcoming events stream
  Stream<List<EventModel>> getUpcomingEventsStream() {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);

    return _firestore
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfToday))
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return EventModel.fromMap(doc.data());
          }).toList()..sort((a, b) => a.date.compareTo(b.date));
        });
  }

  // Get past events stream
  Stream<List<EventModel>> getPastEventsStream() {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);

    return _firestore
        .collection('events')
        .where('date', isLessThan: Timestamp.fromDate(startOfToday))
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return EventModel.fromMap(doc.data());
          }).toList()..sort((a, b) => b.date.compareTo(a.date));
        });
  }

  // Get event statistics for admin dashboard
  Future<Map<String, dynamic>> getEventStatistics() async {
    try {
      final eventsSnapshot = await _firestore.collection('events').get();
      final events = eventsSnapshot.docs
          .map((doc) => EventModel.fromMap(doc.data()))
          .toList();

      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);

      final totalEvents = events.length;
      final upcomingEvents = events
          .where(
            (e) =>
                e.date.isAfter(startOfToday) ||
                (e.date.year == startOfToday.year &&
                    e.date.month == startOfToday.month &&
                    e.date.day == startOfToday.day),
          )
          .length;
      final totalAttendees = events.fold(
        0,
        (sum, event) => sum + event.attendees.length,
      );
      final avgAttendance = totalEvents > 0
          ? (totalAttendees / totalEvents)
          : 0.0;

      // Top events by attendance
      final topEvents = events.where((e) => e.attendees.isNotEmpty).toList()
        ..sort((a, b) => b.attendees.length.compareTo(a.attendees.length));

      return {
        'totalEvents': totalEvents,
        'upcomingEvents': upcomingEvents,
        'totalAttendees': totalAttendees,
        'avgAttendance': avgAttendance.isFinite ? avgAttendance.round() : 0,
        'topEvents': topEvents.take(5).toList(),
      };
    } catch (e) {
      throw Exception('Error getting event statistics: $e');
    }
  }
}
