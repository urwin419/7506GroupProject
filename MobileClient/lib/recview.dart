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
    return Scaffold(
      appBar: AppBar(
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
                  return Container(
                    height: 75,
                    color: Colors.white,
                    child: Center(
                      child: Text(snapshot.data![index].type),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const CircularProgressIndicator();
        },
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!')),
    );
  }
}

class MealRec extends StatelessWidget {
  const MealRec({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    child: Center(
                      child: Text(snapshot.data![index].meal),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const CircularProgressIndicator();
        },
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!')),
    );
  }
}

class WeiRec extends StatelessWidget {
  const WeiRec({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    child: Center(
                      child: Text(snapshot.data![index].weight),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const CircularProgressIndicator();
        },
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!')),
    );
  }
}
