import '../models/event_model.dart';

class DemoDataService {
  static List<EventModel> getSampleEvents() {
    return [
      EventModel(
        id: '1',
        title: 'AI & Machine Learning Workshop',
        description:
            'Hands-on workshop covering the fundamentals of machine learning, neural networks, and practical applications in real-world projects.',
        date: DateTime.now().add(const Duration(days: 3)),
        startTime: '2:00 PM',
        endTime: '4:00 PM',
        location: 'Keller Hall, Room 3-180',
        college: 'College of Science & Engineering',
        category: 'Workshop',
        organizer: 'CS Student Association',
        capacity: 50,
        tags: ['AI', 'Machine Learning', 'Tech'],
        attendees: ['user1', 'user2', 'user3'], // Sample attendee IDs
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      EventModel(
        id: '2',
        title: 'Career Fair: Business & Finance',
        description:
            'Connect with top employers from Fortune 500 companies. Bring your resume and dress professionally for this networking opportunity.',
        date: DateTime.now().add(const Duration(days: 7)),
        startTime: '10:00 AM',
        endTime: '3:00 PM',
        location: 'Coffman Memorial Union, Great Hall',
        college: 'College of Business',
        category: 'Career',
        organizer: 'Career Services',
        capacity: 200,
        tags: ['Career', 'Networking', 'Business'],
        attendees: List.generate(
          150,
          (index) => 'user${index + 10}',
        ), // 150 attendees
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      EventModel(
        id: '3',
        title: 'Sustainability in Architecture',
        description:
            'Explore sustainable design principles and green building technologies in modern architecture.',
        date: DateTime.now().add(const Duration(days: 14)),
        startTime: '1:00 PM',
        endTime: '3:00 PM',
        location: 'Rapson Hall, Room 45',
        college: 'College of Arts & Letters',
        category: 'Seminar',
        organizer: 'Architecture Department',
        capacity: 80,
        tags: ['Architecture', 'Sustainability', 'Design'],
        attendees: List.generate(
          56,
          (index) => 'user${index + 200}',
        ), // 56 attendees (70% full)
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
      EventModel(
        id: '4',
        title: 'Python Programming Bootcamp',
        description:
            'Intensive 3-day bootcamp covering Python fundamentals, web development, and data analysis.',
        date: DateTime.now().add(const Duration(days: 21)),
        startTime: '9:00 AM',
        endTime: '5:00 PM',
        location: 'Computer Science Building, Lab 101',
        college: 'College of Science & Engineering',
        category: 'Workshop',
        organizer: 'CS Student Association',
        capacity: 30,
        tags: ['Python', 'Programming', 'Web Development'],
        attendees: List.generate(
          25,
          (index) => 'user${index + 300}',
        ), // Nearly full
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      EventModel(
        id: '5',
        title: 'Cultural Night: Diversity Celebration',
        description:
            'Celebrate the diverse cultures on our campus with food, music, and traditional performances.',
        date: DateTime.now().add(const Duration(days: 28)),
        startTime: '6:00 PM',
        endTime: '10:00 PM',
        location: 'Student Union Ballroom',
        college: 'All Colleges',
        category: 'Social',
        organizer: 'Multicultural Student Services',
        capacity: 300,
        tags: ['Culture', 'Diversity', 'Entertainment'],
        attendees: List.generate(
          245,
          (index) => 'user${index + 400}',
        ), // Popular event
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }

  static EventModel createSampleEvent() {
    return EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Sample Event',
      description: 'This is a sample event for testing purposes.',
      date: DateTime.now().add(const Duration(days: 1)),
      startTime: '2:00 PM',
      endTime: '4:00 PM',
      location: 'Sample Location',
      college: 'College of Science & Engineering',
      category: 'Workshop',
      organizer: 'Sample Organizer',
      capacity: 50,
      createdAt: DateTime.now(),
    );
  }
}
