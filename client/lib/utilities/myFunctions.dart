import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//models
import '../models/task.dart';
import '../models/user.dart';

class MyFunctions {
  //Task Functions

  static Future<List<Task>> getUserTasks(String uid) async {
    final response =
        await http.get(Uri.parse('https://nus-living.vercel.app/api/v1/user/uid/$uid'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonObject =
          jsonDecode(response.body)["data"]["user"];
      var jsonTasks = jsonObject["createdTasks"];
      List<Task> result = [];
      for (Map<String, dynamic> task in jsonTasks) {
        result.add(Task.fromJson(task));
      }
      return result;
    }
    return [];
  }

  static Future<List<Task>> getFavouriteTasks(String uid) async {
    final response =
        await http.get(Uri.parse('https://nus-living.vercel.app/api/v1/user/uid/$uid'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonObject =
          jsonDecode(response.body)["data"]["user"];
      print(jsonObject["favouriteTasks"]);
      var jsonTasks = jsonObject["favouriteTasks"];
      List<Task> result = [];
      for (Map<String, dynamic> task in jsonTasks) {
        result.add(Task.fromJson(task));
      }
      return result;
    }
    return [];
  }

  static Future<List<Task>> getAppliedTasks(String uid) async {
    final response =
        await http.get(Uri.parse('https://nus-living.vercel.app/api/v1/user/uid/$uid'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonObject =
          jsonDecode(response.body)["data"]["user"];
      var jsonTasks = jsonObject["appliedTasks"];
      List<Task> result = [];
      for (Map<String, dynamic> task in jsonTasks) {
        result.add(Task.fromJson(task));
      }
      return result;
    }
    return [];
  }

  static Future<List<Task>> getAllTasks() async {
    final response =
        await http.get(Uri.parse('https://nus-living.vercel.app/api/v1/tasks'));
    if (response.statusCode == 200) {
      List<dynamic> jsonTasks = jsonDecode(response.body)["data"]["tasks"];
      List<Task> result = [];
      for (Map<String, dynamic> task in jsonTasks) {
        result.add(Task.fromJson(task));
      }
      return result;
    }
    return [];
  }

  //User Functions
  static Future<bool> getUserPresent(String uid) async {
    final response =
        await http.get(Uri.parse('https://nus-living.vercel.app/api/v1/user/uid/$uid'));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //should always call getUserPresent first to check, so we know theres a user
  static Future<User> getUserByUid(String uid) async {
    final response =
        await http.get(Uri.parse('https://nus-living.vercel.app/api/v1/user/uid/$uid'));
    return User.fromJson(json.decode(response.body)["data"]["user"]);
  }

  static Future<User> getUserById(String id) async {
    final response =
        await http.get(Uri.parse('https://nus-living.vercel.app/api/v1/user/id/$id'));
    return User.fromJson(json.decode(response.body)["data"]["user"]);
  }
}
