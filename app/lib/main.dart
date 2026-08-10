import 'package:flutter/material.dart';

void main() {
  runApp(const PadagamanamApp());
}

// ============================================================
// PADAGAMANAM
// Telugu Crossword
// ============================================================

class PadagamanamApp extends StatelessWidget {
  const PadagamanamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'పద గమనం',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF9FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF673AB7),
        ),
      ),
      home: const CrosswordPage(),
    );
  }
}

// ============================================================
// POINT
// ============================================================

class GridPoint {
  final int row;
  final int col;

  const GridPoint(this.row, this.col);

  @override
  bool operator ==(Object other) {
    return other is GridPoint &&
        other.row == row &&
        other.col == col;
  }

  @override
  int get hashCode => Object.hash(row, col);
}

// ============================================================
// CROSSWORD ENTRY
// ============================================================

class CrosswordEntry {
  final String id;
  final bool across;
  final int row;
  final int col;

  // Each item represents ONE crossword cell.
  final List<String> letters;

  final String clue;

  const CrosswordEntry({
    required this.id,
    required this.across,
    required this.row,
    required this.col,
    required this.letters,
    required this.clue,
  });

  int get length => letters.length;

  List<GridPoint> get cells {
    return List.generate(
      letters.length,
      (index) => GridPoint(
        row + (across ? 0 : index),
        col + (across ? index : 0),
      ),
    );
  }
}

// ============================================================
// CELL
// ============================================================

class CrosswordCell {
  String answer;
  String typed;

  CrosswordCell({
    this.answer = '',
    this.typed = '',
  });

  bool get isCorrect =>
      typed.trim().isNotEmpty &&
      typed.trim() == answer.trim();
}

// ============================================================
// CROSSWORD PAGE
// ============================================================

class CrosswordPage extends StatefulWidget {
  const CrosswordPage({super.key});

  @override
  State<CrosswordPage> createState() => _CrosswordPageState();
}

class _CrosswordPageState extends State<CrosswordPage> {
  static const int gridSize = 11;

  late final List<CrosswordEntry> entries;

  final Map<GridPoint, CrosswordCell> cells = {};
  final Map<GridPoint, int> numbers = {};
  final Map<String, int> entryNumbers = {};

  final Map<GridPoint, TextEditingController> controllers = {};
  final Map<GridPoint, FocusNode> focusNodes = {};

  String? selectedEntryId;

  int score = 0;

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    entries = _createEntries();

