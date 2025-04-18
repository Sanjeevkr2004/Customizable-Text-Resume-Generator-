// ignore_for_file: unused_field, unused_local_variable

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:logging/logging.dart';

void main() {
  _setupLogging(); // Initialize logging
  // Pass a real HTTP client to ResumeApp
  runApp(ResumeApp(client: http.Client()));
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // Log format: INFO: 2025-04-18 12:00:00.000: Your message
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class ResumeApp extends StatelessWidget {
  final http.Client client;

  const ResumeApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResumeHomePage(client: client),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ResumeHomePage extends StatefulWidget {
  final http.Client client;

  const ResumeHomePage({super.key, required this.client});

  @override
  ResumeHomePageState createState() => ResumeHomePageState();
}

class ResumeHomePageState extends State<ResumeHomePage> {
  final _logger = Logger('ResumeHomePageState');
  String resumeText = "Fetching resume...";
  double fontSize = 16.0;
  Color fontColor = Colors.black;
  Color backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    fetchResume("Sanjeev Kumar Singh");
  }

  Future<void> fetchResume(String name) async {
    final encodedName = Uri.encodeComponent(name);
    final url = Uri.parse(
      "https://api.allorigins.win/raw?url=https://expressjs-api-resume-random.onrender.com/resume?name=$encodedName"
    );

    try {
      final response = await widget.client.get(url);
      print("Fetching resume from: $url");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String name = data['name'] ?? '';
        final String phone = data['phone'] ?? '';
        final String email = data['email'] ?? '';
        final String twitter = data['twitter'] ?? '';
        final String address = data['address'] ?? '';
        final String summary = data['summary'] ?? '';
        final List skills = List.from(data['skills'] ?? []);
        final List projects = List.from(data['projects'] ?? []);

        setState(() {
          resumeText = '''
Name: $name
Phone: $phone
Email: $email
Twitter: $twitter
Address: $address

Summary:
$summary

Skills:
${skills.join(', ')}

Projects:
${projects.map((project) => '''
Title: ${project['title']}
Description: ${project['description']}
Start Date: ${project['startDate']}
End Date: ${project['endDate']}
''').join('\n')}

''';
        });
      } else {
        print("Error fetching data: ${response.statusCode}");
        setState(() {
          resumeText = "Failed to fetch resume.";
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        resumeText = "Error: $e";
      });
    }
  }

  void pickColor(bool isFontColor) async {
    Color tempColor = isFontColor ? fontColor : backgroundColor;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Pick a ${isFontColor ? 'Font' : 'Background'} Color"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: tempColor,
            onColorChanged: (color) {
              tempColor = color;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                if (isFontColor) {
                  fontColor = tempColor;
                } else {
                  backgroundColor = tempColor;
                }
              });
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customizable Resume')),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: backgroundColor,
        child: Column(
          children: [
            Row(
              children: [
                const Text("Font Size:"),
                Expanded(
                  child: Slider(
                    key: const Key('fontSizeSlider'),
                    min: 10,
                    max: 30,
                    value: fontSize,
                    onChanged: (val) {
                      setState(() {
                        fontSize = val;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  key: const Key('fontColorButton'),
                  onPressed: () => pickColor(true),
                  child: const Text("Font Color"),
                ),
                ElevatedButton(
                  key: const Key('backgroundColorButton'),
                  onPressed: () => pickColor(false),
                  child: const Text("Background Color"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: resumeText == "Fetching resume..."
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Text(
                        resumeText,
                        key: const Key('resumeText'),
                        style: TextStyle(fontSize: fontSize, color: fontColor),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
