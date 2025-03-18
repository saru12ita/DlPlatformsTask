//Access Overview page

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dlplatforms_task/Services/NetworkService.dart';

class AccessFileController extends GetxController {
  var selectedTab = 'All'.obs;
  var folders = <String>[].obs;
  var files = <String>[].obs;

  // Fetch files and folders from the API
  Future<void> fetchFilesAndFolders() async {
    try {
      final networkService = NetworkService();
      final data = await networkService.getFilesAndFolders(); // Fetch files and folders

      if (data['status'] == 'success') {
        folders.value = List<String>.from(data['data']['folders'] ?? []);
        files.value = List<String>.from(data['data']['files'] ?? []);
      } else {
        Get.snackbar('Error', data['message'], snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error fetching files and folders: $e');
      Get.snackbar('Error', 'Failed to fetch files and folders', snackPosition: SnackPosition.BOTTOM);
    }
  }
}

class AccessFileScreen extends StatelessWidget {
  final AccessFileController controller = Get.put(AccessFileController());

  @override
  Widget build(BuildContext context) {
    // Fetch the files and folders when the screen is initialized
    controller.fetchFilesAndFolders();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Files Overview', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: ['All', 'Folders', 'Files'].map((tab) {
                return Obx(() => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () => controller.selectedTab.value = tab,
                        child: Text(
                          tab,
                          style: TextStyle(
                            color: controller.selectedTab.value == tab
                                ? Colors.blue
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ));
              }).toList(),
            ),
            SizedBox(height: 20),
            // Folders Section
            Text('Folders', style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 10),
            Obx(() => controller.folders.isEmpty
                ? CircularProgressIndicator() // Show loading indicator until data is fetched
                : _buildFolderList(controller.folders)),
            SizedBox(height: 20),
            // Files Section
            Text('Files', style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 10),
            Obx(() => controller.files.isEmpty
                ? CircularProgressIndicator() // Show loading indicator until data is fetched
                : Expanded(child: _buildFileList(controller.files))),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderList(List<String> folders) {
    return Column(
      children: folders
          .map((folder) => ListTile(
                leading: Icon(Icons.folder, color: Colors.blue),
                title: Text(folder, style: TextStyle(color: Colors.white)),
                trailing: Icon(Icons.more_vert, color: Colors.white),
              ))
          .toList(),
    );
  }

  Widget _buildFileList(List<String> files) {
    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.grey[900],
          child: ListTile(
            leading: Icon(Icons.insert_drive_file, color: Colors.grey),
            title: Text(files[index], style: TextStyle(color: Colors.white)),
            subtitle: Text('378 KB\n30 mins ago',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            trailing: Icon(Icons.more_vert, color: Colors.white),
          ),
        );
      },
    );
  }
}
