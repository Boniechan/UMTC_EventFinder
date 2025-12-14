import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();

  List<EventModel> _events = [];
  List<EventModel> _userEvents = [];
  String _selectedCollege = 'All Departments';
  String _selectedCategory = 'All Categories';
  bool _isLoading = false;

  List<EventModel> get events => _events;
  List<EventModel> get userEvents => _userEvents;
  String get selectedCollege => _selectedCollege;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  List<EventModel> get filteredEvents {
    return _events.where((event) {
      bool collegeMatch =
          _selectedCollege == 'All Departments' ||
          event.college == _selectedCollege;
      bool categoryMatch =
          _selectedCategory == 'All Categories' ||
          event.category == _selectedCategory;
      return collegeMatch && categoryMatch;
    }).toList();
  }

  void setCollegeFilter(String college) {
    _selectedCollege = college;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> createEvent(EventModel event) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _eventService.createEvent(event);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> rsvpToEvent(String eventId) async {
    try {
      await _eventService.rsvpToEvent(eventId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelRSVP(String eventId) async {
    try {
      await _eventService.cancelRSVP(eventId);
    } catch (e) {
      rethrow;
    }
  }

  bool hasUserRSVPd(EventModel event) {
    return _eventService.hasUserRSVPd(event);
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _eventService.deleteEvent(eventId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getEventStatistics() async {
    return await _eventService.getEventStatistics();
  }

  Stream<List<EventModel>> getEventsStream() {
    return _eventService.getEventsStream();
  }

  Stream<List<EventModel>> getUserRSVPEventsStream() {
    return _eventService.getUserRSVPEvents();
  }
}
