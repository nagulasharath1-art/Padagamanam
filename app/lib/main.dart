import 'package:flutter/material.dart';

void main() {
  runApp(const PadagamanamApp());
}

// ------------------------------------------------------------
// PADAGAMANAM
// Telugu Crossword - Base Version
// ------------------------------------------------------------

class PadagamanamApp extends StatelessWidget {
  const PadagamanamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'పద గమనం',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8FF),
      ),
      home: const CrosswordPage(),
    );
  }
}

// ------------------------------------------------------------
// CROSSWORD ENTRY
// ------------------------------------------------------------

class CrosswordEntry {
  final String id;
  final bool across;
  final int row;
  final int col;
  final List<String> letters;
  final String clue;

  CrosswordEntry({
    required this.id,
    required this.across,
    required this.row,
    required this.col,
    required this.letters,
    required this.clue,
  });

  int get length => letters.length;

  List<Point> get cells {
    return List.generate(
      letters.length,
      (index) => Point(
        row + (across ? 0 : index),
        col + (across ? index : 0),
      ),
    );
  }
}

// ------------------------------------------------------------
// SIMPLE POINT
// ------------------------------------------------------------

class Point {
  final int row;
  final int col;

  const Point(this.row, this.col);

  @override
  bool operator ==(Object other) {
    return other is Point &&
        other.row == row &&
        other.col == col;
  }

  @override
  int get hashCode => Object.hash(row, col);
}

// ------------------------------------------------------------
// CELL
// ------------------------------------------------------------

class CrosswordCell {
  String answer = '';
  String typed = '';

  bool get isCorrect =>
      typed.isNotEmpty && typed == answer;
}

// ------------------------------------------------------------
// CROSSWORD PAGE
// ------------------------------------------------------------

class CrosswordPage extends StatefulWidget {
  const CrosswordPage({super.key});

  @override
  State<CrosswordPage> createState() => _CrosswordPageState();
}

class _CrosswordPageState extends State<CrosswordPage> {
  static const int gridSize = 11;

  late List<CrosswordEntry> entries;
  late Map<Point, CrosswordCell> cells;
  late Map<Point, int> numbers;
  late Map<String, int> entryNumbers;

  String? selectedEntryId;

  final Map<Point, TextEditingController> controllers = {};
  final Map<Point, FocusNode> focusNodes = {};

  int score = 0;

  @override
  void initState() {
    super.initState();

    entries = _createEntries();

    cells = {};
    numbers = {};
    entryNumbers = {};

    _buildGrid();
    _createNumbering();
  }

  // ----------------------------------------------------------
  // CROSSWORD DATA
  // ----------------------------------------------------------

  List<CrosswordEntry> _createEntries() {
    return [

      // ------------------------------------------------------
      // అడ్డం 1
      // సంస్కృతం = సం | స్కృ | తం
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'A1',
        across: true,
        row: 0,
        col: 0,
        letters: const [
          'సం',
          'స్కృ',
          'తం',
        ],
        clue: 'మంత్రాలన్నీ ఉండే భాషలోనే',
      ),

      // ------------------------------------------------------
      // నిలువు
      // తం | డ్రి = తండ్రి
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'D1',
        across: false,
        row: 0,
        col: 2,
        letters: const [
          'తం',
          'డ్రి',
        ],
        clue: 'ఇంటి పెద్ద',
      ),

