import 'package:characters/characters.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const PadagamanamApp());
}

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
          seedColor: const Color(0xFF6A3FA0),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F3EC),
      ),
      home: const PuzzleScreen(),
    );
  }
}

enum Direction {
  across,
  down,
}

class WordEntry {
  final int number;
  final String clue;
  final List<String> answer;
  final int row;
  final int col;
  final Direction direction;

  const WordEntry({
    required this.number,
    required this.clue,
    required this.answer,
    required this.row,
    required this.col,
    required this.direction,
  });

  int get length => answer.length;
}

class PadagamanamPuzzle {
  final String id;
  final String title;
  final String difficulty;
  final int size;
  final List<WordEntry> words;

  const PadagamanamPuzzle({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.size,
    required this.words,
  });
}

/*
  TEST PUZZLE

  Grid:

  ■ 1 2 3 ■
  ■ 4 5 6 ■
  ■ ■ 7 8 ■
  ■ ■ ■ ■ ■

  Words:

  కలము
  కల
  లయం
  ముళ్లు
  కళ్ళు

  ప్రతి answerని Telugu grapheme clustersగా
  విడిగా ఇస్తున్నాం.
*/

const testPuzzle = PadagamanamPuzzle(
  id: 'PG-TEST-001',
  title: 'పజిల్ 01',
  difficulty: 'సులభం',
  size: 5,
  words: [
    WordEntry(
      number: 1,
      clue: 'మాటను కాగితంపై నడిపించిన పాత సహచరుడు',
      answer: ['క', 'ల', 'ము'],
      row: 0,
      col: 1,
      direction: Direction.across,
    ),

    WordEntry(
      number: 1,
      clue: 'నిద్రలో మనసు వేసే సినిమా',
      answer: ['క', 'ల'],
      row: 0,
      col: 1,
      direction: Direction.down,
    ),

    WordEntry(
      number: 2,
      clue: 'శబ్దాల మధ్య కనిపించని అడుగు',
      answer: ['ల', 'యం'],
      row: 0,
      col: 2,
      direction: Direction.down,
    ),

    WordEntry(
      number: 3,
      clue: 'పువ్వును తాకే ముందు చేతిని ఆపేది',
      answer: ['ము', 'ళ్ళు'],
      row: 0,
      col: 3,
      direction: Direction.down,
    ),

    WordEntry(
      number: 4,
      clue: 'చూస్తాయి; కానీ తమను తాము చూడలేవు',
      answer: ['క', 'ళ్ళు'],
      row: 2,
      col: 2,
      direction: Direction.across,
    ),
  ],
);

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  final PadagamanamPuzzle puzzle = testPuzzle;

  late final List<List<String?>> solutionGrid;
  late final List<List<bool>> activeCells;

  late final List<List<TextEditingController>> controllers;
  late final List<List<FocusNode>> focusNodes;

  int selectedRow = 0;
  int selectedCol = 1;

  final Set<String> checkedCells = {};
  final Set<String> wrongCells = {};

  @override
  void initState() {
    super.initState();

    solutionGrid = List.generate(
      puzzle.size,
      (_) => List<String?>.filled(puzzle.size, null),
    );

    activeCells = List.generate(
      puzzle.size,
      (_) => List<bool>.filled(puzzle.size, false),
    );

    _buildGrid();

    controllers = List.generate(
      puzzle.size,
      (_) => List.generate(
        puzzle.size,
        (_) => TextEditingController(),
      ),
    );

    focusNodes = List.generate(
      puzzle.size,
      (_) => List.generate(
        puzzle.size,
        (_) => FocusNode(),
      ),
    );
  }

  void _buildGrid() {
    for (final word in puzzle.words) {
      for (int i = 0; i < word.answer.length; i++) {
        final row = word.direction == Direction.down
            ? word.row + i
            : word.row;

        final col = word.direction == Direction.across
            ? word.col + i
            : word.col;

        final letter = word.answer[i];

        solutionGrid[row][col] = letter;
        activeCells[row][col] = true;
      }
    }
  }

  String _cellKey(int row, int col) => '$row-$col';

  bool _isCorrect(int row, int col) {
    final expected = solutionGrid[row][col];

    if (expected == null) {
      return false;
    }

    final typed = controllers[row][col].text.characters.toList();

    if (typed.isEmpty) {
      return false;
    }

    return typed.first == expected;
  }

  void _handleInput(int row, int col, String value) {
    final chars = value.characters.toList();

    if (chars.isEmpty) {
      wrongCells.remove(_cellKey(row, col));
      checkedCells.remove(_cellKey(row, col));

      setState(() {});
      return;
    }

    final firstCharacter = chars.first;

    controllers[row][col].value = TextEditingValue(
      text: firstCharacter,
      selection: TextSelection.collapsed(
        offset: firstCharacter.length,
      ),
    );

    checkedCells.remove(_cellKey(row, col));
    wrongCells.remove(_cellKey(row, col));

    _moveToNextCell(row, col);

    setState(() {});
  }

  void _moveToNextCell(int row, int col) {
    for (int c = col + 1; c < puzzle.size; c++) {
      if (activeCells[row][c]) {
        _selectCell(row, c);
        return;
      }
    }

    for (int r = row + 1; r < puzzle.size; r++) {
      if (activeCells[r][col]) {
        _selectCell(r, col);
        return;
      }
    }
  }

  void _selectCell(int row, int col) {
    if (!activeCells[row][col]) {
      return;
    }

    setState(() {
      selectedRow = row;
      selectedCol = col;
    });

    FocusScope.of(context).requestFocus(
      focusNodes[row][col],
    );
  }

  void _checkAnswers() {
    int total = 0;
    int correct = 0;

    checkedCells.clear();
    wrongCells.clear();

    for (int row = 0; row < puzzle.size; row++) {
      for (int col = 0; col < puzzle.size; col++) {
        if (!activeCells[row][col]) {
          continue;
        }

        total++;

        final key = _cellKey(row, col);
        checkedCells.add(key);

        if (_isCorrect(row, col)) {
          correct++;
        } else {
          wrongCells.add(key);
        }
      }
    }

    setState(() {});

    final completed = correct == total;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            completed
                ? 'పజిల్ పూర్తయింది 🎉'
                : 'మళ్ళీ ప్రయత్నించు',
          ),
          content: Text(
            completed
                ? 'అద్భుతం! అన్ని జవాబులు సరైనవి.'
                : '$correct / $total అక్షరాలు సరైనవి.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('సరే'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCell(int row, int col) {
    if (!activeCells[row][col]) {
      return Container(
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: const Color(0xFF29252D),
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    final key = _cellKey(row, col);
    final selected = row == selectedRow && col == selectedCol;
    final wrong = wrongCells.contains(key);

    final borderColor = selected
        ? const Color(0xFF7B3FC6)
        : Colors.black87;

    return GestureDetector(
      onTap: () => _selectCell(row, col),
      child: Container(
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: borderColor,
            width: selected ? 3 : 1,
          ),
        ),
        child: Center(
          child: TextField(
            controller: controllers[row][col],
            focusNode: focusNodes[row][col],
            onTap: () => _selectCell(row, col),
            onChanged: (value) {
              _handleInput(row, col, value);
            },
            textAlign: TextAlign.center,
            maxLines: 1,
            maxLength: 6,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: wrong
                  ? Colors.red
                  : Colors.black,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }

  Widget _clueItem(WordEntry word) {
    final directionText =
        word.direction == Direction.across
            ? 'అడ్డం'
            : 'నిలువు';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE8DDF2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${word.number}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  word.clue,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  directionText,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (final row in controllers) {
      for (final controller in row) {
        controller.dispose();
      }
    }

    for (final row in focusNodes) {
      for (final node in row) {
        node.dispose();
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final across = puzzle.words
        .where((word) => word.direction == Direction.across)
        .toList();

    final down = puzzle.words
        .where((word) => word.direction == Direction.down)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'పద గమనం',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            18,
            12,
            18,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                puzzle.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                puzzle.difficulty,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 22),

              Center(
                child: SizedBox(
                  width: 330,
                  height: 330,
                  child: GridView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount:
                        puzzle.size * puzzle.size,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: puzzle.size,
                    ),
                    itemBuilder: (context, index) {
                      final row =
                          index ~/ puzzle.size;
                      final col =
                          index % puzzle.size;

                      return _buildCell(row, col);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'అడ్డంగా',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 14),

              ...across.map(_clueItem),

              const SizedBox(height: 18),

              const Text(
                'నిలువుగా',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 14),

              ...down.map(_clueItem),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: _checkAnswers,
                  child: const Text(
                    'జవాబులను తనిఖీ చేయి',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
