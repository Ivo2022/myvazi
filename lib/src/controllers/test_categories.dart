/*
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myvazi/src/controllers/controllers.dart';
import 'package:myvazi/src/models/models.dart';

class DisplayUserDataWidget extends StatefulWidget {
  const DisplayUserDataWidget({super.key});

  @override
  State<DisplayUserDataWidget> createState() => _DisplayUserDataWidgetState();
}

class _DisplayUserDataWidgetState extends State<DisplayUserDataWidget> {
  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<List<UsersModel>> readDataFromHive() async {
    final box = Hive.box<UsersModel>('users_model_box');
    return Future.value(box.values.toList());
  }

  @override
  Widget build(BuildContext context) {
    print(readDataFromHive());
    return FutureBuilder<List<UsersModel>>(
      future: readDataFromHive(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data available.');
        } else {
          // Display the data in your UI
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              UsersModel userData = snapshot.data![index];
              return ListTile(
                title: Text(userData.userName),
                subtitle: Text(userData.userPhone),
              );
            },
          );
        }
      },
    );
  }
}
*/