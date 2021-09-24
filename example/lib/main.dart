import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shareapks/shareapk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

void showClientList() async {}

class MyProvider with ChangeNotifier, DiagnosticableTreeMixin {
  var _iptext = "";

  TextEditingController textcontroller;

  MyProvider(this.textcontroller);

  get iptext => _iptext;
  var _loading = false;

  get loading => _loading;

  set loading(value) {
    _loading = value;
    print("------------->$value");
    notifyListeners();
  }

  set iptext(value) {
    print("---------------------->" + value);
    _iptext = value;

    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  var type;

  var internal;

  var external;

  MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dart Http Web server',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "Host Static and Api"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [Share()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  var i = true;
}