      // ------------------------------------------------------
      // అడ్డం 2
      // రాజమండ్రి
      // రా | జ | మం | డ్రి
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'A2',
        across: true,
        row: 2,
        col: 0,
        letters: const [
          'రా',
          'జ',
          'మం',
          'డ్రి',
        ],
        clue: 'గోదావరి తీరంలోని ప్రసిద్ధ నగరం',
      ),

      // ------------------------------------------------------
      // నిలువు
      // రా | మ | డు
      // రాముడు
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'D2',
        across: false,
        row: 2,
        col: 0,
        letters: const [
          'రా',
          'మ',
          'డు',
        ],
        clue: 'అయోధ్యకు చెందిన యువరాజు',
      ),

      // ------------------------------------------------------
      // నిలువు
      // జ | లం
      // జలం
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'D3',
        across: false,
        row: 2,
        col: 1,
        letters: const [
          'జ',
          'లం',
        ],
        clue: 'నీటికి మరో పేరు',
      ),

      // ------------------------------------------------------
      // నిలువు
      // మం | చు
      // మంచు
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'D4',
        across: false,
        row: 2,
        col: 2,
        letters: const [
          'మం',
          'చు',
        ],
        clue: 'చలికాలంలో తెల్లగా కురిసేది',
      ),

      // ------------------------------------------------------
      // నిలువు
      // డ్రి | ల్
      // డ్రిల్
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'D5',
        across: false,
        row: 2,
        col: 3,
        letters: const [
          'డ్రి',
          'ల్',
        ],
        clue: 'రంధ్రం చేయడానికి ఉపయోగించే పరికరం',
      ),

      // ------------------------------------------------------
      // అడ్డం 3
      // మనసు
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'A3',
        across: true,
        row: 5,
        col: 0,
        letters: const [
          'మ',
          'న',
          'సు',
        ],
        clue: 'ఆలోచనలూ భావాలూ నిలిచే అంతరంగం',
      ),

      // ------------------------------------------------------
      // నిలువు
      // న | ది
      // నది
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'D6',
        across: false,
        row: 5,
        col: 1,
        letters: const [
          'న',
          'ది',
        ],
        clue: 'ప్రవహించే జలధార',
      ),

      // ------------------------------------------------------
      // నిలువు
      // సు | ఖం
      // సుఖం
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'D7',
        across: false,
        row: 5,
        col: 2,
        letters: const [
          'సు',
          'ఖం',
        ],
        clue: 'ఆనంద భావం',
      ),

      // ------------------------------------------------------
      // అడ్డం 4
      // నీరు
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'A4',
        across: true,
        row: 7,
        col: 0,
        letters: const [
          'నీ',
          'రు',
        ],
        clue: 'జీవానికి అత్యవసరమైన ద్రవం',
      ),

      // ------------------------------------------------------
      // నిలువు
      // రు | చి
      // రుచి
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'D8',
        across: false,
        row: 7,
        col: 1,
        letters: const [
          'రు',
          'చి',
        ],
        clue: 'ఆహారాన్ని ఆస్వాదించేటప్పుడు తెలిసేది',
      ),

      // ------------------------------------------------------
      // నిలువు
      // నీ | టి
      // నీటి
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'D9',
        across: false,
        row: 7,
        col: 0,
        letters: const [
          'నీ',
          'టి',
        ],
        clue: 'జలానికి సంబంధించినది',
      ),

      // ------------------------------------------------------
      // అడ్డం 5
      // కల
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'A5',
        across: true,
        row: 9,
        col: 0,
        letters: const [
          'క',
          'ల',
        ],
        clue: 'సృజనాత్మక వ్యక్తీకరణ',
      ),

      // ------------------------------------------------------
      // నిలువు
      // ల | త
      // లత
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'D10',
        across: false,
        row: 9,
        col: 1,
        letters: const [
          'ల',
          'త',
        ],
        clue: 'చెట్టు ఎక్కే సన్నని మొక్క',
      ),
    ];
  }

  // ----------------------------------------------------------
  // BUILD GRID FROM WORDS
  // ----------------------------------------------------------

  void _buildGrid() {
    for (final entry in entries) {
      for (int i = 0; i < entry.letters.length; i++) {
        final point = Point(
          entry.row + (entry.across ? 0 : i),
          entry.col + (entry.across ? i : 0),
        );

        final answer = entry.letters[i];

        if (!cells.containsKey(point)) {
          final cell = CrosswordCell();
          cell.answer = answer;
          cells[point] = cell;

          controllers[point] =
              TextEditingController();

          focusNodes[point] = FocusNode();
        } else {
          // Crossing letter must match.
          if (cells[point]!.answer != answer) {
            debugPrint(
              'CROSSWORD ERROR at ${point.row},${point.col}',
            );
          }
        }
      }
    }
  }

  // ----------------------------------------------------------
  // AUTOMATIC NUMBERING
  // ----------------------------------------------------------

  void _createNumbering() {
    final starts = <Point>{};

    for (final entry in entries) {
      starts.add(
        Point(entry.row, entry.col),
      );
    }

    final sortedStarts = starts.toList()
      ..sort((a, b) {
        if (a.row != b.row) {
          return a.row.compareTo(b.row);
        }

        return a.col.compareTo(b.col);
      });

    int number = 1;

    for (final point in sortedStarts) {
      numbers[point] = number;

      for (final entry in entries) {
        if (entry.row == point.row &&
            entry.col == point.col) {
          entryNumbers[entry.id] = number;
        }
      }

      number++;
    }
  }

  // ----------------------------------------------------------
  // SELECT ENTRY
  // ----------------------------------------------------------

  void _selectEntry(CrosswordEntry entry) {
    setState(() {
      selectedEntryId = entry.id;
    });

    final firstPoint = Point(
      entry.row,
      entry.col,
    );

    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (mounted) {
          focusNodes[firstPoint]?.requestFocus();
        }
      },
    );
  }

  // ----------------------------------------------------------
  // CELL INPUT
  // ----------------------------------------------------------

  void _onLetterChanged(
    Point point,
    String value,
  ) {
    if (!cells.containsKey(point)) {
      return;
    }

    setState(() {
      cells[point]!.typed = value;

      _calculateScore();
    });

    // IMPORTANT:
    // We deliberately DO NOT move to the next cell.
    // The typed Telugu letter stays fixed inside the cell.
  }

  // ----------------------------------------------------------
  // SCORE
  // ----------------------------------------------------------

  void _calculateScore() {
    int correct = 0;

    for (final cell in cells.values) {
      if (cell.isCorrect) {
        correct++;
      }
    }

    score = correct;
  }

  // ----------------------------------------------------------
  // IS CELL SELECTED?
  // ----------------------------------------------------------

  bool _isSelected(Point point) {
    if (selectedEntryId == null) {
      return false;
    }

    final entry = entries.firstWhere(
      (e) => e.id == selectedEntryId,
    );

    return entry.cells.contains(point);
  }

  // ----------------------------------------------------------
  // CELL COLOR
  // ----------------------------------------------------------

  Color _cellColor(Point point) {
    final cell = cells[point]!;

    if (cell.isCorrect) {
      return const Color(0xFFB8E6C1);
    }

    if (_isSelected(point)) {
      return const Color(0xFFE2D2FF);
    }

    return Colors.white;
  }

  // ----------------------------------------------------------
  // BUILD CELL
  // ----------------------------------------------------------

  Widget _buildCell(Point point) {
    final cell = cells[point]!;

    final number = numbers[point];

    return GestureDetector(
      onTap: () {
        CrosswordEntry? entry;

        // If this cell belongs to selected word,
        // keep selected word.
        if (selectedEntryId != null) {
          final selected = entries.firstWhere(
            (e) => e.id == selectedEntryId,
          );

          if (selected.cells.contains(point)) {
            entry = selected;
          }
        }

        // Otherwise choose an entry containing this cell.
        entry ??= entries.firstWhere(
          (e) => e.cells.contains(point),
        );

        _selectEntry(entry!);
      },
      child: Container(
        decoration: BoxDecoration(
          color: _cellColor(point),
          border: Border.all(
            color: _isSelected(point)
                ? const Color(0xFF6A3FB5)
                : Colors.black,
            width: _isSelected(point) ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [

            // ----------------------------------------------
            // NUMBER
            // ----------------------------------------------

            if (number != null)
              Positioned(
                left: 3,
                top: 2,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),

            // ----------------------------------------------
            // LETTER
            // ----------------------------------------------

            Center(
              child: TextField(
                controller: controllers[point],
                focusNode: focusNodes[point],
                maxLength: 1,
                showCursor: false,
                textAlign: TextAlign.center,
                textAlignVertical:
                    TextAlignVertical.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onTap: () {
                  final possibleEntries =
                      entries.where(
                    (entry) =>
                        entry.cells.contains(point),
                  );

                  if (possibleEntries.isNotEmpty) {
                    _selectEntry(
                      possibleEntries.first,
                    );
                  }
                },
                onChanged: (value) {
                  _onLetterChanged(
                    point,
                    value,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // GRID
  // ----------------------------------------------------------

  Widget _buildGrid() {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics:
            const NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
        ),
        itemCount: gridSize * gridSize,
        itemBuilder: (context, index) {
          final row = index ~/ gridSize;
          final col = index % gridSize;

          final point = Point(row, col);

          // ----------------------------------------------
          // BLACK BLOCK
          // ----------------------------------------------

          if (!cells.containsKey(point)) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.white,
                  width: 0.5,
                ),
              ),
            );
          }

          return _buildCell(point);
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // CLUE ITEM
  // ----------------------------------------------------------

  Widget _buildClue(
    CrosswordEntry entry,
  ) {
    final number =
        entryNumbers[entry.id] ?? 0;

    final selected =
        selectedEntryId == entry.id;

    final direction =
        entry.across ? 'అడ్డం' : 'నిలువు';

    return InkWell(
      onTap: () {
        _selectEntry(entry);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          bottom: 8,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
