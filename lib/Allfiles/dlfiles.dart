//Access Overview page
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dlplatforms_task/Services/NetworkService.dart';
class AccessFileController extends GetxController {
  var selectedTab = 'All'.obs;
  var folders = <String>[].obs;
  var files = <String>[].obs;
  var isLoading = true.obs; 

  final NetworkService networkService = NetworkService(); // Instance of NetworkService

  // Fetch files and folders from the API
  Future<void> fetchFilesAndFolders() async {
    try {
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
    } finally {
      isLoading.value = false; 
    }
  }

  // Clear files and folders when tab changes
  void onTabChanged(String tab) {
    selectedTab.value = tab;
    isLoading.value = true; 
    fetchFilesAndFolders(); 
  }
}

class AccessFileScreen extends StatelessWidget {
  final AccessFileController controller = Get.put(AccessFileController());

  @override
  Widget build(BuildContext context) {
    // Fetch the files and folders when the screen is initialized
    if (controller.isLoading.value) {
      controller.fetchFilesAndFolders();
    }

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
            // Tab Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: ['All', 'Folders', 'Files'].map((tab) {
                return Obx(() => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () => controller.onTabChanged(tab), // Change tab on tap
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
            // Loading Indicator for All content
            Obx(() => controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : _buildTabContent()), // Show content or loading spinner based on isLoading state
          ],
        ),
      ),
    );
  }

  // Build the content for the selected tab (All, Folders, Files)
  Widget _buildTabContent() {
    switch (controller.selectedTab.value) {
      case 'Folders':
        return _buildFolderList(controller.folders);
      case 'Files':
        return _buildFileList(controller.files);
      default:
        return Column(
          children: [
            _buildFolderList(controller.folders),
            SizedBox(height: 20),
            _buildFileList(controller.files),
          ],
        );
    }
  }

  // Folders Section
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

  // Files Section
  Widget _buildFileList(List<String> files) {
    return ListView.builder(
      shrinkWrap: true, // Makes the ListView take only the required space
      physics: NeverScrollableScrollPhysics(), // Prevents scrolling if the parent has its own scroll
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
