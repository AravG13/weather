import 'dart:convert';

import 'package:english_words/english_words.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'globals.dart' as globali;
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 112, 160, 195)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  List<dynamic> weathers = [];
  var city = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = SecondPage();
        break;
      case 2:
        page = ThirdPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      body: Row(
        children: [
          Center(
              child: Container(
                  width: 300,
                  child: Column(
                    children: [
                      TextField(
                        controller: city,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            globali.citys = city.text.toString();
                            print(globali.citys);
                          },
                          child: Text('Set location'))
                    ],
                  ))),
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.add_location),
                  label: Text('Page 2'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.access_time),
                  label: Text('Page 3'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: fetchWeather),
    );
  }

  dynamic fetchWeather() async {
    var url = 'https://api.openweathermap.org/data/2.5/weather?q=' +
        globali.citys +
        ',india&appid=6191f13a4ef82702eb2ea9451aa20b03&units=metric';
    print(url);
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    var body = response.body;
    var json = jsonDecode(body);

    setState(() {
      json.entries.map((e) => weathers.add({e.key: e.value})).toList();
      print(weathers);
    });
    print('fetchWeather completed');
    var weat = weathers[3];
    print(weat);
    var tempi = weat['main'];
    var tempe = tempi['temp'];
    var feels = tempi['feels_like'];
    var min = tempi['temp_min'];
    var max = tempi['temp_max'];
    var namei = weathers[11];
    print(namei);
    var namo = namei['name'];
    print(namo);

    globali.t = tempe.toString();
    globali.fl = feels.toString();
    globali.tmin = min.toString();
    globali.tmax = max.toString();
    globali.name = namo;
    print(globali.t);
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(appState: appState),
          SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Temp:'),
            ),
          ),
          SizedBox(height: 5),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(globali.t),
            ),
          ),
          SizedBox(height: 5),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Feels like: '),
            ),
          ),
          SizedBox(height: 5),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(globali.fl),
            ),
          ),
          SizedBox(height: 5),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Max: '),
            ),
          ),
          SizedBox(height: 5),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(globali.tmax),
            ),
          ),
          SizedBox(height: 5),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Min'),
            ),
          ),
          SizedBox(height: 5),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(globali.tmin),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Vidyavihar          39°C'),
              ),
            ),
            SizedBox(height: 5),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Delhi               37°C'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Weather Forecast for Next 5 days'),
              ),
            ),
            SizedBox(height: 5),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('37°C\n\n36°C\n\n38°C\n\n35°C\n\n35°C'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = globali.name;
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(globali.name, style: style),
      ),
    );
  }
}
