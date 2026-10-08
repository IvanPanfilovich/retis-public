import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:retis/database/database_repository.dart';
import 'package:retis/connections/models/connection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final DatabaseRepository databaseRepository;
  SettingsBloc({required this.databaseRepository}) : super(SettingsInitial()) {
    on<ImportConnections>((event, emit) async {
      debugPrint("Importing connections");

      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        var bytes = File(filePath).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        Sheet sheetObject = excel['Sheet1'];

        for (int i = 1; i < sheetObject.rows.length; i++) {
          List<Data?> dataRow = sheetObject.rows[i];

          Connection connection = Connection(
            id: int.parse((dataRow[0]!.value as TextCellValue).value),
            name: (dataRow[1]!.value as TextCellValue).value,
            commentary: (dataRow[2]!.value as TextCellValue).value,
            intervalInDays:
                int.parse((dataRow[3]!.value as TextCellValue).value),
            lastContactedDate: DateTime.fromMillisecondsSinceEpoch(
                int.parse((dataRow[4]!.value as TextCellValue).value)),
          );

          await databaseRepository.insertConnection(connection);
        }
      } else {}
    });

    on<ExportConnections>((event, emit) async {
      debugPrint("Exporting connections");

      final List<Connection> rows = await databaseRepository.queryAllConnections();
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      List<CellValue> columnNames = DatabaseRepository.columns
          .map((columnName) => TextCellValue(columnName))
          .toList();
      sheetObject.appendRow(columnNames);

      for (var connection in rows) {
        List<dynamic> rowValues = [
          connection.id,
          connection.name,
          connection.commentary,
          connection.intervalInDays,
          connection.lastContactedDate.millisecondsSinceEpoch,
        ];
        sheetObject.appendRow(
            rowValues.map((e) => TextCellValue(e.toString())).toList());
      }

      if(Platform.isAndroid){
        PermissionStatus status = await Permission.storage.request();

        if (status.isGranted) {
          String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

          if (selectedDirectory != null) {
            var bytes = excel.encode();
            if (bytes != null) {
              String filePath = join(selectedDirectory, "Connections.xlsx");
              File(filePath)
                ..createSync(recursive: true)
                ..writeAsBytesSync(bytes);
            }

            ScaffoldMessenger.of(context as BuildContext).showSnackBar(
              const SnackBar(content: Text('Exported connections to Excel')),
            );
          } else {
            ScaffoldMessenger.of(context as BuildContext).showSnackBar(
              const SnackBar(content: Text('Failed to export connections to Excel')),
            );
          }
        }
      } else {
        String? selectedDirectory = (await getApplicationDocumentsDirectory()).path;

        String fileName = 'Connections.xlsx';
        String filePath = '$selectedDirectory/$fileName';
        File file = File(filePath);
        await file.writeAsBytes(excel.encode()!);

        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text('Exported connections to Excel')),
        );
      }
    });
  }
}
