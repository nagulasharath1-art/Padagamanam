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
          seedColor: Colors.deepPurple,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8FF),
      ),
      home: const CrosswordPage(),
    );
  }
}

class CrosswordPage extends StatefulWidget {
  const CrosswordPage({super.key});

  @override
  State<CrosswordPage> createState() => _CrosswordPageState();
}

class _CrosswordPageState extends State<CrosswordPage> {
  // true = white answer cell
  // false = black blocked cell
  final List<List<bool>> grid = [
    [true, true, true, false, true, true, true, true, false, true, true],
    [true, false, true, false, true, false, true, false, true, false, true],
    [true, true, true, true, true, true, true, true, true, true, true],
    [false, true, false, true, true, false, true, false, true, false, true],
    [true, true, true, true, false, true, true, true, false, true, true],
    [true, false, true, false, true, false, true, false, true, false, true],
    [true, true, true, true, true, true, true, true, true, true, true],
    [true, false, true, false, true, false, true, false, true, false, true],
    [true, true, true, false, true, true, true, false, true, true, true],
    [true, false, true, false, true, false, true, false, true, false, true],
    [true, true, true, true, true, true, true, true, true, true, true],
  ];

  final Map<String, String> answers = {};

  int? selectedRow;
  int? selectedCol;

  final List<Map<String, String>> acrossClues = [
    {
      'number': '1',
      'clue': 'తెలుగు భాషకు సంబంధించిన పదం',
    },
    {
      'number': '5',
      'clue': 'వెలుగు ఇచ్చేది',
    },
    {
      'number': '9',
      'clue': 'నీటితో నిండిన ప్రదేశం',
    },
    {
      'number': '13',
      'clue': 'మనసుకు సంబంధించినది',
    },
    {
      'number': '17',
      'clue': 'పూర్వకాలానికి చెందినది',
    },
    {
      'number': '21',
      'clue': 'జ్ఞానాన్ని అందించేది',
    },
    {
      'number': '25',
      'clue': 'ప్రకృతిలో కనిపించేది',
    },
  ];

  final List<Map<String, String>> downClues = [
    {
      'number': '2',
      'clue': 'చదువుకు ఉపయోగించేది',
    },
    {
      'number': '3',
      'clue': 'ఆకాశంలో కనిపించేది',
    },
    {
      'number': '6',
      'clue': 'సంతోషానికి వ్యతిరేకం',
    },
    {
      'number': '8',
      'clue': 'తెలుగు సాహిత్యంలో ఒక ప్రక్రియ',
    },
    {
      'number': '10',
      'clue': 'నదికి మరో పేరు',
    },
    {
      'number': '14',
      'clue': 'మనిషి నివసించే ప్రదేశం',
    },
  ];

  bool isWhite(int row, int col) {
    return grid[row][col];
  }

  bool startsAcross(int row, int col) {
    if (!isWhite(row, col)) return false;

    if (col == 0 || !isWhite(row, col - 1)) {
      return col + 1 < grid[row].length && isWhite(row, col + 1);
    }

    return false;
  }

  bool startsDown(int row, int col) {
    if (!isWhite(row, col)) return false;

    if (row == 0 || !isWhite(row - 1, col)) {
      return row + 1 < grid.length && isWhite(row + 1, col);
    }

    return false;
  }

  Map<String, int> generateNumbers() {
    final Map<String, int> numbers = {};
    int number = 1;

    for (int r = 0; r < grid.length; r++) {
      for (int c = 0; c < grid[r].length; c++) {
        if (isWhite(r, c) && (startsAcross(r, c) || startsDown(r, c))) {
          numbers['$r-$c'] = number;
          number++;
        }
      }
    }

    return numbers;
  }

  List<List<String>> getSelectedCells() {
    final result = <List<String>>[];

    if (selectedRow == null || selectedCol == null) {
      return result;
    }

    int r = selectedRow!;
    int c = selectedCol!;

    bool across = false;

    if (c == 0 || !isWhite(r, c - 1)) {
      across = c + 1 < grid[r].length && isWhite(r, c + 1);
    }

    if (across) {
      int start = c;

      while (start > 0 && isWhite(r, start - 1)) {
        start--;
      }

      int end = c;

      while (end < grid[r].length - 1 && isWhite(r, end + 1)) {
        end++;
      }

      for (int i = start; i <= end; i++) {
        result.add(['$r-$i']);
      }
    } else {
      int start = r;

      while (start > 0 && isWhite(start - 1, c)) {
        start--;
      }

      int end = r;

      while (end < grid.length - 1 && isWhite(end + 1, c)) {
        end++;
      }

      for (int i = start; i <= end; i++) {
        result.add(['$i-$c']);
      }
    }

    return result;
  }

  bool isSelected(int row, int col) {
    final cells = getSelectedCells();

    return cells.any(
      (cell) => cell[0] == '$row-$col',
    );
  }

  void openLetterInput(int row, int col) {
    if (!isWhite(row, col)) return;

    setState(() {
      selectedRow = row;
      selectedCol = col;
    });

    final controller = TextEditingController(
      text: answers['$row-$col'] ?? '',
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFFF8FF),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'అక్షరం నమోదు చేయండి',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: controller,
                autofocus: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'అక్షరం',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      answers['$row-$col'] = controller.text.trim();
                    });

                    Navigator.pop(context);
                  },
                  child: const Text(
                    'నమోదు చేయండి',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildCell(
    int row,
    int col,
    Map<String, int> numbers,
  ) {
    if (!isWhite(row, col)) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
      );
    }

    final key = '$row-$col';
    final number = numbers[key];
    final selected = isSelected(row, col);
    final value = answers[key] ?? '';

    return GestureDetector(
      onTap: () => openLetterInput(row, col),
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFE5D5FF)
              : Colors.white,
          border: Border.all(
            color: selected
                ? Colors.deepPurple
                : Colors.black,
            width: selected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            if (number != null)
              Positioned(
                left: 4,
                top: 2,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

            Center(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildClueSection(
    String title,
    List<Map<String, String>> clues,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        ...clues.map(
          (item) => Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 34,
                  child: Text(
                    '${item['number']}.',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    item['clue']!,
                    style: const TextStyle(
                      fontSize: 17,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final numbers = generateNumbers();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'పద గమనం',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFEFE4F5),
      ),

      body: Column(
        children: [
          const SizedBox(height: 18),

          const Text(
            'తెలుగు పద పజిల్',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'స్కోర్: 0',
            style: TextStyle(
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 18),

          // FIXED CROSSWORD GRID
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: grid.length * grid[0].length,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: grid[0].length,
                ),
                itemBuilder: (context, index) {
                  final row = index ~/ grid[0].length;
                  final col = index % grid[0].length;

                  return buildCell(
                    row,
                    col,
                    numbers,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ONLY CLUES SCROLL
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                22,
                10,
                22,
                30,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  buildClueSection(
                    'అడ్డంగా',
                    acrossClues,
                  ),

                  const SizedBox(height: 24),

                  buildClueSection(
                    'నిలువుగా',
                    downClues,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'సమాధానాలు పరిశీలించబడుతున్నాయి...',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check),
                      label: const Text(
                        'సమాధానాలు పరిశీలించు',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
