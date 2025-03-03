import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime initialDaySelected;
  final Function changeDay;

  const CalendarWidget(
      {super.key, required this.initialDaySelected, required this.changeDay});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDay;
  final _firstDate = DateTime(2023);
  final _lastDate = DateTime(2024, 12, 31);
  late EasyInfiniteDateTimelineController? _controller;

  DayStyle _getDayStyle([
    Color? modColor,
  ]) {
    final dayNumStyle = Theme.of(context).textTheme.titleLarge;
    final dayStrStyle = Theme.of(context).textTheme.labelSmall;
    return DayStyle(
        splashBorder: BorderRadius.circular(100),
        borderRadius: 40,
        dayNumStyle: modColor != null
            ? dayNumStyle?.copyWith(color: modColor)
            : dayNumStyle,
        dayStrStyle: modColor != null
            ? dayStrStyle?.copyWith(color: modColor)
            : dayStrStyle);
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDaySelected;
    _controller = EasyInfiniteDateTimelineController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () {
        _controller?.animateToCurrentData();
      });
      });
  }

  @override
  void dispose() {
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime prevMonthDate =
        _selectedDay.subtract(const Duration(days: 30));
    final DateTime nextMonthDate = _selectedDay.add(const Duration(days: 30));
    final bool prevMonthAvailable = prevMonthDate.isAfter(_firstDate);
    final bool nextMonthAvailable = nextMonthDate.isBefore(_lastDate);
    return Column(children: [
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(DateFormat('d / M / y').format(_selectedDay),
                  style: Theme.of(context).textTheme.titleMedium))),
      EasyInfiniteDateTimeLine(
        showTimelineHeader: false,
        controller: _controller,
        firstDate: _firstDate,
        lastDate: _lastDate,
        selectionMode: const SelectionMode.alwaysFirst(),
        focusDate: _selectedDay,
        onDateChange: (selectedDay) {
          _changeDay(selectedDay);
        },
        timeLineProps: EasyTimeLineProps(
          margin: EdgeInsets.only(bottom: 8.h, top: 12.h),
        ),
        activeColor: Theme.of(context).colorScheme.primary,
        dayProps: EasyDayProps(
            dayStructure: DayStructure.dayNumDayStr,
            inactiveDayStyle: _getDayStyle(),
            activeDayStyle:
                _getDayStyle(Theme.of(context).colorScheme.onPrimary),
            todayStyle: _getDayStyle(Theme.of(context).colorScheme.surfaceTint),
            todayHighlightColor: Theme.of(context).colorScheme.surfaceTint),
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ActionChip(
                  label: const Text('Today'),
                  onPressed: () {
                    _changeDay(DateTime.now());
                  }),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: prevMonthAvailable
                          ? () {
                              _changeDay(prevMonthDate);
                            }
                          : null,
                      icon: const Icon(Icons.chevron_left)),
                  Text(DateFormat.MMM().format(_selectedDay)),
                  IconButton(
                      onPressed: nextMonthAvailable
                          ? () {
                              _changeDay(nextMonthDate);
                            }
                          : null,
                      icon: const Icon(Icons.chevron_right))
                ],
              )
            ],
          ))
    ]);
  }

  void _changeDay(DateTime day) {
    _controller!.animateToDate(day);
    if (!DateUtils.isSameDay(_selectedDay, day)) {
      setState(() {
        _selectedDay = day;
      });
      widget.changeDay(day);
    }
  }
}
