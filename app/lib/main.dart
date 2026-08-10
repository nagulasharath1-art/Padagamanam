import 'package:flutter/material.dart';

void main() {
  runApp(const PadagamanamApp());
}

// ============================================================
// PADAGAMANAM
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B3FA0),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF9FF),
      ),
      home: const CrosswordPage(),
    );
  }
}

// ============================================================
// POINT
// ============================================================

class CellPoint {
  final int row;
  final int col;

  const CellPoint(this.row, this.col);

  @override
  bool operator ==(Object other) {
    return other is CellPoint &&
        other.row == row &&
        other.col == col;
  }

  @override
  int get hashCode => Object.hash(row, col);
}

// ============================================================
// ENTRY
// ============================================================

class CrosswordEntry {
  final String id;
  final bool across;
  final int row;
  final int col;
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

  List<CellPoint> get cells {
    return List.generate(
      letters.length,
      (index) => CellPoint(
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
    required this.answer,
    this.typed = '',
  });

  bool get hasLetter => typed.trim().isNotEmpty;

  bool get isCorrect =>
      hasLetter && typed.trim() == answer;

  bool get isWrong =>
      hasLetter && typed.trim() != answer;
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

  final Map<CellPoint, CrosswordCell> cells = {};
  final Map<CellPoint, int> numbers = {};

  final Map<CellPoint, TextEditingController> controllers = {};
  final Map<CellPoint, FocusNode> focusNodes = {};

  String? selectedEntryId;
  bool showAcross = true;

  int score = 0;

  @override
  void initState() {
    super.initState();

    entries = _createPuzzle();

    _buildGrid();
    _createNumbering();
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }

    for (final node in focusNodes.values) {
      node.dispose();
    }

    super.dispose();
  }

  // ==========================================================
  // PUZZLE
  // ==========================================================

  List<CrosswordEntry> _createPuzzle() {
    return const [

      // --------------------------------------------------------
      // 1. అడ్డం
      // సంస్కృతం
      // సం | స్కృ | తం
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'A1',
        across: true,
        row: 0,
        col: 0,
        letters: ['సం', 'స్కృ', 'తం'],
        clue: 'మంత్రాలు, శ్లోకాలు మొదలైనవి ఎక్కువగా ఉన్న ప్రాచీన భాష',
      ),

      // --------------------------------------------------------
      // 2. నిలువు
      // తండ్రి
      // తం | డ్రి
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D2',
        across: false,
        row: 0,
        col: 2,
        letters: ['తం', 'డ్రి'],
        clue: 'ఇంటి పెద్ద',
      ),

