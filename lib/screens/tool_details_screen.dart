import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ToolDetailsPage extends StatefulWidget {
  final int toolId;

  const ToolDetailsPage({Key? key, required this.toolId}) : super(key: key);

  @override
  _ToolDetailsPageState createState() => _ToolDetailsPageState();
}

class _ToolDetailsPageState extends State<ToolDetailsPage> {
  Map<String, dynamic>? toolDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchToolDetails();
  }

  Future<void> fetchToolDetails() async {
    final response = await http.get(
      Uri.parse(
        'http://192.168.0.106:8000/api/tool/${widget.toolId}/slug',
      ), // Replace with your API endpoint
    );

    if (response.statusCode == 200) {
      setState(() {
        toolDetails = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load tool details');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(toolDetails!['tool']['name'])),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Grade/Class Select Field
            DropdownButtonFormField(
              items:
                  toolDetails!['classes'].map<DropdownMenuItem>((classItem) {
                    return DropdownMenuItem(
                      value: classItem['id'],
                      child: Text(classItem['grade']),
                    );
                  }).toList(),
              onChanged: (value) {
                // Handle grade/class selection
              },
              decoration: InputDecoration(labelText: 'Select Grade/Class'),
            ),
            SizedBox(height: 20),
            // Dynamic Input Fields
            ...json
                .decode(toolDetails!['tool']['input_types'])
                .asMap()
                .entries
                .map((entry) {
                  int index = entry.key;
                  String inputType = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          json.decode(
                            toolDetails!['tool']['input_labels'],
                          )[index],
                        ),
                        if (inputType == 'textarea')
                          TextField(
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText:
                                  json.decode(
                                    toolDetails!['tool']['input_placeholders'],
                                  )[index],
                            ),
                          )
                        else
                          TextField(
                            decoration: InputDecoration(
                              hintText:
                                  json.decode(
                                    toolDetails!['tool']['input_placeholders'],
                                  )[index],
                            ),
                          ),
                      ],
                    ),
                  );
                })
                .toList(),
            SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
              onPressed: () {
                // Handle form submission
              },
              child: Text('Generate'),
            ),
          ],
        ),
      ),
    );
  }
}
