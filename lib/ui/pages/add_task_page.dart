import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedData = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: primaryClr,
        ),
      ),
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 18,
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: 'Enter title here',
                controller: _titleController,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter note here',
                controller: _noteController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedData).toString(),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  onPressed: () => _getDateFromUser(),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        icon: Icon(Icons.access_time_rounded),
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        icon: Icon(Icons.access_time_outlined),
                        onPressed: () => _getTimeFromUser(isStartTime: false),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early ',
                widget: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(15),
                      items: remindList
                          .map<DropdownMenuItem<String>>(
                            (int value) => DropdownMenuItem<String>(
                              value: value.toString(),
                              child: Text(
                                '$value',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(
                        height: 0,
                      ),
                      style: subTitleStyle,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRemind = int.parse(newValue!);
                        });
                      },
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
              InputField(
                title: 'Repeat',
                hint: '$_selectedRepeat  ',
                widget: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(15),
                      items: repeatList
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                '$value',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(
                        height: 0,
                      ),
                      style: subTitleStyle,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRepeat = newValue!;
                        });
                      },
                    ),
                    SizedBox(width: 6),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildColumn(),
                    MyButton(
                      label: "Creat Task",
                      onTap: () {
                        _validateDate();
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: TitleStyle,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Wrap(
                children: List.generate(
              3,
              (index) => GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    child: _selectedColor == index
                        ? const Icon(
                            Icons.done,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : orangeClr,
                    radius: 18,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
              ),
            )),
          ],
        )
      ],
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        'required',
        'message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_rounded,
          color: Colors.red,
        ),
      );
    } else {
      print('');
    }
  }

  _addTasksToDb() async {
    int value = await _taskController.addTask(
        task: Task(
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: DateFormat.yMd().format(_selectedData),
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
    ));
    print(value);
  }

  _getDateFromUser() async {
    DateTime? _pikedDate = await showDatePicker(
        context: context,
        initialDate: _selectedData,
        firstDate: DateTime(2015),
        lastDate: DateTime(2030));
    if (_pikedDate != null) setState(() => _selectedData = _pikedDate);
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pikedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15))),
    );
    String formatedTime = _pikedTime!.format(context);
    if (_pikedTime != null && isStartTime == true)
      setState(() => _startTime = formatedTime);
    else if (_pikedTime != null && isStartTime == false)
      setState(() => _endTime = formatedTime);
  }
}
