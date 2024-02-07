import 'package:flutter/material.dart';

class MultiSelectDialog<T> extends StatefulWidget {
  final List<T> items;
  final Set<T> initialSelectedValues;

  const MultiSelectDialog(
      {super.key, required this.items, required this.initialSelectedValues});

  @override
  State<MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState<T> extends State<MultiSelectDialog<T>> {
  late Set<T> selectedValues;

  @override
  void initState() {
    super.initState();
    selectedValues = widget.initialSelectedValues;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Items'),
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          child: Column(
            children: widget.items.map((item) {
              return CheckboxListTile(
                title: Text(item.toString()),
                value: selectedValues.contains(item),
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null) {
                      if (value) {
                        selectedValues.add(item);
                      } else {
                        selectedValues.remove(item);
                      }
                    }
                  });
                },
              );
            }).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedValues);
          },
          child: const Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dropdown Dialog Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              _showMultiSelect(context);
            },
            child: const Text('Show MultiSelect Dialog'),
          ),
        ),
      ),
    );
  }

  void _showMultiSelect(BuildContext context) async {
    final items = [1, 2, 3, 4, 5];
    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog<int>(
          items: items,
          initialSelectedValues: {1},
        );
      },
    );

    if (selectedValues != null) {
      print('Selected Values: $selectedValues');
    }
  }
}
