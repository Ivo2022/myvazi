import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final controller = MultiImagePickerController(
    maxImages: 10,
    withReadStream: true,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            MultiImagePickerView(
              showAddMoreButton: controller.images.length >= 3 ? false : true,
              onChange: (list) {
                setState(() {
                  // controller.images = list;
                  debugPrint(list.toString());
                });
              },
              controller: controller,
              padding: const EdgeInsets.all(10),
            ),
            const SizedBox(height: 32),
            Visibility(
              visible: controller.images.isNotEmpty ? false : true,
              child: const Text(
                "Please add at least one image to proceed!",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Select Images'),
        actions: [
          if (controller.images.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                final images = controller.images;
                // // use these images
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //     content: Text(images.map((e) => e.name).toString())));
                Navigator.pushNamed(context, '/product-upload',
                    arguments: images);
              },
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
