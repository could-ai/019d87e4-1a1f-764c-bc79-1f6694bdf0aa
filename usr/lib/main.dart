import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const TrainRouteOptimizerApp());
}

class TrainRouteOptimizerApp extends StatelessWidget {
  const TrainRouteOptimizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Train Route Optimizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E88E5), // Blue header
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          primary: const Color(0xFF1E88E5),
          secondary: const Color(0xFF43A047), // Green button
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF43A047),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E88E5),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// --- Background Widget ---
class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}

// --- Login Screen ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login() {
    if (_usernameController.text == 'admin' && _passwordController.text == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🚆 Train System Login')),
      body: GradientBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.train, size: 64, color: Color(0xFF1E88E5)),
                    const SizedBox(height: 16),
                    const Text(
                      'Admin Login',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    if (_errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        child: const Text('LOGIN'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Dashboard Screen ---
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🚆 Dashboard')),
      body: GradientBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Train System',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                icon: const Icon(Icons.map),
                label: const Text('Find Route'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RouteFinderScreen()),
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Exit'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Route Finder Screen ---
class RouteFinderScreen extends StatefulWidget {
  const RouteFinderScreen({super.key});

  @override
  State<RouteFinderScreen> createState() => _RouteFinderScreenState();
}

class _RouteFinderScreenState extends State<RouteFinderScreen> {
  final List<String> stations = ['Pune', 'Mumbai', 'Nashik', 'Nagpur', 'Delhi'];
  String? sourceStation;
  String? destStation;
  
  bool isLoading = false;
  String resultText = '';
  List<dynamic> trainDetails = [];

  final Graph graph = Graph();

  @override
  void initState() {
    super.initState();
    // Initialize Graph
    graph.addEdge('Pune', 'Mumbai', 150, 3.0);
    graph.addEdge('Mumbai', 'Nashik', 170, 3.5);
    graph.addEdge('Nashik', 'Nagpur', 700, 12.0);
    graph.addEdge('Nagpur', 'Delhi', 1100, 18.0);
    graph.addEdge('Pune', 'Nashik', 210, 4.5);
    graph.addEdge('Mumbai', 'Delhi', 1400, 24.0);
    graph.addEdge('Pune', 'Nagpur', 710, 14.0);
  }

  Future<void> _findRoute() async {
    if (sourceStation == null || destStation == null) {
      setState(() {
        resultText = 'Please select both source and destination.';
        trainDetails = [];
      });
      return;
    }

    if (sourceStation == destStation) {
      setState(() {
        resultText = 'Source and destination cannot be the same.';
        trainDetails = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
      resultText = 'Fetching data...';
      trainDetails = [];
    });

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Dijkstra's Algorithm
    var result = graph.findShortestPath(sourceStation!, destStation!);

    // Mock API Call for train details
    var mockApiResponse = await _fetchTrainDetails(sourceStation!, destStation!);

    setState(() {
      isLoading = false;
      if (result['path'].isEmpty) {
        resultText = 'No route found between $sourceStation and $destStation.';
      } else {
        String pathStr = result['path'].join(' ➔ ');
        resultText = \'\'\'
🛤️ Shortest Path: $pathStr
📏 Total Distance: ${result['distance']} km
⏱️ Estimated Time: ${result['time']} hours
\'\'\';
        trainDetails = mockApiResponse;
      }
    });
  }

  Future<List<dynamic>> _fetchTrainDetails(String source, String dest) async {
    // Mock JSON API response
    String jsonString = \'\'\'
    [
      {"trainName": "Express 101", "departure": "10:00 AM", "status": "On Time"},
      {"trainName": "Superfast 202", "departure": "02:30 PM", "status": "Delayed"}
    ]
    \'\'\';
    return jsonDecode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🚆 Route Finder')),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Source Station', border: OutlineInputBorder()),
                        value: sourceStation,
                        items: stations.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (val) => setState(() => sourceStation = val),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Destination Station', border: OutlineInputBorder()),
                        value: destStation,
                        items: stations.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (val) => setState(() => destStation = val),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.search),
                          label: const Text('Find Route'),
                          onPressed: isLoading ? null : _findRoute,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Route Results:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const Divider(),
                                const SizedBox(height: 8),
                                Text(
                                  resultText,
                                  style: const TextStyle(fontSize: 16, height: 1.5),
                                ),
                                if (trainDetails.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  const Text('Available Trains:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  ...trainDetails.map((train) => ListTile(
                                    leading: const Icon(Icons.train, color: Colors.blue),
                                    title: Text(train['trainName']),
                                    subtitle: Text('Departure: ${train['departure']}'),
                                    trailing: Text(
                                      train['status'],
                                      style: TextStyle(
                                        color: train['status'] == 'On Time' ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                                ]
                              ],
                            ),
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

// --- Algorithm Logic ---

class Edge {
  final String destination;
  final int distance;
  final double time;

  Edge(this.destination, this.distance, this.time);
}

class Graph {
  final Map<String, List<Edge>> adjList = {};

  void addEdge(String source, String destination, int distance, double time) {
    adjList.putIfAbsent(source, () => []).add(Edge(destination, distance, time));
    adjList.putIfAbsent(destination, () => []).add(Edge(source, distance, time)); // Undirected graph
  }

  Map<String, dynamic> findShortestPath(String start, String end) {
    if (start == end) {
      return {'path': [start], 'distance': 0, 'time': 0.0};
    }

    var distances = <String, int>{};
    var times = <String, double>{};
    var previous = <String, String>{};
    
    // Simple priority queue using a list and sorting
    var pq = <MapEntry<String, int>>[];

    for (var node in adjList.keys) {
      distances[node] = 999999;
      times[node] = 999999.0;
    }

    distances[start] = 0;
    times[start] = 0.0;
    pq.add(MapEntry(start, 0));

    while (pq.isNotEmpty) {
      pq.sort((a, b) => a.value.compareTo(b.value));
      var current = pq.removeAt(0).key;

      if (current == end) break;

      for (var edge in adjList[current] ?? <Edge>[]) {
        var newDist = distances[current]! + edge.distance;
        if (newDist < distances[edge.destination]!) {
          distances[edge.destination] = newDist;
          times[edge.destination] = times[current]! + edge.time;
          previous[edge.destination] = current;
          
          // Update or add to PQ
          pq.removeWhere((entry) => entry.key == edge.destination);
          pq.add(MapEntry(edge.destination, newDist));
        }
      }
    }

    if (!previous.containsKey(end)) {
      return {'path': [], 'distance': 0, 'time': 0.0};
    }

    List<String> path = [];
    String? curr = end;
    while (curr != null) {
      path.insert(0, curr);
      curr = previous[curr];
    }

    return {
      'path': path,
      'distance': distances[end],
      'time': times[end],
    };
  }
}