    _buildCrossword();
    _createNumbering();
  }

  // ==========================================================
  // CROSSWORD DATA
  //
  // IMPORTANT:
  // Every crossing cell contains exactly the same Telugu unit.
  // ==========================================================

  List<CrosswordEntry> _createEntries() {
    return const [

      // --------------------------------------------------------
      // 1. అడ్డం
      // భారతం
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'A1',
        across: true,
        row: 0,
        col: 1,
        letters: [
          'భా',
          'ర',
          'తం',
        ],
        clue: 'మన దేశానికి సాధారణంగా ఉపయోగించే పేరు',
      ),

      // --------------------------------------------------------
      // 2. నిలువు
      // తండ్రి
      // తం + డ్రి
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D1',
        across: false,
        row: 0,
        col: 3,
        letters: [
          'తం',
          'డ్రి',
        ],
        clue: 'ఇంటి పెద్దగా భావించే వ్యక్తి',
      ),

      // --------------------------------------------------------
      // 3. అడ్డం
      // రాజమండ్రి
      // రా + జ + మం + డ్రి
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'A2',
        across: true,
        row: 1,
        col: 0,
        letters: [
          'రా',
          'జ',
          'మం',
          'డ్రి',
        ],
        clue: 'గోదావరి తీరంలోని ప్రసిద్ధ నగరం',
      ),

      // --------------------------------------------------------
      // 4. నిలువు
      // రాముడు
      // రా + మ + డు
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D2',
        across: false,
        row: 1,
        col: 0,
        letters: [
          'రా',
          'మ',
          'డు',
        ],
        clue: 'అయోధ్యకు చెందిన యువరాజు',
      ),

      // --------------------------------------------------------
      // 5. అడ్డం
      // మనసు
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'A3',
        across: true,
        row: 2,
        col: 0,
        letters: [
          'మ',
          'న',
          'సు',
        ],
        clue: 'భావాలు, ఆలోచనలు నిలిచే అంతరంగం',
      ),

      // --------------------------------------------------------
      // 6. నిలువు
      // నది
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D3',
        across: false,
        row: 2,
        col: 1,
        letters: [
          'న',
          'ది',
        ],
        clue: 'ప్రవహించే జలధార',
      ),

      // --------------------------------------------------------
      // 7. అడ్డం
      // నీరు
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'A4',
        across: true,
        row: 4,
        col: 0,
        letters: [
          'నీ',
          'రు',
        ],
        clue: 'జీవరాశులకు అత్యవసరమైన ద్రవం',
      ),

      // --------------------------------------------------------
      // 8. నిలువు
      // రుచి
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D4',
        across: false,
        row: 4,
        col: 1,
        letters: [
          'రు',
          'చి',
        ],
        clue: 'ఆహారం ద్వారా తెలిసే అనుభూతి',
      ),

      // --------------------------------------------------------
      // 9. అడ్డం
      // కల
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'A5',
        across: true,
        row: 6,
        col: 0,
        letters: [
          'క',
          'ల',
        ],
        clue: 'నిద్రలో కనిపించేది',
      ),

      // --------------------------------------------------------
      // 10. నిలువు
      // లత
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D5',
        across: false,
        row: 6,
        col: 1,
        letters: [
          'ల',
          'త',
        ],
        clue: 'ఆధారం చేసుకుని పెరిగే సన్నని మొక్క',
      ),

      // --------------------------------------------------------
      // 11. అడ్డం
      // మంచు
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'A6',
        across: true,
        row: 8,
        col: 2,
        letters: [
          'మం',
          'చు',
        ],
        clue: 'చలిలో గడ్డకట్టిన నీటి రూపం',
      ),

      // --------------------------------------------------------
      // 12. నిలువు
      // చుక్క
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D6',
        across: false,
        row: 8,
        col: 3,
        letters: [
          'చు',
          'క్క',
        ],
        clue: 'చిన్న బిందువు లేదా గుర్తు',
      ),

      // --------------------------------------------------------
      // 13. అడ్డం
      // జలం
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'A7',
        across: true,
        row: 10,
        col: 1,
        letters: [
          'జ',
          'లం',
        ],
        clue: 'నీటికి మరో పేరు',
      ),
    ];
  }

  // ==========================================================
  // BUILD CROSSWORD
  // ==========================================================

  void _buildCrossword() {
    for (final entry in entries) {
      for (int i = 0; i < entry.letters.length; i++) {
        final point = GridPoint(
          entry.row + (entry.across ? 0 : i),
          entry.col + (entry.across ? i : 0),
        );

        final answer = entry.letters[i];

        if (!cells.containsKey(point)) {
          cells[point] = CrosswordCell(
            answer: answer,
          );

          controllers[point] =
              TextEditingController();

          focusNodes[point] =
              FocusNode();
        } else {
          // ----------------------------------------------------
          // CROSSING VALIDATION
          // ----------------------------------------------------

          if (cells[point]!.answer != answer) {
            debugPrint(
              'Crossing mismatch at '
              '${point.row}, ${point.col}: '
              '${cells[point]!.answer} != $answer',
            );
          }
        }
      }
    }
  }

  // ==========================================================
  // STANDARD CROSSWORD NUMBERING
  //
  // Number is assigned only to the starting square of a clue.
  // Same square shared by Across + Down gets SAME number.
  // ==========================================================

  void _createNumbering() {
    final startPoints = <GridPoint>{};

    for (final entry in entries) {
      startPoints.add(
        GridPoint(
          entry.row,
          entry.col,
        ),
      );
    }

    final sorted = startPoints.toList();

    sorted.sort((a, b) {
      if (a.row != b.row) {
        return a.row.compareTo(b.row);
      }

      return a.col.compareTo(b.col);
    });

    int number = 1;

    for (final point in sorted) {
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

  // ==========================================================
  // SELECT ENTRY
  // ==========================================================

  void _selectEntry(CrosswordEntry entry) {
    setState(() {
      selectedEntryId = entry.id;
    });
  }

  // ==========================================================
  // SELECT CELL
  // ==========================================================

  void _selectCell(GridPoint point) {
    final matchingEntries = entries.where(
      (entry) => entry.cells.contains(point),
    ).toList();

    if (matchingEntries.isEmpty) {
      return;
    }

    CrosswordEntry selected;

    if (selectedEntryId != null) {
      final current = entries.where(
        (entry) => entry.id == selectedEntryId,
      );

      if (current.isNotEmpty &&
          current.first.cells.contains(point)) {
        selected = current.first;
      } else {
        selected = matchingEntries.first;
      }
    } else {
      selected = matchingEntries.first;
    }

    _selectEntry(selected);

    Future.delayed(
      const Duration(milliseconds: 80),
      () {
        if (!mounted) return;

        focusNodes[point]?.requestFocus();
      },
    );
  }

  // ==========================================================
  // LETTER INPUT
  // ==========================================================

  void _onLetterChanged(
    GridPoint point,
    String value,
  ) {
    if (!cells.containsKey(point)) {
      return;
    }

    final text = value.trim();

    setState(() {
      cells[point]!.typed = text;
      _calculateScore();
    });

    // --------------------------------------------------------
    // IMPORTANT
    //
    // We DO NOT automatically move to another cell.
    // The typed letter stays fixed inside this exact box.
    // --------------------------------------------------------
  }

  // ==========================================================
  // SCORE
  // ==========================================================

  void _calculateScore() {
    int correct = 0;

    for (final cell in cells.values) {
      if (cell.isCorrect) {
        correct++;
      }
    }

    score = correct;
  }

  // ==========================================================
  // SELECTED CELL
  // ==========================================================

  bool _isSelected(GridPoint point) {
    if (selectedEntryId == null) {
      return false;
    }

    final selected = entries.where(
      (entry) => entry.id == selectedEntryId,
    );

    if (selected.isEmpty) {
      return false;
    }

    return selected.first.cells.contains(point);
  }

  // ==========================================================
  // CELL BACKGROUND
  // ==========================================================

  Color _cellBackground(GridPoint point) {
    final cell = cells[point]!;

    // Correct = GREEN
    if (cell.isCorrect) {
      return const Color(0xFFB9EBC4);
    }

    // Selected word = PURPLE
    if (_isSelected(point)) {
      return const Color(0xFFE1D2FF);
    }

    // Normal = WHITE
    return Colors.white;
  }

  // ==========================================================
  // CELL BORDER
  // ==========================================================

  Color _cellBorder(GridPoint point) {
    if (_isSelected(point)) {
      return const Color(0xFF673AB7);
    }

    return const Color(0xFF333333);
  }

  // ==========================================================
  // BUILD CELL
  // ==========================================================

  Widget _buildCell(GridPoint point) {
    final cell = cells[point]!;

    final number = numbers[point];

    final controller = controllers[point]!;

    return GestureDetector(
      onTap: () {
        _selectCell(point);
      },
      child: Container(
        decoration: BoxDecoration(
          color: _cellBackground(point),
          border: Border.all(
            color: _cellBorder(point),
            width: _isSelected(point) ? 2.0 : 1.0,
          ),
        ),
        child: Stack(
          children: [

            // ------------------------------------------------
            // NUMBER
            // ------------------------------------------------

            if (number != null)
              Positioned(
                left: 3,
                top: 2,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),

            // ------------------------------------------------
            // LETTER
            // ------------------------------------------------

            Positioned.fill(
              child: Center(
                child: TextField(
                  controller: controller,
                  focusNode: focusNodes[point],

                  // No cursor.
                  showCursor: false,

                  // One line only.
                  maxLines: 1,

                  // We don't want Flutter's counter.
                  maxLength: 8,

                  textAlign: TextAlign.center,

                  textAlignVertical:
                      TextAlignVertical.center,

                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    height: 1.0,
                  ),

                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                  ),

                  onTap: () {
                    _selectCell(point);
                  },

                  onChanged: (value) {
                    _onLetterChanged(
                      point,
                      value,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // GRID
  // ==========================================================

  Widget _buildGrid() {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics:
            const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
        ),
        itemCount: gridSize * gridSize,
        itemBuilder: (context, index) {
          final row = index ~/ gridSize;
          final col = index % gridSize;

          final point = GridPoint(
            row,
            col,
          );

          // --------------------------------------------------
          // BLACK BLOCK
          // --------------------------------------------------

          if (!cells.containsKey(point)) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF202124),
              ),
            );
          }

          return _buildCell(point);
        },
      ),
    );
  }

  // ==========================================================
  // CLUE ITEM
  // ==========================================================

  Widget _buildClue(
    CrosswordEntry entry,
  ) {
    final number =
        entryNumbers[entry.id] ?? 0;

    final selected =
        selectedEntryId == entry.id;

    final direction =
        entry.across ? 'అడ్డం' : 'నిలువు';

    return GestureDetector(
      onTap: () {
        _selectEntry(entry);
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 150),
        width: double.infinity,
        margin:
            const EdgeInsets.only(bottom: 8),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFE1D2FF)
              : const Color(0xFFF1F3F6),
          borderRadius:
              BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? const Color(0xFF673AB7)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            // NUMBER
            Text(
              '$number.',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(width: 7),

            // DIRECTION
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF673AB7)
                    : Colors.black87,
                borderRadius:
                    BorderRadius.circular(5),
              ),
              child: Text(
                direction,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // CLUE + LENGTH
            Expanded(
              child: Text(
                '${entry.clue} '
                '(${entry.length} అక్షరాలు)',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // CLUES
  // ==========================================================

  Widget _buildClues() {
    final acrossEntries = entries
        .where((entry) => entry.across)
        .toList();

    final downEntries = entries
        .where((entry) => !entry.across)
        .toList();

    acrossEntries.sort(
      (a, b) => (entryNumbers[a.id] ?? 0)
          .compareTo(entryNumbers[b.id] ?? 0),
    );

    downEntries.sort(
      (a, b) => (entryNumbers[a.id] ?? 0)
          .compareTo(entryNumbers[b.id] ?? 0),
    );

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        // ----------------------------------------------------
        // ACROSS
        // ----------------------------------------------------

        const Padding(
          padding: EdgeInsets.only(
            bottom: 10,
          ),
          child: Text(
            'అడ్డం',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF673AB7),
            ),
          ),
        ),

        ...acrossEntries.map(
          _buildClue,
        ),

        const SizedBox(height: 18),

        // ----------------------------------------------------
        // DOWN
        // ----------------------------------------------------

        const Padding(
          padding: EdgeInsets.only(
            bottom: 10,
          ),
          child: Text(
            'నిలువు',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF673AB7),
            ),
          ),
        ),

        ...downEntries.map(
          _buildClue,
        ),
      ],
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader() {
    final total = cells.length;

    return Column(
      children: [

        const SizedBox(height: 8),

        const Text(
          'పద గమనం',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'తెలుగు పద పజిల్',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Text(
              'స్కోర్: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$score / $total',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF673AB7),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  // ==========================================================
  // MAIN BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:
            const Color(0xFFEDE2F8),
        title: const Text(
          'పద గమనం',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            14,
            10,
            14,
            30,
          ),
          child: Column(
            children: [

              // HEADER
              _buildHeader(),

              // ------------------------------------------------
              // GRID
              // ------------------------------------------------

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      offset: Offset(0, 2),
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: _buildGrid(),
              ),

              const SizedBox(height: 20),

              // ------------------------------------------------
              // CLUES
              // ------------------------------------------------

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0FF),
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: _buildClues(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    for (final controller
        in controllers.values) {
      controller.dispose();
    }

    for (final node
        in focusNodes.values) {
      node.dispose();
    }

    super.dispose();
  }
}
