import 'package:flutter/material.dart';
import 'dart:io';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class ProductImageDisplay extends StatefulWidget {
  const ProductImageDisplay({
    super.key,
    required this.isFileSelected,
    required this.context,
    required this.pickedImage,
    required this.file,
  });

  final int isFileSelected;
  final BuildContext context;
  final File? pickedImage;
  final File file;

  @override
  State<ProductImageDisplay> createState() => _ProductImageDisplayState();
}

class _ProductImageDisplayState extends State<ProductImageDisplay> {
  // final controller = MultiImagePickerController(
  //   maxImages: 3,
  //   withReadStream: true,
  //   allowedImageTypes: ['png', 'jpg', 'jpeg'],
  // );

  @override
  Widget build(BuildContext context) {
    if (widget.isFileSelected == 0) {
      return const Center(child: Text("Please go back and select an image!"));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Sell a product'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/product-upload',
                    arguments: widget.pickedImage);
              },
              child: const Text('Next'),
            )
          ],
        ),
        body: ListView(
          children: const [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  // MultiImagePickerView(
                  //   onChange: (list) {
                  //     debugPrint(list.toString());
                  //   },
                  //   controller: controller,
                  //   padding: const EdgeInsets.all(10),
                  // ),
                  // const SizedBox(height: 32),
                ],
              ),
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 9 / 16,
            //   width: MediaQuery.of(context).size.width,
            //   child: Image.file(widget.file, fit: BoxFit.scaleDown),
            // ),
            Text("0 of 3 images attached")
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     final images = controller.images;
        //     // use these images
        //     ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(content: Text(images.map((e) => e.name).toString())));
        //   },
        //   backgroundColor: Colors.amber,
        //   foregroundColor: Colors.black,
        //   child: const Icon(Icons.add_a_photo_rounded),
        // ),
      );
    }
  }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }
}
