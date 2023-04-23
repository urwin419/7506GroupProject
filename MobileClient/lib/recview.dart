// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:group_project/exerecord.dart';
import 'package:intl/intl.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'mealrecord.dart';
import 'weightrecord.dart';
import 'package:http/http.dart' as http;
import 'package:group_project/dialogs.dart';
import 'recview.dart';

class ExeRec extends StatelessWidget {
  const ExeRec({super.key});

  @override
  Widget build(BuildContext context) {
    String a = 'KM';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Here is all your exercise records'),
      ),
      body: Center(
          child: FutureBuilder<List<ExeRecord>>(
        future: fetchExe(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.data![index].type != 'Jogging') {
                    a = ' ';
                  }
                  return Container(
                    height: 75,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Text(
                                  snapshot.data![index].date,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  snapshot.data![index].time,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Text(
                                  snapshot.data![index].content,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  a,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  snapshot.data![index].type,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ])
                      ],
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const CircularProgressIndicator();
        },
      )),
    );
  }
}

class MealRec extends StatelessWidget {
  const MealRec({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Here is all your meal records'),
      ),
      body: Center(
          child: FutureBuilder<List<MealRecord>>(
        future: fetchMeal(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 75,
                      color: Colors.white,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Text(
                                snapshot.data![index].date,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                snapshot.data![index].time,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                snapshot.data![index].meal,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]));
                });
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const CircularProgressIndicator();
        },
      )),
    );
  }
}

class WeiRec extends StatelessWidget {
  const WeiRec({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Here is all your Weight records'),
      ),
      body: Center(
          child: FutureBuilder<List<WeightRecord>>(
        future: fetchWeight(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 75,
                      color: Colors.white,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Text(
                                snapshot.data![index].date,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                snapshot.data![index].weight,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const Expanded(
                              child: Text(
                                "kg",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]));
                });
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const CircularProgressIndicator();
        },
      )),
    );
  }
}
