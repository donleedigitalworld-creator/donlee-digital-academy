enum ResourceType { video, article, ebook, referenceImage, template, assignmentBrief, tutorial, audio }
enum ResourceLevel { beginner, intermediate, advanced, all }
enum ResourceAccess { free, premium, schoolOnly }

class ResourceCategory {
  final String id;
  final String name;
  final String icon;
  final int resourceCount;

  ResourceCategory({required this.id, required this.name, required this.icon, required this.resourceCount});
}

class ResourceModel {
  final String id;
  final String title;
  final String description;
  final ResourceType type;
  final ResourceLevel level;
  final ResourceAccess access;
  final String? thumbnailUrl;
  final String? fileUrl;
  final String? content; // for articles
  final List<String> tags;
  final String author;
  final String? authorId;
  final int durationMinutes; // for video/audio
  final int downloadCount;
  final double rating;
  final bool isOfflineAvailable;
  final bool isDownloaded;
  final bool isFavorite;
  final DateTime createdAt;
  final List<String> relatedModuleIds;

  ResourceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.level,
    required this.access,
    this.thumbnailUrl,
    this.fileUrl,
    this.content,
    this.tags = const [],
    required this.author,
    this.authorId,
    this.durationMinutes = 0,
    this.downloadCount = 0,
    this.rating = 5.0,
    this.isOfflineAvailable = true,
    this.isDownloaded = false,
    this.isFavorite = false,
    required this.createdAt,
    this.relatedModuleIds = const [],
  });

  factory ResourceModel.mock(String id) {
    final types = ResourceType.values;
    final titles = [
      'Loomis Method Complete Guide - PDF',
      'Value Scale Exercise Sheet - Printable Template',
      'How to Draw Hands - Video Tutorial 15min',
      'Color Theory Wheel - Interactive Reference',
      'Lagos Market Photo Pack - 50 Reference Images',
      'Perspective 2-Point Grid Template',
      'Anatomy for Artists - Ebook Chapter 3',
      'Blind Contour Warm-up Audio Guide',
    ];
    final descs = [
      'Master Loomis head construction from sphere to final portrait - all angles with measurements',
      'Printable 9-step value scale + sphere shading worksheet for daily practice',
    ];
    return ResourceModel(
      id: id,
      title: titles[int.parse(id.substring(id.length - 1)) % titles.length],
      description: descs[id.hashCode % descs.length],
      type: types[id.hashCode % types.length],
      level: ResourceLevel.values[id.hashCode % 3],
      access: ResourceAccess.free,
      thumbnailUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800',
      author: 'Donlee Academy',
      downloadCount: 100 + id.hashCode % 500,
      rating: 4.5 + (id.hashCode % 5) / 10,
      isOfflineAvailable: true,
      isDownloaded: id.hashCode % 3 == 0,
      isFavorite: id.hashCode % 4 == 0,
      createdAt: DateTime.now().subtract(Duration(days: id.hashCode % 30)),
      relatedModuleIds: ['facial_drawing', 'elements_of_art'],
      durationMinutes: 5 + id.hashCode % 25,
      tags: ['Loomis', 'Portrait', 'Practice'],
    );
  }
}
