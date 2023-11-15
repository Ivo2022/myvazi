// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:myvazi/src/providers/app_state_manager.dart';
import 'package:myvazi/src/screens/frontpage.dart';
import 'package:myvazi/src/screens/profile.dart';
import 'package:myvazi/src/screens/post.dart';
import 'package:myvazi/src/screens/chat.dart';
import 'package:myvazi/src/screens/sale.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Routing extends StatefulWidget {
  const Routing({super.key});

  @override
  State<Routing> createState() => _RoutingState();
}

class _RoutingState extends State<Routing> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int isFileSelected = 0;
  late File? pickedImage;
  int current_index = 0;

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    var pickedFile = await picker.getImage(
      source: source,
      imageQuality: 100,
      maxHeight: MediaQuery.of(context).size.height,
      maxWidth: MediaQuery.of(context).size.width,
      preferredCameraDevice: CameraDevice.rear,
    );

    setState(() {
      if (pickedFile == null) {
        isFileSelected = 0;
      } else {
        pickedImage = File(pickedFile.path);
        isFileSelected = 1;
      }
    });
  }

  Widget showImageWidget(File file) {
    if (isFileSelected == 0) {
      return const Center(child: Text("Please go back and select an image!"));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Sell a product'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/product-upload',
                    arguments: pickedImage);
              },
              child: const Text('Next'),
            )
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 9 / 16,
          width: MediaQuery.of(context).size.width,
          child: Image.file(file, fit: BoxFit.none),
        ),
      );
    }
  }

  Widget _buildScreenContent(int selectedScreenIndex) {
    switch (selectedScreenIndex) {
      case 0:
        return const FrontPage();
      case 1:
        return const Screen1();
      case 2:
        return const Sale();
      case 3:
        return const Chat();
      case 4:
        return const Profile();
      default:
        return Container(); // Placeholder for default case
    }
  }

  void _handleBottomNavBarTap(BuildContext context,
      AppStateManagerProvider appStateManager, int index) {
    current_index = index;
    if (index == 1) {
      // For the second tab, show a Bottom Sheet
      _showBottomSheet(context);
    } else {
      // Clear pickedImage when navigating to other tabs
      setState(() {
        pickedImage = null;
      });

      // For other tabs, update the selected screen index
      appStateManager.setSelectedScreenIndex(index);
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(12.0),
          // Customize your Bottom Sheet content here
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  _pickImage(context, ImageSource.gallery);
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  _pickImage(context, ImageSource.camera);
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appStateManager = Provider.of<AppStateManagerProvider>(context);
    final selectedScreenIndex = appStateManager.selectedScreenIndex;

    return Scaffold(
      body: Center(
        child: (isFileSelected == 1 && current_index == 1)
            ? showImageWidget(pickedImage!)
            : _buildScreenContent(selectedScreenIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: selectedScreenIndex,
        onTap: (index) {
          _handleBottomNavBarTap(context, appStateManager, index);
        },
        type:
            BottomNavigationBarType.fixed, // This ensures all labels are shown
        showSelectedLabels: true, // Show labels for selected items
        showUnselectedLabels: false, // Show labels for unselected items

        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/sales.png'),
            label: 'Sale',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              color: Colors.black,
            ),
            label: 'Chat',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
