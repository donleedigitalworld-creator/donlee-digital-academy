import '../../../models/lesson_model.dart';
import '../../../models/quiz_model.dart';
import '../../../core/constants/app_constants.dart';

class LessonsData {
  static List<ModuleModel> get modules => [
    ModuleModel(
      id: 'intro_fine_art',
      title: 'Introduction to Fine Art',
      description: 'Discover what fine art is, its history and importance in human culture.',
      icon: '🎨',
      thumbnailUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800',
      lessonCount: 3,
      order: 1,
      learningOutcomes: ['Understand fine art history', 'Identify art movements', 'Appreciate artistic expression'],
    ),
    ModuleModel(
      id: 'elements_of_art',
      title: 'Elements of Art',
      description: 'Line, shape, form, color, value, texture, space - the building blocks.',
      icon: '◼️',
      thumbnailUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800',
      lessonCount: 4,
      order: 2,
      learningOutcomes: ['Master 7 elements of art', 'Apply in composition', 'Visual analysis'],
    ),
    ModuleModel(
      id: 'principles_design',
      title: 'Principles of Design',
      description: 'Balance, contrast, emphasis, movement, pattern, rhythm, unity.',
      icon: '⚖️',
      thumbnailUrl: 'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=800',
      lessonCount: 3,
      order: 3,
      learningOutcomes: ['Apply design principles', 'Create balanced compositions', 'Critical critique'],
    ),
    ModuleModel(
      id: 'human_anatomy',
      title: 'Human Anatomy for Artists',
      description: 'Learn skeletal & muscular structure to draw realistic figures.',
      icon: '🦴',
      thumbnailUrl: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=800',
      lessonCount: 5,
      order: 4,
      learningOutcomes: ['Skeletal proportions', 'Muscle groups', 'Dynamic poses'],
    ),
    ModuleModel(
      id: 'facial_drawing',
      title: 'Facial Drawing',
      description: 'Master proportions, features, expressions and likeness.',
      icon: '👤',
      thumbnailUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
      lessonCount: 4,
      order: 5,
      learningOutcomes: ['Loomis method', 'Eye nose mouth detail', 'Expression & emotion'],
    ),
    ModuleModel(
      id: 'hands_feet',
      title: 'Hands and Feet',
      description: 'Conquer the hardest parts - expressive hands and grounded feet.',
      icon: '🤲',
      thumbnailUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800',
      lessonCount: 3,
      order: 6,
      learningOutcomes: ['Hand anatomy', 'Gestures', 'Feet structure'],
    ),
    ModuleModel(
      id: 'perspective',
      title: 'Perspective Drawing',
      description: '1-point, 2-point, 3-point perspective for realistic space.',
      icon: '📐',
      thumbnailUrl: 'https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=800',
      lessonCount: 3,
      order: 7,
      learningOutcomes: ['Vanishing points', 'Depth illusion', 'Architectural drawing'],
    ),
    ModuleModel(
      id: 'still_life',
      title: 'Still Life',
      description: 'Compose and render everyday objects with light and shadow.',
      icon: '🍎',
      thumbnailUrl: 'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=800',
      lessonCount: 3,
      order: 8,
      learningOutcomes: ['Observation', 'Light & shadow', 'Composition'],
    ),
    ModuleModel(
      id: 'landscape',
      title: 'Landscape',
      description: 'Draw nature, skies, trees, mountains with atmosphere.',
      icon: '🏔️',
      thumbnailUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
      lessonCount: 3,
      order: 9,
      learningOutcomes: ['Atmospheric perspective', 'Natural textures', 'Sky & clouds'],
    ),
    ModuleModel(
      id: 'color_theory',
      title: 'Color Theory',
      description: 'Understanding color wheel, harmony, temperature and emotion.',
      icon: '🌈',
      thumbnailUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800',
      lessonCount: 4,
      order: 10,
      learningOutcomes: ['Color wheel mastery', 'Mixing', 'Mood & emotion'],
    ),
  ];

  static List<LessonModel> get allLessons {
    final List<LessonModel> lessons = [];
    for (var module in modules) {
      lessons.addAll(_getLessonsForModule(module));
    }
    return lessons;
  }

