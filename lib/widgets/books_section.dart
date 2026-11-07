import 'package:flutter/material.dart';

import '../models/book.dart';
import '../theme/hogwarts_colors.dart';
import 'houses_section.dart';

class BooksSection extends StatelessWidget {
  const BooksSection({super.key, required this.books});

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const SectionBanner(
          eyebrow: 'ВОСЕМЬ ИСТОРИЙ · БЕСКОНЕЧНОЕ ВОЛШЕБСТВО',
          title: 'Книги',
          subtitle: 'Путешествие от первого письма до последней битвы.',
          icon: Icons.auto_stories_outlined,
        ),
        const SizedBox(height: 16),
        for (final book in books) _BookCard(book: book),
      ],
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      color: HogwartsColors.surfaceFor(context),
      elevation: 2,
      shadowColor: const Color(0x20301E13),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: HogwartsColors.borderFor(context)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 82,
                height: 122,
                child: book.cover.isEmpty
                    ? _coverPlaceholder(context)
                    : Image.network(
                        book.cover,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _coverPlaceholder(context),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'КНИГА ${book.number}',
                    style: const TextStyle(
                      color: Color(0xFF9A762B),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.3,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: HogwartsColors.textFor(context),
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  if (book.releaseDate.isNotEmpty || book.pages > 0) ...[
                    const SizedBox(height: 7),
                    Text(
                      [
                        if (book.releaseDate.isNotEmpty) book.releaseDate,
                        if (book.pages > 0) '${book.pages} стр.',
                      ].join('  ·  '),
                      style: TextStyle(
                        color: HogwartsColors.mutedTextFor(context),
                        fontSize: 11,
                      ),
                    ),
                  ],
                  if (book.description.isNotEmpty) ...[
                    const SizedBox(height: 9),
                    Text(
                      book.description,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: HogwartsColors.secondaryTextFor(context),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coverPlaceholder(BuildContext context) {
    return ColoredBox(
      color: HogwartsColors.iconBackgroundFor(context),
      child: Center(
        child: Icon(
          Icons.menu_book,
          size: 34,
          color: HogwartsColors.mutedTextFor(context),
        ),
      ),
    );
  }
}
