enum CreativeDomain { visualArt, music, dance, drama, creativeWriting, photography, film, architecture }

class CreativeSubject {
  final String id;
  final CreativeDomain domain;
  final String name;
  final String description;
  final String icon;
  final bool isEnabled;
  final bool isComingSoon;
  final int moduleCount;
  final String? thumbnailUrl;

  CreativeSubject({
    required this.id,
    required this.domain,
    required this.name,
    required this.description,
    required this.icon,
    this.isEnabled = false,
    this.isComingSoon = true,
    this.moduleCount = 0,
    this.thumbnailUrl,
  });

  static List<CreativeSubject> allSubjects() {
    return [
      CreativeSubject(id: 'visual_art', domain: CreativeDomain.visualArt, name: 'Visual Art - Fine Art', description: 'Donlee foundation - 10 modules Intro to Color Theory, Loomis, Perspective, Competition, Offline, AI Tutor', icon: '🎨', isEnabled: true, isComingSoon: false, moduleCount: 10, thumbnailUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800'),
      CreativeSubject(id: 'music', domain: CreativeDomain.music, name: 'Music', description: 'Future: Afrobeat creation, traditional instruments, music theory, offline audio lessons, AI composition feedback', icon: '🎵', isEnabled: false, isComingSoon: true, moduleCount: 0),
      CreativeSubject(id: 'dance', domain: CreativeDomain.dance, name: 'Dance', description: 'Future: Nigerian traditional dance, contemporary, choreography, offline video low-BW', icon: '💃', isEnabled: false, isComingSoon: true, moduleCount: 0),
      CreativeSubject(id: 'drama', domain: CreativeDomain.drama, name: 'Drama & Theatre', description: 'Future: Acting, scriptwriting, stage design, offline scripts, AI dialogue feedback', icon: '🎭', isEnabled: false, isComingSoon: true, moduleCount: 0),
      CreativeSubject(id: 'creative_writing', domain: CreativeDomain.creativeWriting, name: 'Creative Writing', description: 'Future: Poetry, short stories, storytelling for art statements, AI writing assistant', icon: '✍️', isEnabled: false, isComingSoon: true, moduleCount: 0),
      CreativeSubject(id: 'photography', domain: CreativeDomain.photography, name: 'Photography', description: 'Future: Camera basics, composition rule thirds, lighting, editing, offline reference packs', icon: '📸', isEnabled: false, isComingSoon: true, moduleCount: 0),
      CreativeSubject(id: 'film', domain: CreativeDomain.film, name: 'Film & Animation', description: 'Future: Storyboarding, 2D animation gesture drawing, perspective for animation', icon: '🎬', isEnabled: false, isComingSoon: true, moduleCount: 0),
    ];
  }
}
