import 'package:flutter/material.dart';
import 'sizes.dart';

void main() {
  runApp(const VangtiChaiApp());
}

class VangtiChaiApp extends StatelessWidget {
  const VangtiChaiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String amount = '0';

  void addDigit(String digit) {
    setState(() {
      if (amount == '0') {
        amount = digit;
      } else if (amount.length < 10) {
        amount = amount + digit;
      }
    });
  }

  void clearAll() {
    setState(() {
      amount = '0';
    });
  }

  Map<int, int> getChange(int total) {
    List<int> notes = [500, 100, 50, 20, 10, 5, 2, 1];
    Map<int, int> result = {};
    for (int note in notes) {
      result[note] = total ~/ note;
      total = total % note;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VangtiChai'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > constraints.maxHeight) {
            return landscapeView();
          } else {
            return portraitView();
          }
        },
      ),
    );
  }

  Widget portraitView() {
    int total = int.tryParse(amount) ?? 0;
    Map<int, int> change = getChange(total);

    return Column(
      children: [
        amountDisplay(),
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 2, child: noteList(change)),
              Expanded(flex: 3, child: keypad()),
            ],
          ),
        ),
      ],
    );
  }

  Widget landscapeView() {
    int total = int.tryParse(amount) ?? 0;
    Map<int, int> change = getChange(total);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              amountDisplay(),
              Expanded(child: noteList(change)),
            ],
          ),
        ),
        Expanded(flex: 2, child: keypad()),
      ],
    );
  }

  Widget amountDisplay() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Taka: ',
            style: TextStyle(fontSize: AppSizes.textHeader),
          ),
          Flexible(
            child: Text(
              amount,
              style: TextStyle(
                fontSize: AppSizes.textDisplay,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget noteList(Map<int, int> change) {
    List<int> notes = [500, 100, 50, 20, 10, 5, 2, 1];

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: notes.map((note) {
          int count = change[note] ?? 0;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$note:',
                style: TextStyle(fontSize: AppSizes.textTableCell),
              ),
              Text(
                '$count',
                style: TextStyle(fontSize: AppSizes.textTableCell),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget keypad() {
    List<List<String>> rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['0', 'CLEAR'],
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingSmall),
      child: Column(
        children: rows.map((row) {
          return Expanded(
            child: Row(
              children: row.map((key) => keyButton(key)).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget keyButton(String label) {
    bool isClear = label == 'CLEAR';

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingSmall),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isClear ? Colors.teal : Colors.white,
            foregroundColor: isClear ? Colors.white : Colors.black,
            minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          ),
          onPressed: () {
            if (isClear) {
              clearAll();
            } else {
              addDigit(label);
            }
          },
          child: Text(
            label,
            style: TextStyle(fontSize: isClear ? AppSizes.textTableCell : AppSizes.textKeypad),
          ),
        ),
      ),
    );
  }
}