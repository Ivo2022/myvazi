import 'package:flutter/material.dart';
import 'package:myvazi/src/configs/server_connect.dart';
// import '../views/shared/server_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ReadCategories extends StatefulWidget {
  const ReadCategories({super.key});

  @override
  State<ReadCategories> createState() => _ReadCategoriesState();
}

class _ReadCategoriesState extends State<ReadCategories> {

  Future<List<Map<String, dynamic>>> fetchDataFromPHP() async {
    String url = Platform.isAndroid ? 'http://192.168.88.230/twambale/api/menu.class.php' : 'http://localhost/twambale/api/menu.class.php';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': "*/*",
        'connection': 'keep-alive',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      //return List<Map<String, dynamic>>.from(data);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data. HTTP Error ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Reading categories'),
          centerTitle: false,
          elevation: 0.0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // fetchData();
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder(
          future: fetchDataFromPHP(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('Error: ${snapshot.error}')),
              );
            } else {
              final dataList = snapshot.data;
              // List<Map<String, dynamic>> dataList = snapshot.data as List<Map<String, dynamic>>;
              // return _buildListView(dataList!);
              return _buildListView(dataList!);

            }
          },
        )
    );
  }
}

ListView _buildListView(List<Map<String, dynamic>> dataList) {
  // Define the DataColumn widgets once
  List<DataColumn> columns = const [
    DataColumn(label: Text('ID')),
    DataColumn(label: Text('NAME')),
    DataColumn(label: Text('VISIBILITY')),
  ];

  List<DataRow> rows = dataList.map((data) {
    return DataRow(
      cells: [
        DataCell(Text('${data['category_id']}')),
        DataCell(Text(data['name'])),
        DataCell(Text(data['visibility'])),
      ],
    );
  }).toList();

  return ListView(
    children: [
      Card(
        elevation: 2.0,
        child: DataTable(
          columns: columns,
          rows: rows,
        ),
      ),
    ],
  );
}

Future<void> downloadAndSaveImage() async {
  final url = Uri.parse('https://example.com/image.jpg'); // Replace with your image URL
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final File file = File('/path/to/your/directory/image.jpg'); // Replace with your desired file path

    try {
      await file.writeAsBytes(response.bodyBytes);
      print('Image saved to: ${file.path}');
    } catch (e) {
      print('Error saving image: $e');
    }
  } else {
    print('Failed to download the image. Status code: ${response.statusCode}');
  }
}
