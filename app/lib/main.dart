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
  // true = white cell
  // false = black cell
  //
  // Crossword pattern
  final List<List<bool>> grid = [
    [true, true, true, false, true, true, true, false, true, true, true],
    [true, true, true, true, true, false, true, true, true, true, true],
    [true, false, true, true, true, true, true, true, true, false, true],
    [false, true, true, true, false, true, true, true, false, true, true],
    [true, true, true, true, true, true, true, true, true, true, true],
    [true, false, true, true, true, false, true, true, true, false, true],
    [true, true, true, false, true, true, true, false, true, true, true],
    [true, true, false, true, true, true, false, true, true, true, true],
    [true, false, true, true, true, false, true, true, true, false, true],
    [false, true, true, true, false, true, true, true, false, true, true],
    [true, true, true, true, true, true, true, true, true, true, true],
  ];

  final Map<String, TextEditingController> controllers = {};
  final Map<String, FocusNode> focusNodes = {};

  int? selectedRow;
  int? selectedCol;

  String selectedDirection = 'A';

  final List<String> acrossClues = [
    'తెలుగు భాషలోని ఒక పదం',
    'ఉదయం ఉదయించేది',
    'మన చుట్టూ ఉండేది',
    'చదువుకు ఉపయోగించేది',
    'జ్ఞానాన్ని అందించేది',
    'పూలతో ఉండేది',
    'నీటితో ప్రవహించేది',
    'ఆకాశంలో కనిపించేది',
    'రాత్రివేళ కనిపించేది',
    'మనసుకు ఇష్టమైనది',
    'పండుగలో కనిపించేది',
    'పూర్వకాలానికి చెందినది',
    'సంగీతంలో వినిపించేది',
    'చిత్రకళలో ఉపయోగించేది',
    'ప్రకృతిలో కనిపించే అందం',
    'ప్రయాణానికి ఉపయోగించేది',
    'మనిషి నివసించే స్థలం',
    'సాహిత్యంలో ఒక ప్రక్రియ',
    'తెలుగులో ప్రసిద్ధమైన పండు',
    'చెట్టుకు ఉండేది',
    'వర్షంతో వచ్చేది',
    'సముద్రంలో కనిపించేది',
    'ఉదయాన్నే వినిపించేది',
    'జ్ఞాపకంగా మిగిలేది',
  ];

  final List<String> downClues = [
    'ఆకాశంలో కనిపించే వస్తువు',
    'చదువులో ఉపయోగించేది',
    'నీటికి సంబంధించినది',
    'మనసుకు సంబంధించిన భావం',
    'ప్రకృతిలో కనిపించేది',
    'వెలుగును ఇచ్చేది',
    'సంగీతానికి సంబంధించినది',
    'తెలుగు సాహిత్యంలో ఒక రూపం',
    'పండుగలో కనిపించేది',
    'ప్రయాణంలో ఉపయోగించేది',
    'మనిషి నివసించే ప్రదేశం',
    'చెట్టులో ఉండేది',
    'వర్షంతో వచ్చేది',
    'సముద్రంలో కనిపించేది',
    'పక్షి నివసించే ప్రదేశం',
    'పూలతో ఉండేది',
    'జ్ఞానానికి సంబంధించినది',
    'పాతకాలానికి చెందినది',
    'ఉదయానికి సంబంధించినది',
    'రాత్రిలో కనిపించేది',
    'కళకు సంబంధించినది',
    'సంగీతంలో ఒక భాగం',
    'ప్రకృతిలో ఒక దృశ్యం',
    'మనిషి భావోద్వేగం',
    'తెలుగు సంస్కృతికి సంబంధించినది',
    'జ్ఞాపకంగా మిగిలేది',
  ];

  @override
  void initState() {
    super.initState();

    for (int r = 0; r < grid.length; r++) {
      for (int c = 0; c < grid[r].length; c++) {
        if (grid[r][c]) {
          final key = '$r-$c';

          controllers[key] = TextEditingController();
          focusNodes[key] = FocusNode();

          focusNodes[key]!.addListener(() {
            if (focusNodes[key]!.hasFocus) {
              setState(() {
                selectedRow = r;
                selectedCol = c;
              });
            }
          });
        }
      }
    }
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

  bool isWhite(int r, int c) {
    return grid[r][c];
  }

  bool startsAcross(int r, int c) {
    if (!isWhite(r, c)) return false;

    final leftBlocked =
        c == 0 || !isWhite(r, c - 1);

    final hasRight =
        c + 1 < grid[r].length &&
        isWhite(r, c + 1);

    return leftBlocked && hasRight;
  }

  bool startsDown(int r, int c) {
    if (!isWhite(r, c)) return false;

    final topBlocked =
        r == 0 || !isWhite(r - 1, c);

    final hasBottom =
        r + 1 < grid.length &&
        isWhite(r + 1, c);

    return topBlocked && hasBottom;
  }

  bool hasAcross(int r, int c) {
    if (!isWhite(r, c)) return false;

    final left =
        c > 0 && isWhite(r, c - 1);

    final right =
        c + 1 < grid[r].length &&
        isWhite(r, c + 1);

    return left || right;
  }

  bool hasDown(int r, int c) {
    if (!isWhite(r, c)) return false;

    final top =
        r > 0 && isWhite(r - 1, c);

    final bottom =
        r + 1 < grid.length &&
        isWhite(r + 1, c);

    return top || bottom;
  }

  Map<String, int> generateNumbers() {
    final Map<String, int> numbers = {};

    int number = 1;

    for (int r = 0; r < grid.length; r++) {
      for (int c = 0; c < grid[r].length; c++) {
        if (isWhite(r, c) &&
            (startsAcross(r, c) ||
                startsDown(r, c))) {
          numbers['$r-$c'] = number;
          number++;
        }
      }
    }

    return numbers;
  }

  List<List<int>> getWordCells(
    int row,
    int col,
    String direction,
  ) {
    if (!isWhite(row, col)) return [];

    int r = row;
    int c = col;

    if (direction == 'A') {
      while (c > 0 && isWhite(r, c - 1)) {
        c--;
      }

      final cells = <List<int>>[];

      while (c < grid[r].length &&
          isWhite(r, c)) {
        cells.add([r, c]);
        c++;
      }

      return cells;
    }

    while (r > 0 && isWhite(r - 1, c)) {
      r--;
    }

    final cells = <List<int>>[];

    while (r < grid.length &&
        isWhite(r, c)) {
      cells.add([r, c]);
      r++;
    }

    return cells;
  }

  List<int> getWordStart(
    int row,
    int col,
    String direction,
  ) {
    int r = row;
    int c = col;

    if (direction == 'A') {
      while (c > 0 && isWhite(r, c - 1)) {
        c--;
      }
    } else {
      while (r > 0 && isWhite(r - 1, c)) {
        r--;
      }
    }

    return [r, c];
  }

  bool isSelectedCell(int r, int c) {
    if (selectedRow == null ||
        selectedCol == null) {
      return false;
    }

    final cells = getWordCells(
      selectedRow!,
      selectedCol!,
      selectedDirection,
    );

    return cells.any(
      (cell) =>
          cell[0] == r &&
          cell[1] == c,
    );
  }

  void selectCell(int r, int c) {
    if (!isWhite(r, c)) return;

    if (selectedRow == r &&
        selectedCol == c) {
      if (hasAcross(r, c) &&
          hasDown(r, c)) {
        setState(() {
          selectedDirection =
              selectedDirection == 'A'
                  ? 'D'
                  : 'A';
        });
      }
    } else {
      String direction = selectedDirection;

      if (direction == 'A' &&
          !hasAcross(r, c)) {
        direction = 'D';
      }

      if (direction == 'D' &&
          !hasDown(r, c)) {
        direction = 'A';
      }

      setState(() {
        selectedRow = r;
        selectedCol = c;
        selectedDirection = direction;
      });
    }

    final key = '$r-$c';

    FocusScope.of(context).requestFocus(
      focusNodes[key],
    );
  }

  int getSelectedNumber() {
    if (selectedRow == null ||
        selectedCol == null) {
      return 0;
    }

    final numbers = generateNumbers();

    final start = getWordStart(
      selectedRow!,
      selectedCol!,
      selectedDirection,
    );

    return numbers['${start[0]}-${start[1]}'] ?? 0;
  }

  int getSelectedLength() {
    if (selectedRow == null ||
        selectedCol == null) {
      return 0;
    }

    return getWordCells(
      selectedRow!,
      selectedCol!,
      selectedDirection,
    ).length;
  }

  Widget buildCell(
    int r,
    int c,
    Map<String, int> numbers,
  ) {
    if (!isWhite(r, c)) {
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

    final key = '$r-$c';

    final selected =
        isSelectedCell(r, c);

    final number = numbers[key];

    return GestureDetector(
      onTap: () => selectCell(r, c),
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFDCC8F4)
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
                left: 3,
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

            Positioned.fill(
              child: TextField(
                controller: controllers[key],
                focusNode: focusNodes[key],
                textAlign: TextAlign.center,
                textAlignVertical:
                    TextAlignVertical.center,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                cursorColor: Colors.deepPurple,
                decoration:
                    const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(
                    top: 5,
                  ),
                ),
                onTap: () {
                  selectCell(r, c);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildClueList(
    String title,
    String direction,
    List<String> clueTexts,
    Map<String, int> numbers,
  ) {
    int clueIndex = 0;

    final widgets = <Widget>[];

    for (int r = 0; r < grid.length; r++) {
      for (int c = 0;
          c < grid[r].length;
          c++) {
        final starts = direction == 'A'
            ? startsAcross(r, c)
            : startsDown(r, c);

        if (!starts) continue;

        if (clueIndex >= clueTexts.length) {
          continue;
        }

        final number =
            numbers['$r-$c']!;

        final length = getWordCells(
          r,
          c,
          direction,
        ).length;

        final selected =
            selectedRow != null &&
            selectedCol != null &&
            getSelectedNumber() ==
                number &&
            selectedDirection ==
                direction;

        widgets.add(
          GestureDetector(
            onTap: () {
              selectCell(r, c);
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                bottom: 8,
              ),
              padding:
                  const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(
                        0xFFE7D9F7,
                      )
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 35,
                    child: Text(
                      '$number.',
                      style:
                          const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      '${clueTexts[clueIndex]} '
                      '($length ${length == 1 ? 'అక్షరం' : 'అక్షరాలు'})',
                      style:
                          const TextStyle(
                        fontSize: 17,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        clueIndex++;
      }
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        ...widgets,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final numbers = generateNumbers();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:
            const Color(0xFFEFE4F5),
        title: const Text(
          'పద గమనం',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 16),

          const Text(
            'తెలుగు పద పజిల్',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'స్కోర్: 0',
            style: TextStyle(
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 14),

          // FIXED GRID
          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount:
                    grid.length *
                        grid[0].length,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      grid[0].length,
                ),
                itemBuilder:
                    (context, index) {
                  final r =
                      index ~/ grid[0].length;
                  final c =
                      index % grid[0].length;

                  return buildCell(
                    r,
                    c,
                    numbers,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          // SELECTED WORD INFO
          if (selectedRow != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                '${getSelectedNumber()}. '
                '${selectedDirection == 'A' ? 'అడ్డంగా' : 'నిలువుగా'}'
                ' • ${getSelectedLength()} అక్షరాలు',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            ),

          const SizedBox(height: 4),

          // ONLY CLUES SCROLL
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                30,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  buildClueList(
                    'అడ్డంగా',
                    'A',
                    acrossClues,
                    numbers,
                  ),

                  const SizedBox(height: 22),

                  buildClueList(
                    'నిలువుగా',
                    'D',
                    downClues,
                    numbers,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'సమాధానాలు పరిశీలిస్తున్నాం...',
                            ),
                          ),
                        );
                      },
                      child: const Text(
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