  static List<LessonModel> _getLessonsForModule(ModuleModel module) {
    switch (module.id) {
      case 'intro_fine_art':
        return [
          LessonModel(
            id: '${module.id}_1',
            moduleId: module.id,
            moduleTitle: module.title,
            title: 'What is Fine Art?',
            description: 'Definition and scope of fine art vs applied art.',
            longDescription: 'Fine art is created primarily for aesthetic and intellectual purposes. Unlike applied art which serves functional purposes, fine art exists to evoke emotion, provoke thought, and express the artists inner vision. From cave paintings to contemporary installations, fine art reflects humanity.',
            thumbnailUrl: module.thumbnailUrl,
            difficulty: 1,
            estimatedMinutes: 12,
            isFeatured: true,
            steps: [
              LessonStep(order: 1, title: 'Defining Fine Art', description: 'Fine art includes painting, sculpture, drawing, printmaking. It values beauty and meaning over function. Think Mona Lisa vs a coffee mug design - both art, but fine art prioritizes aesthetic contemplation.', tip: 'Visit a local museum this week and observe without your phone.'),
              LessonStep(order: 2, title: 'History Timeline', description: 'Prehistoric -> Ancient Egyptian & Greek -> Renaissance -> Baroque -> Modernism -> Contemporary. Each era added techniques and ideas. Renaissance introduced perspective; Impressionism broke rules of light.', tip: 'Pro Tip: Create a timeline sketchbook page.'),
              LessonStep(order: 3, title: 'Why It Matters Today', description: 'In digital age, fine art skills make you stand out. Understanding traditional drawing makes digital art stronger. Companies like Pixar hire fine artists.', tip: 'Fine art fundamentals are the superpower behind great digital work.'),
            ],
            quiz: [
              QuizQuestion(id: 'q1', question: 'Which is considered fine art?', options: ['Painting of a landscape', 'A logo design for a company', 'A chair design', 'All are same'], correctIndex: 0, explanation: 'Fine art is primarily aesthetic/intellectual, not functional.'),
              QuizQuestion(id: 'q2', question: 'Which period introduced linear perspective?', options: ['Baroque', 'Renaissance', 'Modernism', 'Prehistoric'], correctIndex: 1, explanation: 'Brunelleschi and Renaissance masters systematized perspective.'),
            ],
          ),
          LessonModel(
            id: '${module.id}_2',
            moduleId: module.id,
            moduleTitle: module.title,
            title: 'Art Movements Overview',
            description: 'Quick tour of major movements',
            longDescription: 'Understanding movements helps you find your style. We\'ll explore 8 key movements with visual characteristics.',
            thumbnailUrl: 'https://images.unsplash.com/photo-1578909196400-59f8f8156a05?w=800',
            difficulty: 1,
            estimatedMinutes: 18,
            steps: [
              LessonStep(order: 1, title: 'Impressionism (1870s)', description: 'Capture light and moment. Broken color, visible brushstrokes. Monet, Renoir. Paint outdoors (en plein air).', tip: 'Try squinting - impressionists prioritized feeling over detail.'),
              LessonStep(order: 2, title: 'Expressionism & Cubism', description: 'Expressionism distorts reality for emotion (Munch). Cubism shows multiple viewpoints at once (Picasso). Both free you from strict realism.', tip: 'Draw same object 3 ways: realistic, emotional, cubist.'),
            ],
            quiz: [
              QuizQuestion(id: 'q1', question: 'Impressionism focuses on?', options: ['Perfect detail', 'Light and momentary impression', 'Geometric shapes', 'Political message'], correctIndex: 1, explanation: 'Impressionism = impression of light at a moment.'),
            ],
          ),
          LessonModel(
            id: '${module.id}_3',
            moduleId: module.id,
            moduleTitle: module.title,
            title: 'Your Artist Toolkit',
            description: 'Essential materials for beginner',
            longDescription: 'You don\'t need expensive tools to start. Paper, pencil, eraser are enough. We cover traditional and digital starter kits.',
            thumbnailUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800',
            difficulty: 1,
            estimatedMinutes: 10,
            steps: [
              LessonStep(order: 1, title: 'Traditional Starter Kit', description: 'Sketchbook (A4, 100gsm), graphite pencils 2H to 6B, kneaded eraser, blending stump. Total under ₦5,000. Avoid early erasing - embrace lines.'),
              LessonStep(order: 2, title: 'Digital Starter', description: 'Phone/tablet + free apps: Ibis Paint, Autodesk Sketchbook. Later: tablet like XP-Pen. The best tool is the one you use daily.'),
            ],
            quiz: [
              QuizQuestion(id: 'q1', question: 'Best beginner investment?', options: ['Most expensive iPad', 'Daily practice with any pencil', 'Waiting for perfect tools', 'Only expensive paper'], correctIndex: 1, explanation: 'Consistency beats equipment.'),
            ],
          ),
        ];
      case 'elements_of_art':
        return [
          LessonModel(
            id: '${module.id}_1',
            moduleId: module.id,
            moduleTitle: module.title,
            title: 'Line & Shape - Foundation',
            description: 'Types of lines and how shapes create structure',
            longDescription: 'Line is the most basic element. It can be expressive, controlled, gestural. Shape is closed line - geometric vs organic.',
            thumbnailUrl: module.thumbnailUrl,
            difficulty: 1,
            estimatedMinutes: 20,
            isFeatured: true,
            steps: [
              LessonStep(order: 1, title: '7 Types of Lines', description: 'Horizontal (calm), Vertical (strength), Diagonal (movement), Curved (grace), Zigzag (energy), Contour (outline), Implied (suggested). Practice drawing each 20 times.', tip: 'Vary pressure: light lines for construction, dark for final.'),
              LessonStep(order: 2, title: 'Shape to Form', description: 'Geometric shapes: circle, square, triangle have math precision. Organic: leaf, puddle, human body - free. Every complex object starts as simple shape. Draw bottle as rectangle + ellipse.'),
              LessonStep(order: 3, title: 'Exercise: 100 Lines & Shapes', description: 'Fill one page with 50 different lines, second page 50 shapes overlapping. Goal: hand freedom, not perfection.', imageUrl: 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=800'),
            ],
            quiz: [
              QuizQuestion(id: 'q1', question: 'Which line suggests energy and anxiety?', options: ['Horizontal', 'Curved', 'Zigzag', 'Vertical'], correctIndex: 2, explanation: 'Zigzag creates tension and energy.'),
              QuizQuestion(id: 'q2', question: 'Sphere starts as?', options: ['Triangle', 'Circle', 'Square', 'Line'], correctIndex: 1, explanation: 'All forms start from basic 2D shapes.'),
            ],
          ),
          LessonModel(
            id: '${module.id}_2',
            moduleId: module.id,
            moduleTitle: module.title,
            title: 'Value & Texture',
            description: 'Light, shadow and surface quality',
            longDescription: 'Value is the lightness/darkness. Without value, drawings look flat. Texture is how surface feels or looks like it feels.',
            thumbnailUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
            difficulty: 2,
            estimatedMinutes: 25,
            steps: [
              LessonStep(order: 1, title: 'Value Scale 1-9', description: 'Create 9 boxes: 1=white paper, 9=blackest black, blend middle. This is your vocabulary. Most beginners only use 3 values (white, grey, black) - pros use all 9. Shading techniques: hatching, cross-hatching, stippling, blending.'),
              LessonStep(order: 2, title: '5 Elements of Light & Shadow', description: 'Highlight, Light, Core Shadow, Reflected Light, Cast Shadow. Observe egg under single lamp. Squint to see values simpler.'),
              LessonStep(order: 3, title: 'Texture Marks', description: 'Visual texture: draw wood grain with long lines, skin with dots, metal with sharp highlights. Create texture chart: wood, fabric, glass, skin.'),
            ],
            quiz: [
              QuizQuestion(id: 'q1', question: 'Core shadow is:', options: ['Brightest area', 'Darkest dark ON the object', 'Shadow on ground', 'Light bouncing'], correctIndex: 1, explanation: 'Core shadow is darkest on form, before reflected light.'),
            ],
          ),
        ];
      case 'facial_drawing':
        return [
          LessonModel(
            id: '${module.id}_1',
            moduleId: module.id,
            moduleTitle: module.title,
            title: 'Loomis Head Method',
            description: 'Construct head from sphere and planes',
            longDescription: 'Andrew Loomis method is industry standard for heads. Learn once, draw any angle.',
            thumbnailUrl: module.thumbnailUrl,
            difficulty: 2,
            estimatedMinutes: 30,
            isFeatured: true,
            steps: [
              LessonStep(order: 1, title: 'Sphere + Cross', description: '1) Draw sphere. 2) Cut off sides for skull plane. 3) Draw central cross: brow line at middle, center line for symmetry. This cross moves when head turns - it shows direction.', tip: 'Start light! Construction lines should be HB, barely visible.'),
              LessonStep(order: 2, title: 'Thirds & Fifths', description: 'Face in thirds: hairline to brow, brow to nose base, nose base to chin. Eyes: 5 eye-widths across head, one eye gap between eyes. Ears align with brow-nose. These are averages - real faces vary.'),
              LessonStep(order: 3, title: 'Jaw & Features Placement', description: 'From sphere bottom, extend lines for jaw. Chin is 1/3 below sphere in front view. Place eye sockets on brow line, nose at mid-lower third, mouth halfway nose-chin. Practice front, 3/4, side.'),
              LessonStep(order: 4, title: 'Practice Sheet', description: 'Draw 10 heads at different angles using Loomis lightly. Don\'t add details yet - focus on solid construction. Use reference photos from Pinterest: "Loomis heads"'),
            ],
            quiz: [
              QuizQuestion(id: 'q1', question: 'How many eye widths fit across head?', options: ['3', '5', '4', '6'], correctIndex: 1, explanation: 'Standard proportion is 5 eye widths.'),
              QuizQuestion(id: 'q2', question: 'Loomis method starts with?', options: ['Square', 'Sphere with cross', 'Triangle', 'Eye detail'], correctIndex: 1, explanation: 'Sphere establishes cranium.'),
            ],
          ),
        ];
      case 'color_theory':
        return [
          LessonModel(
            id: '${module.id}_1',
            moduleId: module.id,
            moduleTitle: module.title,
            title: 'The Color Wheel & Harmony',
            description: 'Primary, secondary, tertiary and how to pair them',
            longDescription: 'Color is emotion. Learn to control it and your art will speak before viewers analyze it.',
            thumbnailUrl: module.thumbnailUrl,
            difficulty: 2,
            estimatedMinutes: 22,
            isFeatured: true,
            steps: [
              LessonStep(order: 1, title: 'Wheel Basics', description: 'Primary: Red, Yellow, Blue (cannot be mixed). Secondary: Orange, Green, Purple (mix two primaries). Tertiary: Red-Orange etc. Paint/Digital: make your own wheel - mixing teaches faster than reading.'),
              LessonStep(order: 2, title: 'Harmony Rules', description: 'Complementary: opposite (Red-Green) = vibrant contrast. Analogous: neighbors (Blue, Blue-Green, Green) = harmony. Triadic: 3 equally spaced = balanced pop. Monochromatic: one hue + tints/shades = elegant.'),
              LessonStep(order: 3, title: 'Temperature & Emotion', description: 'Warm: red/orange/yellow -> energy, love, anger. Cool: blue/green/purple -> calm, sadness, distance. In portrait, add cool in shadows, warm in light for realism.'),
              LessonStep(order: 4, title: 'Exercise - Limited Palette', description: 'Paint same apple 3 times: 1) Complementary (red + green shadows), 2) Analogous (yellow, orange, red), 3) Monochromatic (blue only). Notice mood change.'),
            ],
            quiz: [
              QuizQuestion(id: 'q1', question: 'Complement of Blue is?', options: ['Red', 'Orange', 'Green', 'Yellow'], correctIndex: 1, explanation: 'On RYB wheel, blue opposite is orange.'),
              QuizQuestion(id: 'q2', question: 'Warm colors include?', options: ['Blue, Green', 'Red, Orange, Yellow', 'Purple only', 'Black & White'], correctIndex: 1, explanation: 'Warm = sun/fire hues.'),
            ],
          ),
        ];
      default:
        // Generic lessons for other modules
        return List.generate(3, (index) {
          final lessonNum = index + 1;
          return LessonModel(
            id: '${module.id}_$lessonNum',
            moduleId: module.id,
            moduleTitle: module.title,
            title: '${module.title} - Lesson $lessonNum',
            description: 'Deep dive into ${module.title} part $lessonNum',
            longDescription: 'This lesson covers core concepts of ${module.title}. You will learn through demonstration, practice exercises, and expert tips from Donlee Academy. Each step builds on previous. Remember: mastery comes from repetition, not just watching.',
            thumbnailUrl: module.thumbnailUrl,
            difficulty: lessonNum,
            estimatedMinutes: 15 + (lessonNum * 5),
            isFeatured: lessonNum == 1 && module.order % 2 == 0,
            steps: [
              LessonStep(order: 1, title: 'Concept Introduction', description: 'Understanding the foundation of ${module.title}. Why this matters: professional artists in Lagos and worldwide use this daily. Observe examples around you - sendan market patterns, danfo bus colors, your own hand. Drawing is seeing.', tip: '30-second tip: Sketch what you see right now, no erasing.'),
              LessonStep(order: 2, title: 'Step-by-Step Demo', description: 'Watch how instructor breaks complex subject into simple steps. 1) Block big shapes, 2) Refine proportions, 3) Add anatomy/details, 4) Light & shadow, 5) Final touches. Follow along pausing after each substep.'),
              LessonStep(order: 3, title: 'Guided Practice', description: 'Now your turn. Set timer 20 mins. Use reference. Focus on one improvement from last artwork. Common mistake: drawing what you THINK vs what you SEE. Squint, measure angles with pencil, compare negatives spaces. Upload to portfolio after.'),
            ],
            quiz: [
              QuizQuestion(id: 'q1', question: 'What is key to mastering ${module.title}?', options: ['Watching only', 'Daily deliberate practice', 'Expensive tools', 'Talent only'], correctIndex: 1, explanation: 'Deliberate practice with feedback beats talent.'),
              QuizQuestion(id: 'q2', question: 'Best way to start drawing?', options: ['Details first', 'Big simple shapes', 'Shading immediately', 'Random lines'], correctIndex: 1, explanation: 'Big shapes ensure correct proportions.'),
            ],
          );
        });
    }
  }

  static LessonModel? getFeaturedLesson() {
    return allLessons.firstWhere((l) => l.isFeatured, orElse: () => allLessons.first);
  }
}