      // --------------------------------------------------------
      // 3. అడ్డం
      // రాజమండ్రి
      // రా | జ | మం | డ్రి
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'A3',
        across: true,
        row: 2,
        col: 0,
        letters: ['రా', 'జ', 'మం', 'డ్రి'],
        clue: 'గోదావరి తీరాన వెలసిన ప్రసిద్ధ నగరం',
      ),

      // --------------------------------------------------------
      // 4. నిలువు
      // రాముడు
      // రా | మ | డు
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D4',
        across: false,
        row: 2,
        col: 0,
        letters: ['రా', 'మ', 'డు'],
        clue: 'అయోధ్యకు చెందిన ఇతిహాస యువరాజు',
      ),

      // --------------------------------------------------------
      // 5. నిలువు
      // జలం
      // జ | లం
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D5',
        across: false,
        row: 2,
        col: 1,
        letters: ['జ', 'లం'],
        clue: 'నీటికి మరో పేరు',
      ),

      // --------------------------------------------------------
      // 6. నిలువు
      // మంచు
      // మం | చు
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D6',
        across: false,
        row: 2,
        col: 2,
        letters: ['మం', 'చు'],
        clue: 'చలిలో గడ్డకట్టిన నీటి రూపం',
      ),

      // --------------------------------------------------------
      // 7. నిలువు
      // డ్రిల్
      // డ్రి | ల్
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D7',
        across: false,
        row: 2,
        col: 3,
        letters: ['డ్రి', 'ల్'],
        clue: 'రంధ్రం చేయడానికి ఉపయోగించే పరికరం',
      ),

      // --------------------------------------------------------
      // 8. అడ్డం
      // మనసు
      // మ | న | సు
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'A8',
        across: true,
        row: 5,
        col: 0,
        letters: ['మ', 'న', 'సు'],
        clue: 'భావాలు, ఆలోచనలు నివసించే అంతరంగం',
      ),

      // --------------------------------------------------------
      // 9. నిలువు
      // నది
      // న | ది
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D9',
        across: false,
        row: 5,
        col: 1,
        letters: ['న', 'ది'],
        clue: 'ప్రవహించే జలధార',
      ),

      // --------------------------------------------------------
      // 10. నిలువు
      // సుఖం
      // సు | ఖం
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D10',
        across: false,
        row: 5,
        col: 2,
        letters: ['సు', 'ఖం'],
        clue: 'ఆనందాన్ని సూచించే భావం',
      ),

      // --------------------------------------------------------
      // 11. అడ్డం
      // నీరు
      // నీ | రు
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'A11',
        across: true,
        row: 7,
        col: 0,
        letters: ['నీ', 'రు'],
        clue: 'జీవానికి అత్యవసరమైన ద్రవం',
      ),

      // --------------------------------------------------------
      // 12. నిలువు
      // నీటి
      // నీ | టి
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D12',
        across: false,
        row: 7,
        col: 0,
        letters: ['నీ', 'టి'],
        clue: 'జలానికి సంబంధించినది',
      ),

      // --------------------------------------------------------
      // 13. నిలువు
      // రుచి
      // రు | చి
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D13',
        across: false,
        row: 7,
        col: 1,
        letters: ['రు', 'చి'],
        clue: 'ఆహారాన్ని ఆస్వాదించినప్పుడు తెలిసేది',
      ),

      // --------------------------------------------------------
      // 14. అడ్డం
      // కల
      // క | ల
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'A14',
        across: true,
        row: 9,
        col: 0,
        letters: ['క', 'ల'],
        clue: 'నిద్రలో కనిపించే ఊహాచిత్రం',
      ),

      // --------------------------------------------------------
      // 15. నిలువు
      // లత
      // ల | త
      // --------------------------------------------------------

      CrosswordEntry(
        id: 'D15',
        across: false,
        row: 9,
        col: 1,
        letters: ['ల', 'త'],
        clue: 'ఆధారం చేసుకుని పైకి పాకే సన్నని మొక్క',
      ),
    ];
  }

  // ==========================================================
  // BUILD GRID
  // ==========================================================

  void _buildGrid() {
    for (final entry in entries) {
      for (int i = 0; i < entry.letters.length; i++) {
        final point = CellPoint(
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
          // Crossing validation.
          if (cells[point]!.answer != answer) {
            debugPrint(
              'CROSSING ERROR: '
              '${point.row},${point.col} '
              '${cells[point]!.answer} != $answer',
            );
          }
        }
      }
    }
  }

  // ==========================================================
  // NUMBERING
  // ==========================================================

  void _createNumbering() {
    final startCells = <CellPoint>{};

    for (final entry in entries) {
      startCells.add(
        CellPoint(
          entry.row,
          entry.col,
        ),
      );
    }

    final sorted = startCells.toList()
      ..sort((a, b) {
        if (a.row != b.row) {
          return a.row.compareTo(b.row);
        }

        return a.col.compareTo(b.col);
      });

    int number = 1;

    for (final point in sorted) {
      numbers[point] = number;
      number++;
    }
  }

  // ==========================================================
  // SELECT ENTRY
  // ==========================================================

  void _selectEntry(CrosswordEntry entry) {
    setState(() {
      selectedEntryId = entry.id;
      showAcross = entry.across;
    });

    final firstCell = entry.cells.first;

    Future.delayed(
      const Duration(milliseconds: 80),
      () {
        if (!mounted) return;

        focusNodes[firstCell]?.requestFocus();
      },
    );
  }

  // ==========================================================
  // INPUT
  // ==========================================================

  void _onLetterChanged(
    CellPoint point,
    String value,
  ) {
    if (!cells.containsKey(point)) {
      return;
    }

    // Keep only the latest user-entered grapheme-like unit.
    String newValue = value.trim();

    if (newValue.isEmpty) {
      setState(() {
        cells[point]!.typed = '';
        _calculateScore();
      });

      return;
    }

    // A cell represents one Telugu orthographic unit.
    // We deliberately do NOT move focus automatically.
    setState(() {
      cells[point]!.typed = newValue;
      _calculateScore();
    });
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

  bool _isSelected(CellPoint point) {
    if (selectedEntryId == null) {
      return false;
    }

    final entry = entries.firstWhere(
      (e) => e.id == selectedEntryId,
    );

    return entry.cells.contains(point);
  }

  // ==========================================================
  // CELL BACKGROUND
  // ==========================================================

  Color _cellBackground(CellPoint point) {
    final cell = cells[point]!;

    // Correct letter gets green immediately.
    if (cell.isCorrect) {
      return const Color(0xFFB9E8C2);
    }

    // Selected word gets purple.
    if (_isSelected(point)) {
      return const Color(0xFFE7D9FF);
    }

    return Colors.white;
  }

  // ==========================================================
  // CELL
  // ==========================================================

  Widget _buildCell(CellPoint point) {
    final cell = cells[point]!;
    final number = numbers[point];

    final selected = _isSelected(point);

    return GestureDetector(
      onTap: () {
        final possible = entries.where(
          (entry) => entry.cells.contains(point),
        );

        if (possible.isEmpty) return;

        CrosswordEntry chosen;

        if (selectedEntryId != null) {
          final current = entries.firstWhere(
            (entry) => entry.id == selectedEntryId,
          );

          if (current.cells.contains(point)) {
            chosen = current;
          } else {
            chosen = possible.first;
          }
        } else {
          chosen = possible.first;
        }

        _selectEntry(chosen);
      },
      child: Container(
        decoration: BoxDecoration(
          color: _cellBackground(point),
          border: Border.all(
            color: selected
                ? const Color(0xFF7042B5)
                : Colors.black,
            width: selected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [

            // --------------------------------------------------
            // NUMBER
            // --------------------------------------------------

            if (number != null)
              Positioned(
                top: 2,
                left: 3,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    fontSize: 9,
                    height: 1,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),

            // --------------------------------------------------
            // LETTER
            // --------------------------------------------------

            Positioned.fill(
              child: Center(
                child: TextField(
                  controller: controllers[point],
                  focusNode: focusNodes[point],

                  // Important:
                  // no automatic movement.
                  showCursor: false,

                  textAlign: TextAlign.center,
                  textAlignVertical:
                      TextAlignVertical.center,

                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: cell.isCorrect
                        ? const Color(0xFF16803A)
                        : Colors.black,
                  ),

                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                  ),

                  onTap: () {
                    final possible = entries.where(
                      (entry) =>
                          entry.cells.contains(point),
                    );

                    if (possible.isNotEmpty) {
                      _selectEntry(possible.first);
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
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // BLACK / WHITE GRID
  // ==========================================================

  Widget _buildGrid() {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics:
            const NeverScrollableScrollPhysics(),
        itemCount: gridSize * gridSize,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
        ),
        itemBuilder: (context, index) {
          final row = index ~/ gridSize;
          final col = index % gridSize;

          final point = CellPoint(row, col);

          // BLACK BLOCK
          if (!cells.containsKey(point)) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF202020),
              ),
            );
          }

          return _buildCell(point);
        },
      ),
    );
  }

  // ==========================================================
  // CLUE LIST
  // ==========================================================

  List<CrosswordEntry> get _visibleEntries {
    return entries
        .where(
          (entry) => entry.across == showAcross,
        )
        .toList();
  }

  Widget _buildClue(CrosswordEntry entry) {
    final start =
        CellPoint(entry.row, entry.col);

    final number =
        numbers[start] ?? 0;

    final selected =
        selectedEntryId == entry.id;

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
          horizontal: 14,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFD9E6FF)
              : const Color(0xFFF3F5FA),
          borderRadius:
              BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Text(
              '$number.',
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                '${entry.clue} '
                '(${entry.length} అక్షరాలు)',
                style: TextStyle(
                  fontSize: 18,
                  height: 1.45,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // CLUE PANEL
  // ==========================================================

  Widget _buildCluePanel() {
    return Container(
      margin: const EdgeInsets.only(
        top: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFD0D8EA),
        ),
      ),
      child: Column(
        children: [

          // ----------------------------------------------------
          // TABS
          // ----------------------------------------------------

          SizedBox(
            height: 58,
            child: Row(
              children: [

                Expanded(
                  child: _tab(
                    title: 'అడ్డం',
                    active: showAcross,
                    onTap: () {
                      setState(() {
                        showAcross = true;
                      });
                    },
                  ),
                ),

                Expanded(
                  child: _tab(
                    title: 'నిలువు',
                    active: !showAcross,
                    onTap: () {
                      setState(() {
                        showAcross = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
          ),

          // ----------------------------------------------------
          // CLUES
          // ----------------------------------------------------

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: _visibleEntries
                  .map(_buildClue)
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab({
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.end,
        children: [

          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: active
                      ? FontWeight.w800
                      : FontWeight.w500,
                  color: active
                      ? const Color(0xFF145EA8)
                      : Colors.black54,
                ),
              ),
            ),
          ),

          AnimatedContainer(
            duration:
                const Duration(milliseconds: 180),
            height: 4,
            width: active ? 70 : 0,
            decoration: BoxDecoration(
              color: const Color(0xFF1769AA),
              borderRadius:
                  BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PAGE
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color(0xFFFFF9FF),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'పద గమనం',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Color(0xFF0B78C8),
                  size: 34,
                ),
                const SizedBox(width: 5),
                Text(
                  '$score',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF0B5F9E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            18,
            8,
            18,
            28,
          ),
          child: Column(
            children: [

              // ------------------------------------------------
              // GRID
              // ------------------------------------------------

              _buildGrid(),

              // ------------------------------------------------
              // CLUES
              // ------------------------------------------------

              _buildCluePanel(),
            ],
          ),
        ),
      ),
    );
  }
}
