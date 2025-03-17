//Access Overview page
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccessFileController extends GetxController {
  var selectedTab = 'All'.obs;
}

class AccessFileScreen extends StatelessWidget {
  final AccessFileController controller = Get.put(AccessFileController());

  @override
  Widget build(BuildContext context) {
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
            Text('Folders', style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 10),
            _buildFolderList(),
            SizedBox(height: 20),
            Text('Files', style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 10),
            Expanded(child: _buildFileList()),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderList() {
    List<String> folders = [
      'Gaming Video',
      'Apks',
      'Documents',
      'Website Templates',
      'Photos'
    ];
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

  Widget _buildFileList() {
    List<String> files = [
      'MyRemoteUpload.png',
      'dog.png',
      'myphoto.jpeg',
      'thumbnail1.png',
      'logo.svg',
      'MyLocalUpload.png',
      'pfp.gif'
    ];
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
