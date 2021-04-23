import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import "service.dart";
import 'package:table_calendar/table_calendar.dart';
import 'package:universal_html/html.dart' as html;
import 'package:date_format/date_format.dart';

List<bool> isCheck = [];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Book'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.date_range),
                text: ('Appointment'),
              ),
              Tab(icon: Icon(Icons.people), text: ('Contacts')),
              Tab(icon: Icon(Icons.note), text: ('Notes')),
              Tab(icon: Icon(Icons.done_all), text: ('Tasks'))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.blue,
          child: Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            Center(child: Calendar()),
            Contacts(),
            Center(child: Notes()),
            Center(child: Tasks()),
          ],
        ),
      ),
    ));
  }
}

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Future<List<Event>> futureEvent;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onDaySelected: (month, day) {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Column(children: [
                      Center(
                          child: Container(
                              margin: EdgeInsets.all(5),
                              child: Text(
                                formatDate(month, [M, ' ', d, ',', yyyy])
                                    .toString(),
                                style:
                                    TextStyle(color: Colors.cyan, fontSize: 20),
                              ))),
                      FutureBuilder<List<Event>>(
                          future: getEventData(),
                          builder: (context, snapshot) {
                            List<Event> events = snapshot.data;
                            if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            } else if (snapshot.hasData) {
                              return SingleChildScrollView(
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: events.length,
                                      itemBuilder: (context, i) {
                                        return Card(
                                            margin: EdgeInsets.all(10),
                                            color: Colors.grey.shade200,
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                    title: Text(
                                                      events[i].title,
                                                    ),
                                                    subtitle: Text(
                                                        events[i].subtitle),
                                                  ),
                                                ]));
                                      }));
                            }
                            return Center(child: CircularProgressIndicator());
                          })
                    ]));
              });
        });
  }
}

class Contacts extends StatefulWidget {
  Contacts({Key key}) : super(key: key);
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  Future<List<Contact>> futureContact;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Contact>>(
      future: getContactData(),
      builder: (context, snapshot) {
        List<Contact> contacts = snapshot.data;

        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else if (snapshot.hasData) {
          return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                RandomColor _randomColor = RandomColor();
                Color _color = _randomColor.randomColor(
                    colorBrightness: ColorBrightness.light);

                return Container(
                    margin: EdgeInsets.all(15),
                    child: ListTile(
                        leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(contacts[index].imgUri),
                            backgroundColor: _color),
                        title: Text(contacts[index].name),
                        subtitle: Text(contacts[index].number.toString())));
              });
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class Notes extends StatefulWidget {
  Notes({Key key}) : super(key: key);
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  Future<List<Note>> futureNote;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Note>>(
      future: getNoteData(),
      builder: (context, snapshot) {
        List<Note> notes = snapshot.data;

        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else if (snapshot.hasData) {
          return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, i) {
                RandomColor _randomColor = RandomColor();
                Color _color = _randomColor.randomColor(
                    colorBrightness: ColorBrightness.light);

                return Container(
                  margin: EdgeInsets.all(10),
                  child: Card(
                      color: _color,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(notes[i].title),
                              subtitle: Text(notes[i].subtitle),
                            )
                          ])),
                  decoration: BoxDecoration(boxShadow: [
                    new BoxShadow(
                      color: Colors.black54,
                      blurRadius: 7.0,
                      offset: Offset(
                        7.0,
                        7.0,
                      ),
                    )
                  ]),
                );
              });
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    return (FutureBuilder<List<Task>>(
        future: getTaskData(),
        builder: (context, snapshot) {
          List<Task> tasks = snapshot.data;

          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (snapshot.hasData) {
            for (int n = 0; n < tasks.length; n++) {
              isCheck.add(false);
            }
            return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, i) {
                  return Container(
                      margin: EdgeInsets.all(10),
                      child: CheckboxListTile(
                          title: Text(
                            tasks[i].title,
                            style: TextStyle(
                                decoration: isCheck[i]
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: isCheck[i] ? Colors.grey : Colors.black),
                          ),
                          subtitle: Text(
                            tasks[i].subtitle,
                            style: TextStyle(
                                decoration: isCheck[i]
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: isCheck[i] ? Colors.grey : Colors.black),
                          ),
                          value: isCheck[i],
                          onChanged: (value) {
                            setState(() {
                              isCheck[i] = value;
                            });
                          }));
                });
          }

          return CircularProgressIndicator();
        }));
  }
}
