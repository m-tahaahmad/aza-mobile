/// Letter types that require document selection before preview/download (match manager flow).
const lettersDocumentsRequiredFiles = ['alert3', 'total-loss-docs', 'theft-docs'];

class LetterType {
  final String title;
  final String slug;

  const LetterType({required this.title, required this.slug});

  bool get requiresDocuments => lettersDocumentsRequiredFiles.contains(slug);
}

const List<LetterType> kLetterTypes = [
  LetterType(title: 'Alert 1', slug: 'alert1'),
  LetterType(title: 'Alert 2', slug: 'alert2'),
  LetterType(title: 'Alert 3', slug: 'alert3'),
  LetterType(title: 'Un-Repair', slug: 'unrepair'),
  LetterType(title: 'Total Loss', slug: 'total-loss'),
  LetterType(title: 'Total Loss Documents', slug: 'total-loss-docs'),
  LetterType(title: 'Theft/Snatching', slug: 'theft'),
  LetterType(title: 'Theft/Snatching Documents', slug: 'theft-docs'),
  LetterType(title: 'Lump Sump', slug: 'lumpsump'),
  LetterType(title: 'Indemnity Letter', slug: 'indemnity'),
  LetterType(title: 'Subrogation Letter', slug: 'subrogation'),
  LetterType(title: 'Excise', slug: 'excise'),
  LetterType(title: 'CIA', slug: 'cia'),
];

bool letterRequiresDocuments(String slug) => lettersDocumentsRequiredFiles.contains(slug);
