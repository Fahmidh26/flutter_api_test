import 'package:fitness/services/tools_details_service.dart' as toolsService;
import 'package:flutter/material.dart';
import 'package:fitness/services/education_tools_service.dart'
    as educationService;

class ToolDetailsPage extends StatelessWidget {
  final int toolId;

  ToolDetailsPage({required this.toolId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: toolsService.ApiService.fetchToolDetails(toolId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return Center(child: Text("No data found"));
        } else {
          final tool = snapshot.data!['tool'];

          return Scaffold(
            appBar: AppBar(title: Text(tool['name'])),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tool['description']),
                  SizedBox(height: 16),
                  // Display additional data if needed
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
