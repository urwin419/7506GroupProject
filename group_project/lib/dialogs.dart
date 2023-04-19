// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'mealrecord.dart';
import 'weightrecord.dart';
import 'package:http/http.dart' as http;
import 'exerecord.dart';

weidialog(context, id) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        var dcontext = context;
        var dateController = TextEditingController(
            text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
        var weightController = TextEditingController(text: '60.00');
        return AlertDialog(
          scrollable: true,
          title: const Text('Record Weight'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      icon: Icon(Icons.today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        dateController.text = formattedDate;
                      } else {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                        dateController.text = formattedDate;
                      }
                    },
                  ),
                  TextFormField(
                    inputFormatters: [
                      NumberTextInputFormatter(
                        integerDigits: 4,
                        decimalDigits: 2,
                        maxValue: '1000.00',
                        decimalSeparator: '.',
                        groupDigits: 3,
                        groupSeparator: ',',
                        allowNegative: false,
                        overrideDecimalPoint: true,
                        insertDecimalPoint: false,
                        insertDecimalDigits: true,
                      ),
                    ],
                    keyboardType: TextInputType.number,
                    controller: weightController,
                    textAlign: TextAlign.center,
                    autovalidateMode: AutovalidateMode.always,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.monitor_weight),
                      labelText: 'Weight',
                      hintText: '0.0',
                      suffixText: 'Kg',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                var date = dateController.text;
                var weight = weightController.text;
                var record = WeightRecord(id, date, weight);
                final String body = jsonEncode(record);
                final url = Uri.parse('http://10.0.2.2:5000/rec_wei');
                final response = await http.post(url,
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: body);
                if (!context.mounted) return;
                if (response.statusCode ~/ 100 == 2) {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content:
                          const Text('You just have your WEIGHT recorded!'),
                      actions: <TextButton>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dcontext);
                          },
                          child: const Text('Close'),
                        )
                      ],
                    ),
                  );
                } else {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Text(response.statusCode.toString()),
                      actions: <TextButton>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        )
                      ],
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      });
}

mealdialog(context, id, selectedValue, meals) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        var dateController = TextEditingController(
            text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
        var timeController = TextEditingController(text: "00:00");
        return AlertDialog(
          scrollable: true,
          title: const Text('Record Meal Time'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      icon: Icon(Icons.today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        dateController.text = formattedDate;
                      } else {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                        dateController.text = formattedDate;
                      }
                    },
                  ),
                  TextFormField(
                    controller: timeController,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      icon: Icon(Icons.schedule),
                    ),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );

                      if (pickedTime != null) {
                        DateTime parsedTime = DateFormat.jm()
                            .parse(pickedTime.format(context).toString());
                        String formattedTime =
                            DateFormat('HH:mm').format(parsedTime);
                        timeController.text = formattedTime;
                      } else {
                        DateTime parsedTime = DateFormat.jm()
                            .parse(TimeOfDay.now().format(context).toString());
                        String formattedTime =
                            DateFormat('HH:mm').format(parsedTime);
                        timeController.text = formattedTime;
                      }
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      filled: true,
                    ),
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      selectedValue = newValue!;
                    },
                    items: meals.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                var date = dateController.text;
                var time = timeController.text;
                var record = MealRecord(id, date, time, selectedValue);
                final String body = jsonEncode(record);
                final url = Uri.parse('http://10.0.2.2:5000/rec_meal');
                final response = await http.post(url,
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: body);
                if (!context.mounted) return;
                if (response.statusCode ~/ 100 == 2) {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: const Text('Hope you enjoyed the MEAL!'),
                      actions: <TextButton>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        )
                      ],
                    ),
                  );
                } else {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Text(response.statusCode.toString() + body),
                      actions: <TextButton>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        )
                      ],
                    ),
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      });
}

exedialog(context, id, selectedexe, exes) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        var dateController = TextEditingController(
            text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
        var timeController = TextEditingController(text: "00:00");
        var contentController = TextEditingController(text: '10');
        return AlertDialog(
          scrollable: true,
          title: const Text('Let us record you exercise!'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      icon: Icon(Icons.today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        dateController.text = formattedDate;
                      } else {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                        dateController.text = formattedDate;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        scrollable: true,
                        title: const Text('Let us record your exercise time!'),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: timeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Time',
                                    icon: Icon(Icons.schedule),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      initialTime: TimeOfDay.now(),
                                      context: context,
                                    );
                                    if (pickedTime != null) {
                                      DateTime parsedTime = DateFormat.jm()
                                          // ignore: use_build_context_synchronously
                                          .parse(pickedTime
                                              .format(context)
                                              .toString());
                                      String formattedTime = DateFormat('HH:mm')
                                          .format(parsedTime);
                                      timeController.text = formattedTime;
                                    } else {
                                      DateTime parsedTime = DateFormat.jm()
                                          // ignore: use_build_context_synchronously
                                          .parse(TimeOfDay.now()
                                              .format(context)
                                              .toString());
                                      String formattedTime = DateFormat('HH:mm')
                                          .format(parsedTime);
                                      timeController.text = formattedTime;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      scrollable: true,
                                      title: const Text(
                                          'What exercise have you enjoyed?'),
                                      content: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Form(
                                          child: Column(
                                            children: <Widget>[
                                              DropdownButtonFormField<String>(
                                                decoration:
                                                    const InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 2),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 2),
                                                  ),
                                                  filled: true,
                                                ),
                                                value: selectedexe,
                                                onChanged: (String? newValue) {
                                                  selectedexe = newValue!;
                                                },
                                                items: exes.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  );
                                                }).toList(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            execontentdia(
                                                context,
                                                id,
                                                dateController,
                                                timeController,
                                                selectedexe,
                                                contentController);
                                          },
                                          child: const Text('Continue'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: const Text('Continue'),
                          ),
                        ],
                      );
                    });
              },
              child: const Text('Continue'),
            ),
          ],
        );
      });
}

execontentdia(context, id, dateController, timeController, selectedexe,
    contentController) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('How much have you exercised?'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    inputFormatters: [
                      NumberTextInputFormatter(
                        integerDigits: 5,
                        maxValue: '10000',
                        groupDigits: 3,
                        groupSeparator: ',',
                        allowNegative: false,
                      ),
                    ],
                    keyboardType: TextInputType.number,
                    controller: contentController,
                    textAlign: TextAlign.center,
                    autovalidateMode: AutovalidateMode.always,
                    decoration: InputDecoration(
                      labelText: selectedexe,
                      hintText: '10',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                var date = dateController.text;
                var time = timeController.text;
                var type = selectedexe;
                var content = contentController.text;
                var record = ExeRecord(id, date, time, type, content);
                final String body = jsonEncode(record);
                final url = Uri.parse('http://10.0.2.2:5000/rec_exe');
                final response = await http.post(url,
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: body);
                if (!context.mounted) return;
                if (response.statusCode ~/ 100 == 2) {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: const Text('Happy exercising!'),
                      actions: <TextButton>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        )
                      ],
                    ),
                  );
                } else {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Text(response.statusCode.toString() + body),
                      actions: <TextButton>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        )
                      ],
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      });
}
