import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/location_entry_model.dart';

class LocationTable extends StatefulWidget {
  const LocationTable({super.key, required this.entries});

  final List<LocationEntry> entries;

  @override
  State<LocationTable> createState() => _LocationTableState();
}

class _LocationTableState extends State<LocationTable> {
  int? _selectedIndex = -1;

  Future<void> showActionDialog(BuildContext context, LocationEntry entry) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Actions'),
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                // Handle edit action
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex = -1;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                // Handle delete action
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex = -1;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedEntries = widget.entries.toList()..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    for (int i = 0; i < sortedEntries.length; i++) {
      sortedEntries[i].key = i;
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Locations Captured",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, decoration: TextDecoration.underline),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              showCheckboxColumn: false,
              columns: const [
                DataColumn(
                    label: Text(
                  'Date',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  'Time',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  'Latitude',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  'Longitude',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
              ],
              onSelectAll: (val) {
                setState(() {
                  _selectedIndex = -1;
                });
              },
              rows: sortedEntries.map((entry) {
                final index = entry.key;
                return DataRow(
                  cells: [
                    DataCell(Text(DateFormat('MMM d, yyyy').format(entry.dateTime))),
                    DataCell(Text(DateFormat('h:mm a').format(entry.dateTime))),
                    DataCell(Text('${entry.latitude}')),
                    DataCell(Text('${entry.longitude}')),
                  ],
                  selected: index == _selectedIndex,
                  onSelectChanged: (bool? value) {
                    setState(() {
                      _selectedIndex = value! ? index : null;
                    });
                    if (value == true) {
                      showActionDialog(context, entry);
                    } else {
                      setState(() {
                        entry.isSelected = false;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
