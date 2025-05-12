import 'dart:math';

class BookSubjectPicker {
  final List<String> subjects = [
    'Arts',
    'Biographies & Memoirs',
    'Business & Economics',
    'Children\'s Books',
    'Comics & Graphic Novels',
    'Computers & Technology',
    'Cookbooks',
    'Education',
    'Health & Fitness',
    'History',
    'Literature & Fiction',
    'Medical',
    'Mystery & Thrillers',
    'Nonfiction',
    'Philosophy',
    'Poetry',
    'Politics & Social Sciences',
    'Religion & Spirituality',
    'Science',
    'Self-Help',
    'Sports & Outdoors',
    'Teen & Young Adult',
    'Travel',
    'Hobbies & Home',
    'Science Fiction & Fantasy',
    'Law',
    'Graphic Novels & Manga',
    'Music',
    'Social Media',
    'Parenting & Relationships'
  ];

  List<String> pickRandomSubjects({int count = 5}) {
    count = count > subjects.length ? subjects.length : count;

    final random = Random();
    List<String> selectedSubjects = [];

    for (int i = 0; i < count; i++) {
      String randomSubject;
      do {
        randomSubject = subjects[random.nextInt(subjects.length)];
      } while (selectedSubjects.contains(randomSubject));

      selectedSubjects.add(randomSubject);
    }

    return selectedSubjects;
  }
}