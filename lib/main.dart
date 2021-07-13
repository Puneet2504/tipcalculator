import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

var _formkey = GlobalKey<FormState>();
final controller = TextEditingController();
double billAmount = 0;
double tip = 0;

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text('TIP CALCULATOR'),
              backgroundColor: Colors.teal[600],
            ),
            body: Form(
                key: _formkey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 40)),
                          SizedBox(height: 72),
                          Text(
                            'Enter Bill Amount',
                            style: TextStyle(
                                fontSize: 35, color: Colors.cyan[900]),
                          ),
                          SizedBox(height: 32),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter a number';
                              }
                            },
                            onChanged: (a) {
                              setState(() {
                                billAmount = double.parse(a);
                              });
                            },
                            controller: controller,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.teal)),
                                labelText: 'Bill Amount'),
                          ),
                          SizedBox(height: 32),
                          SliderTheme(
                              data: SliderThemeData(
                                activeTrackColor: Colors.teal,
                                inactiveTrackColor: Colors.teal[200],
                                thumbColor: Colors.teal,
                                valueIndicatorColor: Colors.teal,
                              ),
                              child: Slider(
                                  value: tip,
                                  min: 0,
                                  max: 10,
                                  divisions: 10,
                                  label: tip.round().toString(),
                                  onChanged: (value) {
                                    setState(() {
                                      tip = value;
                                    });
                                  })),
                          SizedBox(height: 32),
                          Text(
                            '$tip%',
                            style: TextStyle(
                                fontSize: 40, color: Colors.cyan[900]),
                          ),
                          SizedBox(height: 32),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.teal,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_formkey.currentState!.validate()) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NextPage(
                                      amount: (billAmount * tip) / 100,
                                      title: billAmount,
                                    ),
                                  ));
                                }
                              });
                            },
                            child: Text(
                              'Calculate',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))));
  }
}

class NextPage extends StatefulWidget {
  const NextPage({
    Key? key,
    required this.amount,
    required this.title,
  }) : super(key: key);
  final double title;
  final double amount;
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2500),
  );
  late final Animation<double> _anmation;
  late final Animation<double> _aniation;
  @override
  void initState() {
    super.initState();
    _anmation = Tween<double>(begin: 0, end: widget.title).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _aniation = Tween<double>(begin: 0, end: widget.amount).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: Text('TIP CALCULATOR'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: ValueListenableBuilder<double>(
                valueListenable: _anmation,
                builder: (context, title, child) {
                  return Text(
                    'Your Bill Amount is \$$title',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.cyan[600], fontSize: 30),
                  );
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ValueListenableBuilder<double>(
              valueListenable: _aniation,
              builder: (context, value, child) {
                return Text(
                  'Your Tip Amount is \$$value',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.cyan[600], fontSize: 30),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
