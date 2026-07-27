enum PostType { artwork, question, achievement, critiqueRequest, tip }
enum ReactionType { like, love, inspire, helpful }

class CommunityPost {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String? schoolName;
  final PostType type;
  final String title;
  final String content;
  final List<String> imageUrls;
  final List<String> tags;
  final DateTime createdAt;
  final int likes;
  final int commentsCount;
  final Map<ReactionType, int> reactions;
  final bool isFeatured;
  final bool isForCritique;

  CommunityPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    this.schoolName,
    required this.type,
    required this.title,
    required this.content,
    this.imageUrls = const [],
    this.tags = const [],
    required this.createdAt,
    this.likes = 0,
    this.commentsCount = 0,
    this.reactions = const {},
    this.isFeatured = false,
    this.isForCritique = false,
  });

  factory CommunityPost.mock(String id) {
    final types = PostType.values;
    return CommunityPost(
      id: id,
      authorId: 'user${id.hashCode % 10}',
      authorName: ['Amara Okafor', 'Tunde Adebayo', 'Chioma Nwosu', 'David Lee'][id.hashCode % 4],
      schoolName: ['Donlee Main', 'Greensprings', 'Abuja Hub'][id.hashCode % 3],
      type: types[id.hashCode % types.length],
      title: ['My Loomis heads - need critique on jaw angle', 'Just won 1st in National Championship! 🎉', 'Value scale exercise - 9 steps finally!', 'Question: How to draw hands expressive?'][id.hashCode % 4],
      content: 'Sharing my progress from Elements of Art module. Used camera capture for verification. AI feedback said jaw 10% long - fixed it. Teacher-approved. What do you think?',
      imageUrls: ['https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800'],
      tags: ['Loomis', 'Feedback', 'Portrait'],
      createdAt: DateTime.now().subtract(Duration(hours: id.hashCode % 48)),
      likes: 12 + id.hashCode % 50,
      commentsCount: 3 + id.hashCode % 10,
      reactions: {ReactionType.like: 10, ReactionType.inspire: 5, ReactionType.helpful: 3},
      isFeatured: id.hashCode % 5 == 0,
      isForCritique: id.hashCode % 3 == 0,
    );
  }
}

class ForumTopic {
  final String id;
  final String title;
  final String description;
  final String category;
  final int postCount;
  final int memberCount;
  final String? lastActivityBy;
  final DateTime lastActivityAt;

  ForumTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.postCount,
    required this.memberCount,
    this.lastActivityBy,
    required this.lastActivityAt,
  });

  static List<ForumTopic> mockTopics() {
    return [
      ForumTopic(id: 'f1', title: 'Loomis Method Help & Critique', description: 'Share heads, get teacher + peer feedback on proportion', category: 'Facial Drawing', postCount: 234, memberCount: 567, lastActivityBy: 'Amara', lastActivityAt: DateTime.now().subtract(const Duration(hours: 2))),
      ForumTopic(id: 'f2', title: 'National Competition 2025 Prep', description: 'Theme Unity in Diversity - brainstorm, reference sharing', category: 'Competition', postCount: 189, memberCount: 342, lastActivityBy: 'Tunde', lastActivityAt: DateTime.now().subtract(const Duration(hours: 5))),
      ForumTopic(id: 'f3', title: 'Offline Learning Tips - Low-Bandwidth', description: 'How to maximize learning in limited internet areas', category: 'Offline', postCount: 87, memberCount: 234, lastActivityBy: 'Zainab', lastActivityAt: DateTime.now().subtract(const Duration(days: 1))),
      ForumTopic(id: 'f4', title: 'AI Art Feedback - Share Your AI Critiques', description: 'Post AI feedback screenshots, discuss improvements', category: 'AI Tools', postCount: 156, memberCount: 412, lastActivityBy: 'David', lastActivityAt: DateTime.now().subtract(const Duration(hours: 1))),
    ];
  }
}

class CommunityEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final bool isVirtual;
  final bool isNational;
  final int attendees;
  final String? imageUrl;

  CommunityEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.isVirtual = false,
    this.isNational = false,
    this.attendees = 0,
    this.imageUrl,
  });

  static List<CommunityEvent> mockEvents() {
    final now = DateTime.now();
    return [
      CommunityEvent(id: 'e1', title: 'Live Q&A: Portrait Tips with Ms. Amara', description: 'Eye drawing demo, voice learning support, low-bandwidth friendly', date: now.add(const Duration(days: 2)), location: 'Google Meet + Donlee App Live', isVirtual: true, isNational: true, attendees: 234, imageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800'),
      CommunityEvent(id: 'e2', title: 'National Exhibition Opening - Nike Art Gallery', description: 'Top 10 national competition artworks exhibited, scholarship awards', date: now.add(const Duration(days: 15)), location: 'Nike Art Gallery, Lagos', isVirtual: false, isNational: true, attendees: 500, imageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800'),
      CommunityEvent(id: 'e3', title: 'Parent-Teacher Conference - AI Progress Review', description: 'AI analytics insights, child progress, parental consent review', date: now.add(const Duration(days: 7)), location: 'Donlee Main - Lagos + Virtual', isVirtual: true, isNational: false, attendees: 89),
    ];
  }
}
