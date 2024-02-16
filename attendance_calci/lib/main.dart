import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance_calci',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'home_page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences _prefs;
  late String userName;
  late String semester;
  late String selectedDept;
  bool detailsEntered = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    _prefs = await SharedPreferences.getInstance();
    userName = _prefs.getString('userName') ?? '';
    semester = _prefs.getString('semester') ?? '';
    selectedDept = _prefs.getString('selectedDept') ?? '';

    // Check if details are entered
    if (userName.isNotEmpty && semester.isNotEmpty && selectedDept.isNotEmpty) {
      setState(() {
        detailsEntered = true;
      });
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserData() async {
    await _prefs.setString('userName', userName);
    await _prefs.setString('semester', semester);
    await _prefs.setString('selectedDept', selectedDept);

    setState(() {
      detailsEntered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(child: Text('Attendance Monitor')),
      ),
      body: Center(
        child: detailsEntered
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Display content for when details are entered
                  Text('Welcome, $userName!'),
                  Text('Semester: $semester'),
                  Text('Department: $selectedDept'),
                  // Add more widgets as needed
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Ask user to enter details for the first time
                  TextField(
                    onChanged: (value) {
                      userName = value;
                    },
                    decoration: InputDecoration(labelText: 'Enter Name'),
                  ),
                  TextField(
                    onChanged: (value) {
                      semester = value;
                    },
                    decoration: InputDecoration(labelText: 'Enter Semester'),
                  ),
                  DropdownButton<String>(
                    value: selectedDept,
                    onChanged: (value) {
                      setState(() {
                        selectedDept = value!;
                      });
                    },
                    items: ['Dept1', 'Dept2', 'Dept3']
                        .map((dept) => DropdownMenuItem<String>(
                              value: dept,
                              child: Text(dept),
                            ))
                        .toList(),
                    hint: Text('Select Department'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _saveUserData();
                    },
                    child: Text('Save Details'),
                  ),
                ],
              ),
      ),
    );
  }
}
