import 'package:fitness/theme/theme.dart';
import 'package:fitness/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ToolDetailsPage extends StatefulWidget {
  final int toolId;

  const ToolDetailsPage({Key? key, required this.toolId}) : super(key: key);

  @override
  _ToolDetailsPageState createState() => _ToolDetailsPageState();
}

class _ToolDetailsPageState extends State<ToolDetailsPage> {
  Map<String, dynamic>? toolDetails;
  bool isLoading = true;
  int? selectedGradeId; // To store the selected grade ID
  Map<String, TextEditingController> inputControllers =
      {}; // To store input field values
  bool isGenerating = false;

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

        // Initialize controllers for dynamic input fields
        var inputTypes = json.decode(toolDetails!['tool']['input_types']);
        for (var i = 0; i < inputTypes.length; i++) {
          inputControllers['input_$i'] = TextEditingController();
        }
      });
    } else {
      throw Exception('Failed to load tool details');
    }
  }

  Future<void> generateContent() async {
    setState(() {
      isLoading = true;
    });

    // Prepare the request body
    Map<String, dynamic> requestBody = {
      'tool_id': widget.toolId,
      'grade_id': selectedGradeId,
    };

    // Add dynamic input fields to the request body
    inputControllers.forEach((key, controller) {
      requestBody[key] = controller.text;
    });

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    print('Token retrieved: $token');
    // Send the request to the API
    final response = await http.post(
      Uri.parse('http://192.168.0.106:8000/api/tools/generate-content'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add your token here
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      var responseData = json.decode(response.body);
      // Handle the response (e.g., display the generated content)
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Generated Content'),
              content: Text(responseData['content']),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to generate content');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(flex: 1, child: SizedBox(height: 10)),
          Expanded(
            flex: 50,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      toolDetails!['tool']['name'],
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                        color: lightColorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    // Grade/Class Select Field
                    DropdownButtonFormField(
                      items:
                          toolDetails!['classes'].map<DropdownMenuItem>((
                            classItem,
                          ) {
                            return DropdownMenuItem(
                              value: classItem['id'],
                              child: Text(classItem['grade']),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGradeId = value as int?;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Grade/Class',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.school),
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                if (inputType == 'textarea')
                                  TextFormField(
                                    controller:
                                        inputControllers['input_$index'],
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      hintText:
                                          json.decode(
                                            toolDetails!['tool']['input_placeholders'],
                                          )[index],
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.black12,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      prefixIcon: const Icon(Icons.edit),
                                    ),
                                  )
                                else
                                  TextFormField(
                                    controller:
                                        inputControllers['input_$index'],
                                    decoration: InputDecoration(
                                      hintText:
                                          json.decode(
                                            toolDetails!['tool']['input_placeholders'],
                                          )[index],
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.black12,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      prefixIcon: const Icon(Icons.text_fields),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        })
                        .toList(),
                    const SizedBox(height: 20.0),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child:
                          isGenerating
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                onPressed: generateContent,
                                child: const Text('Generate'),
                              ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers to avoid memory leaks
    inputControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }
}
