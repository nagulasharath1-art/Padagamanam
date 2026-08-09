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
        scaffoldBackgroundColor: const Color(0xFFFFF8FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const CrosswordPage(),
    );
  }
}

// ============================================================
// POINT
// ============================================================

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

// ============================================================
// CROSSWORD ENTRY
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

  List<Point> get cells {
    return List.generate(
      letters.length,
      (i) => Point(
        row + (across ? 0 : i),
        col + (across ? i : 0),
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
      typed.isNotEmpty && typed == answer;
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

  late List<CrosswordEntry> entries;

  final Map<Point, CrosswordCell> cells = {};
  final Map<Point, int> numbers = {};
  final Map<String, int> entryNumbers = {};

  final Map<Point, TextEditingController> controllers = {};
  final Map<Point, FocusNode> focusNodes = {};

  String? selectedEntryId;

  int score = 0;

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    entries = _createEntries();

    _buildGrid();
    _createNumbering();
  }

  // ==========================================================
  // CROSSWORD DATA
  // ==========================================================

  List<CrosswordEntry> _createEntries() {
    return const [

      // ------------------------------------------------------
      // 1. అడ్డం
      // సంస్కృతం
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'A1',
        across: true,
        row: 0,
        col: 0,
        letters: ['సం', 'స్కృ', 'తం'],
        clue: 'మంత్రాలన్నీ ఉండే భాషలోనే',
      ),

      // ------------------------------------------------------
      // 2. నిలువు
      // తండ్రి
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'D1',
        across: false,
        row: 0,
        col: 2,
        letters: ['తం', 'డ్రి'],
        clue: 'ఇంటి పెద్ద',
      ),

      // ------------------------------------------------------
      // 3. అడ్డం
      // రాజమండ్రి
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'A2',
        across: true,
        row: 2,
        col: 0,
        letters: ['రా', 'జ', 'మం', 'డ్రి'],
        clue: 'గోదావరి తీరంలోని ప్రసిద్ధ నగరం',
      ),

      // ------------------------------------------------------
      // 4. నిలువు
      // రాముడు
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'D2',
        across: false,
        row: 2,
        col: 0,
        letters: ['రా', 'మ', 'డు'],
        clue: 'అయోధ్య యువరాజు',
      ),

      // ------------------------------------------------------
      // 5. నిలువు
      // జలం
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'D3',
        across: false,
        row: 2,
        col: 1,
        letters: ['జ', 'లం'],
        clue: 'నీటికి మరో పేరు',
      ),

      // ------------------------------------------------------
      // 6. నిలువు
      // మంచు
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'D4',
        across: false,
        row: 2,
        col: 2,
        letters: ['మం', 'చు'],
        clue: 'చలికాలంలో తెల్లగా కనిపించేది',
      ),

      // ------------------------------------------------------
      // 7. నిలువు
      // డ్రిల్
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'D5',
        across: false,
        row: 2,
        col: 3,
        letters: ['డ్రి', 'ల్'],
        clue: 'రంధ్రం చేయడానికి ఉపయోగించే పరికరం',
      ),

      // ------------------------------------------------------
      // 8. అడ్డం
      // మనసు
      // ------------------------------------------------------

      CrosswordEntry(
        id: 'A3',
        across: true,
        row: 5,
        col: 0,
        letters: ['మ',
