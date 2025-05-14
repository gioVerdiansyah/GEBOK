import '../widgets/list/dropdown_expanded.dart';

class BookQuery {
  final String? generic; // include all like title, author, publisher, subject, etc
  final String? subject;
  final String? filterBy;
  final String? langRestrict;
  final String? orderBy;
  final int? maxResults;
  final int? startIndex;

  BookQuery({
    this.generic,
    this.subject,
    this.filterBy,
    this.langRestrict,
    this.orderBy,
    this.maxResults,
    this.startIndex,
  });

  Map<String, dynamic> toObject() {
    String q = '';

    if (generic != null) {
      q = generic!;
    } else {
      List<String> filters = [];

      if (subject != null) {
        filters.add('subject:${subject!}');
      }

      q = filters.join('+');
    }

    final map = {
      'q': q,
      'subject': subject,
      'filter': filterBy,
      'langRestrict': langRestrict,
      'order': orderBy,
      'maxResults': maxResults,
      'startIndex': startIndex,
    };

    map.removeWhere((key, value) => value == null);

    return map;
  }

  bool isApplyFilter() {
    return filterBy != null || langRestrict != null || orderBy != null;
  }

  List<DropdownItem> filterBook = [
    DropdownItem(id: 'all', name: 'Semuanya'),
    DropdownItem(id: 'free-ebooks', name: 'Gratis'),
    DropdownItem(id: 'paid-ebooks', name: 'Berbayar'),
  ];

  List<DropdownItem> orderBook = [
    DropdownItem(id: 'relevance', name: 'Relevan'),
    DropdownItem(id: 'newest', name: 'Terbaru'),
  ];

  List<DropdownItem> languages = [
    DropdownItem(id: 'all', name: 'Semua bahasa'),
    DropdownItem(id: 'en', name: 'English'),
    DropdownItem(id: 'id', name: 'Bahasa Indonesia'),
    DropdownItem(id: 'es', name: 'Español'),
    DropdownItem(id: 'cs', name: 'Čeština'),
    DropdownItem(id: 'da', name: 'Dansk'),
    DropdownItem(id: 'de', name: 'Deutsch'),
    DropdownItem(id: 'fr', name: 'Français'),
    DropdownItem(id: 'ja', name: '日本語'),
    DropdownItem(id: 'ko', name: '한국어'),
    DropdownItem(id: 'pt', name: 'Português'),
    DropdownItem(id: 'ru', name: 'Русский'),
    DropdownItem(id: 'th', name: 'ไทย'),
    DropdownItem(id: 'zh', name: '简体中文'),
    DropdownItem(id: 'zh-TW', name: '繁體中文'),
    DropdownItem(id: 'ar', name: 'العربية'),
  ];
}
