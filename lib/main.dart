import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FixedCostProvider(),
      child: MaterialApp(
        title: '固定費計算アプリ',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          primarySwatch: Colors.blue,
        ),
        home: FixedCostListScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class FixedCost {
  String name;
  int amount;

  FixedCost({required this.name, required this.amount});

  factory FixedCost.fromJson(Map<String, dynamic> json) {
    return FixedCost(name: json['name'] ?? '', amount: json['amount'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}

class FixedCostProvider extends ChangeNotifier {
  late SharedPreferences _preferences;
  List<FixedCost> _fixedCosts = [];
  List<FixedCost> get fixCosts => _fixedCosts;

  FixedCostProvider() {
    _loadFromPreferences();
  }

  Future<void> _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> _loadFromPreferences() async {
    await _initPreferences();
    final String? fixedCostsJson = _preferences.getString('fixedCosts');
    if (fixedCostsJson != null) {
      final List<dynamic> decoded = jsonDecode(fixedCostsJson);
      _fixedCosts = decoded.map((e) => FixedCost.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveToPreferences() async {
    await _initPreferences();
    final encoded = jsonEncode(_fixedCosts);
    await _preferences.setString('fixedCosts', encoded);
  }

  void addFixedCost(FixedCost fixedCost) {
    _fixedCosts.add(fixedCost);
    _saveToPreferences();
    notifyListeners();
  }

  void removeFixedCost(FixedCost fixedCost) {
    _fixedCosts.remove(fixedCost);
    _saveToPreferences();
    notifyListeners();
  }

  void updateFixedCost(FixedCost oldFixedCost, FixedCost newFixedCost) {
    final index = _fixedCosts.indexOf(oldFixedCost);
    if (index != -1) {
      _fixedCosts[index] = newFixedCost;
      _saveToPreferences();
      notifyListeners();
    }
  }

  void reorderFixedCosts(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final FixedCost item = _fixedCosts.removeAt(oldIndex);
    _fixedCosts.insert(newIndex, item);
    notifyListeners();
  }

  int getTotalFixedCost() {
    int total = 0;
    for (var cost in _fixedCosts) {
      total += cost.amount;
    }
    return total;
  }
}

class FixedCostListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('固定費リスト'),
      ),
      body: Consumer<FixedCostProvider>(builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  provider.reorderFixedCosts(oldIndex, newIndex);
                },
                children: [
                  for (int index = 0; index < provider.fixCosts.length; index++)
                    ListTile(
                      key: Key('$index'),
                      title: Text(provider.fixCosts[index].name),
                      subtitle: Text('${provider.fixCosts[index].amount}円}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditFixedCostScreen(
                                    fixedCost: provider.fixCosts[index]),
                              ));
                              //provider.removeFixedCost(fixedCost);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              provider.removeFixedCost(provider.fixCosts[index]);
                            },
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '合計金額:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${provider.getTotalFixedCost()}円',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddFixedCostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
    );
  }
}

class EditFixedCostScreen extends StatefulWidget {
  final FixedCost fixedCost;

  EditFixedCostScreen({required this.fixedCost});

  @override
  _EditFixedCostScreenState createState() => _EditFixedCostScreenState();
}

class _EditFixedCostScreenState extends State<EditFixedCostScreen> {
  late TextEditingController _nameController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fixedCost.name);
    _amountController =
        TextEditingController(text: widget.fixedCost.amount.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('固定費を編集'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '固定費の名称'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: '金額'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final amount = int.tryParse(_amountController.text) ?? 0;

                if (name.isNotEmpty && amount > 0) {
                  final newFixedCost = FixedCost(name: name, amount: amount);
                  Provider.of<FixedCostProvider>(context, listen: false)
                      .updateFixedCost(widget.fixedCost, newFixedCost);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddFixedCostScreen extends StatefulWidget {
  const AddFixedCostScreen({super.key});
  @override
  _AddFixedCostScreenState createState() => _AddFixedCostScreenState();
}

class _AddFixedCostScreenState extends State<AddFixedCostScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('固定費を追加'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '固定費の名称'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: '金額'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final amount = int.tryParse(_amountController.text) ?? 0;

                if (name.isNotEmpty && amount > 0) {
                  final fixedCost = FixedCost(name: name, amount: amount);
                  Provider.of<FixedCostProvider>(context, listen: false)
                      .addFixedCost(fixedCost);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('追加'),
            ),
          ],
        ),
      ),
    );
  }
}
