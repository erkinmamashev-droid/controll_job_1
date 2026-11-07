import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/character.dart';
import '../models/house.dart';
import '../models/spell.dart';
import '../services/character_api.dart';
import '../theme/hogwarts_colors.dart';
import '../widgets/books_section.dart';
import '../widgets/character_card.dart';
import '../widgets/houses_section.dart';
import '../widgets/magic_effects.dart';
import '../widgets/spells_section.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({
    super.key,
    this.characterLoader = CharacterApi.fetchCharacters,
    this.houseLoader = CharacterApi.fetchHouses,
    this.bookLoader = CharacterApi.fetchBooks,
    this.spellLoader = CharacterApi.fetchSpells,
    this.isDark = false,
    this.onThemeToggle,
  });

  final Future<List<Character>> Function() characterLoader;
  final Future<List<House>> Function() houseLoader;
  final Future<List<Book>> Function() bookLoader;
  final Future<List<Spell>> Function() spellLoader;
  final bool isDark;
  final VoidCallback? onThemeToggle;

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  late Future<List<Character>> _characters;
  late Future<List<House>> _houses;
  late Future<List<Book>> _books;
  late Future<List<Spell>> _spells;
  final Set<Character> _disintegratedCharacters = {};
  String _searchQuery = '';
  String _selectedHouse = 'Все';
  int _selectedSection = 0;

  @override
  void initState() {
    super.initState();
    _characters = widget.characterLoader();
    _houses = widget.houseLoader();
    _books = widget.bookLoader();
    _spells = widget.spellLoader();
  }

  void _reload() {
    setState(() {
      switch (_selectedSection) {
        case 0:
          _disintegratedCharacters.clear();
          _searchQuery = '';
          _selectedHouse = 'Все';
          _characters = widget.characterLoader();
        case 1:
          _houses = widget.houseLoader();
        case 2:
          _books = widget.bookLoader();
        case 3:
          _spells = widget.spellLoader();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF17382D),
        foregroundColor: const Color(0xFFFFF8E9),
        titleSpacing: 20,
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Color(0xFFE7C77A), size: 21),
            SizedBox(width: 9),
            Text(
              'HOGWARTS ARCHIVE',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: widget.onThemeToggle,
            tooltip: widget.isDark
                ? 'Включить светлую тему'
                : 'Включить тёмную тему',
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
          IconButton(
            onPressed: _reload,
            tooltip: 'Обновить раздел',
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: switch (_selectedSection) {
              0 => _buildCharactersSection(),
              1 => _buildHousesSection(),
              2 => _buildBooksSection(),
              _ => _buildSpellsSection(),
            },
          ),
          const Positioned.fill(
            child: IgnorePointer(child: RepaintBoundary(child: MagicEffects())),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedSection,
        onDestinationSelected: (index) {
          setState(() {
            _selectedSection = index;
            _searchQuery = '';
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Персонажи',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'Факультеты',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Книги',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Заклинания',
          ),
        ],
      ),
    );
  }

  Widget _buildCharactersSection() {
    return FutureBuilder<List<Character>>(
      future: _characters,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SectionLoading();
        }
        if (snapshot.hasError) {
          return _LoadError(error: snapshot.error, onRetry: _reload);
        }
        final characters = snapshot.data ?? const <Character>[];
        if (characters.isEmpty) {
          return const Center(child: Text('Персонажи не найдены'));
        }
        return _buildArchive(characters);
      },
    );
  }

  Widget _buildHousesSection() {
    return FutureBuilder<List<House>>(
      future: _houses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SectionLoading();
        }
        if (snapshot.hasError) {
          return _LoadError(error: snapshot.error, onRetry: _reload);
        }
        return HousesSection(houses: snapshot.data ?? const []);
      },
    );
  }

  Widget _buildBooksSection() {
    return FutureBuilder<List<Book>>(
      future: _books,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SectionLoading();
        }
        if (snapshot.hasError) {
          return _LoadError(error: snapshot.error, onRetry: _reload);
        }
        return BooksSection(books: snapshot.data ?? const []);
      },
    );
  }

  Widget _buildSpellsSection() {
    return FutureBuilder<List<Spell>>(
      future: _spells,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SectionLoading();
        }
        if (snapshot.hasError) {
          return _LoadError(error: snapshot.error, onRetry: _reload);
        }
        return SpellsSection(
          spells: snapshot.data ?? const [],
          query: _searchQuery,
          onQueryChanged: (value) => setState(() => _searchQuery = value),
        );
      },
    );
  }

  Widget _buildArchive(List<Character> allCharacters) {
    final visibleCharacters = allCharacters
        .where((character) => !_disintegratedCharacters.contains(character))
        .toList();
    final houses = [
      'Все',
      ...{
        for (final character in visibleCharacters)
          if (character.house.isNotEmpty) character.house,
      },
    ];
    if (!houses.contains(_selectedHouse)) _selectedHouse = 'Все';

    final filteredCharacters = visibleCharacters.where((character) {
      final matchesHouse =
          _selectedHouse == 'Все' || character.house == _selectedHouse;
      final query = _searchQuery.trim().toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          character.fullName.toLowerCase().contains(query) ||
          character.nickname.toLowerCase().contains(query) ||
          character.house.toLowerCase().contains(query);
      return matchesHouse && matchesQuery;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 36),
      children: [
        _ArchiveHeader(characterCount: allCharacters.length),
        const SizedBox(height: 22),
        TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Имя, прозвище или факультет',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: HogwartsColors.inputFor(context),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: HogwartsColors.borderFor(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: HogwartsColors.borderFor(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: houses.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final house = houses[index];
              return ChoiceChip(
                label: Text(house),
                selected: house == _selectedHouse,
                showCheckmark: false,
                selectedColor: Theme.of(context).colorScheme.primary,
                backgroundColor: HogwartsColors.inputFor(context),
                labelStyle: TextStyle(
                  color: house == _selectedHouse
                      ? Theme.of(context).colorScheme.onPrimary
                      : HogwartsColors.secondaryTextFor(context),
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(
                  color: house == _selectedHouse
                      ? Theme.of(context).colorScheme.primary
                      : HogwartsColors.borderFor(context),
                ),
                onSelected: (_) => setState(() => _selectedHouse = house),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 19,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _disintegratedCharacters.isEmpty
                    ? 'Герои волшебного мира'
                    : 'Остались в архиве',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: HogwartsColors.textFor(context),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '${filteredCharacters.length} / ${visibleCharacters.length}',
              style: const TextStyle(
                color: Color(0xFF7E806B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (filteredCharacters.isEmpty)
          _EmptyArchive(
            hasCharacters: visibleCharacters.isNotEmpty,
            onReset: () => setState(() {
              _searchQuery = '';
              _selectedHouse = 'Все';
            }),
          )
        else
          for (final character in filteredCharacters)
            CharacterCard(
              key: ValueKey(character.fullName),
              character: character,
              onDisintegrated: () {
                setState(() {
                  _disintegratedCharacters.add(character);
                });
              },
            ),
      ],
    );
  }
}

class _ArchiveHeader extends StatelessWidget {
  const _ArchiveHeader({required this.characterCount});

  final int characterCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF17382D), Color(0xFF315847), Color(0xFF42674D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26315447),
            blurRadius: 20,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -2,
            top: -4,
            child: Icon(Icons.auto_awesome, size: 86, color: Color(0x22F4D990)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0x24F4D990),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0x55F4D990)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  child: Text(
                    '✦  МИР МАГИИ',
                    style: TextStyle(
                      color: Color(0xFFF4D990),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Архив\nХогвартса',
                style: TextStyle(
                  color: Color(0xFFFFF8E9),
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                  letterSpacing: -0.5,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Знакомьтесь с ведьмами и волшебниками\nиз мира Гарри Поттера',
                style: TextStyle(
                  color: Color(0xFFD8E1D6),
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(
                    Icons.auto_stories_outlined,
                    color: Color(0xFFF4D990),
                    size: 17,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '$characterCount персонажей в коллекции',
                    style: const TextStyle(
                      color: Color(0xFFFFF8E9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyArchive extends StatelessWidget {
  const _EmptyArchive({required this.hasCharacters, required this.onReset});

  final bool hasCharacters;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final title = hasCharacters ? 'Никого не удалось найти' : 'Архив опустел';
    final subtitle = hasCharacters
        ? 'Попробуйте изменить поиск или факультет.'
        : 'Все персонажи рассыпались в волшебную пыль.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
      decoration: BoxDecoration(
        color: HogwartsColors.surfaceFor(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: HogwartsColors.borderFor(context)),
      ),
      child: Column(
        children: [
          Icon(
            hasCharacters ? Icons.search_off : Icons.auto_awesome,
            size: 40,
            color: HogwartsColors.mutedTextFor(context),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: HogwartsColors.textFor(context),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(subtitle, textAlign: TextAlign.center),
          if (!hasCharacters) ...[
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              label: const Text('Начать сначала'),
            ),
          ],
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 14),
            Text(
              'Не удалось открыть архив',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: HogwartsColors.textFor(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: TextStyle(color: HogwartsColors.secondaryTextFor(context)),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Попробовать снова'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLoading extends StatelessWidget {
  const _SectionLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFF315847)),
    );
  }
}
