import 'dart:convert';

import 'dart:async';
import 'package:http/http.dart' as http;

// ignore: missing_return

Future<List<Note>> getNoteData() async {
  http.Response response = await http.get(
      Uri.parse("https://mocki.io/v1/c2ddd598-46ff-44e7-a20f-2379d3a65c43"));

  if (response.statusCode == 200) {
    var body = json.decode(utf8.decode(response.bodyBytes));

    List<Note> notess = [];
    for (var item in body) {
      notess.add(Note.fromJson(item));
    }
    return notess;
  } else {
    throw Exception('Failed to load data');
  }
}

class Note {
  String title;
  String subtitle;

  Note(
    this.title,
    this.subtitle,
  );

  Note.fromJson(Map<String, dynamic> json) {
    this.title = json['noteTitle'];
    this.subtitle = json['noteDetails'];
  }
}

Future<List<Contact>> getContactData() async {
  http.Response response = await http.get(
      Uri.parse("https://mocki.io/v1/831ff5f5-a950-4af3-a2e4-0ec5b84c5c98"));

  if (response.statusCode == 200) {
    var body = json.decode(utf8.decode(response.bodyBytes));

    List<Contact> contactss = [];
    for (var item in body) {
      contactss.add(Contact.fromJson(item));
    }
    return contactss;
  } else {
    throw Exception('Failed to load data');
  }
}

class Contact {
  String name;
  int number;
  String imgUri;

  Contact(this.name, this.number, this.imgUri);

  Contact.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.number = json['number'];
    this.imgUri = json['imgUrl'];
  }
}

Future<List<Event>> getEventData() async {
  http.Response response = await http.get(
      Uri.parse("https://mocki.io/v1/3d2daadd-69f9-459a-8cf3-a102a573e83d"));

  if (response.statusCode == 200) {
    var body = json.decode(utf8.decode(response.bodyBytes));

    List<Event> events = [];
    for (var item in body) {
      events.add(Event.fromJson(item));
    }
    return events;
  } else {
    throw Exception('Failed to load data');
  }
}

class Event {
  String title;
  String subtitle;

  Event(
    this.title,
    this.subtitle,
  );

  Event.fromJson(Map<String, dynamic> json) {
    this.title = json['event'];
    this.subtitle = json['eventDetails'];
  }
}

Future<List<Task>> getTaskData() async {
  http.Response response = await http.get(
      Uri.parse("https://mocki.io/v1/5228b257-1828-4ed6-94e8-da512e7c280d"));
  if (response.statusCode == 200) {
    var body = json.decode(utf8.decode(response.bodyBytes));
    List<Task> notess = [];
    for (var item in body) {
      notess.add(Task.fromJson(item));
    }
    return notess;
  } else {
    throw Exception('Failed to load data');
  }
}

class Task {
  String title;
  String subtitle;

  Task(
    this.title, {
    this.subtitle,
  });

  Task.fromJson(Map<String, dynamic> json) {
    this.title = json['taskTitle'];
    subtitle = json['taskDetails'];
    if (subtitle == null) {
      subtitle = " ";
    }
  }
}
