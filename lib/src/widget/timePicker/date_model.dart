import 'package:base_flutter/src/widget/timePicker/date_format.dart';
import 'package:base_flutter/src/widget/timePicker/i18n_model.dart';

import 'datetime_util.dart';

//interface for picker data model
abstract class BasePickerModel {
  //a getter method for left column data, return null to end list
  String? leftStringAtIndex(int index);

  //a getter method for middle column data, return null to end list
  String? middleStringAtIndex(int index);

  //a getter method for right column data, return null to end list
  String? rightStringAtIndex(int index);

  //set selected left index
  void setLeftIndex(int index);

  //set selected middle index
  void setMiddleIndex(int index);

  //set selected right index
  void setRightIndex(int index);

  //return current left index
  int currentLeftIndex();

  //return current middle index
  int currentMiddleIndex();

  //return current right index
  int currentRightIndex();

  //return final time
  DateTime? finalTime();

  //return left divider string
  String leftDivider();

  //return right divider string
  String rightDivider();

  //layout proportions for 3 columns
  List<int> layoutProportions();
}

//a base class for picker data model
class CommonPickerModel extends BasePickerModel {
  late List<String> leftList;
  late List<String> middleList;
  late List<String> rightList;
  DateTime? currentTime;
  late int _currentLeftIndex;
  late int _currentMiddleIndex;
  late int _currentRightIndex;

  LocaleType locale;

  CommonPickerModel({this.currentTime, locale})
      : this.locale = locale ?? LocaleType.en;

  @override
  String? leftStringAtIndex(int index) {
    return null;
  }

  @override
  String? middleStringAtIndex(int index) {
    return null;
  }

  @override
  String? rightStringAtIndex(int index) {
    return null;
  }

  @override
  int currentLeftIndex() {
    return _currentLeftIndex;
  }

  @override
  int currentMiddleIndex() {
    return _currentMiddleIndex;
  }

  @override
  int currentRightIndex() {
    return _currentRightIndex;
  }

  @override
  void setLeftIndex(int index) {
    _currentLeftIndex = index;
  }

  @override
  void setMiddleIndex(int index) {
    _currentMiddleIndex = index;
  }

  @override
  void setRightIndex(int index) {
    _currentRightIndex = index;
  }

  @override
  String leftDivider() {
    return "";
  }

  @override
  String rightDivider() {
    return "";
  }

  @override
  List<int> layoutProportions() {
    return [1, 1, 1];
  }

  @override
  DateTime? finalTime() {
    return null;
  }
}

//a date picker model
class DatePickerModel extends CommonPickerModel {
  late DateTime maxTime;
  late DateTime minTime;

  DatePickerModel(
      {DateTime? currentTime,
      DateTime? maxTime,
      DateTime? minTime,
      LocaleType? locale})
      : super(locale: locale) {
    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970, 1, 1);

    currentTime = currentTime ?? DateTime.now();
    if (currentTime != null) {
      if (currentTime.compareTo(this.maxTime) > 0) {
        currentTime = this.maxTime;
      } else if (currentTime.compareTo(this.minTime) < 0) {
        currentTime = this.minTime;
      }
    }
    this.currentTime = currentTime;

    _fillLeftLists();
    _fillMiddleLists();
    _fillRightLists();
    int minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();
    _currentLeftIndex = (this.currentTime!.year - this.minTime.year);
    _currentMiddleIndex = (this.currentTime!.month - minMonth);
    _currentRightIndex = (this.currentTime!.day - minDay);
  }

  void _fillLeftLists() {
    this.leftList = List.generate(maxTime.year - minTime.year + 1, (int index) {
      // print('LEFT LIST... ${minTime.year + index}${_localeYear()}');
      return '${minTime.year + index}${_localeYear()}';
    });
  }

  int _maxMonthOfCurrentYear() {
    return currentTime?.year == maxTime.year ? maxTime.month : 12;
  }

  int _minMonthOfCurrentYear() {
    return currentTime?.year == minTime.year ? minTime.month : 1;
  }

  int _maxDayOfCurrentMonth() {
    int dayCount = calcDateCount(currentTime!.year, currentTime!.month);
    return currentTime?.year == maxTime.year &&
            currentTime?.month == maxTime.month
        ? maxTime.day
        : dayCount;
  }

  int _minDayOfCurrentMonth() {
    return currentTime?.year == minTime.year &&
            currentTime?.month == minTime.month
        ? minTime.day
        : 1;
  }

  void _fillMiddleLists() {
    int minMonth = _minMonthOfCurrentYear();
    int maxMonth = _maxMonthOfCurrentYear();

    this.middleList = List.generate(maxMonth - minMonth + 1, (int index) {
      return '${_localeMonth(minMonth + index)}';
    });
  }

  void _fillRightLists() {
    int maxDay = _maxDayOfCurrentMonth();
    int minDay = _minDayOfCurrentMonth();
    this.rightList = List.generate(maxDay - minDay + 1, (int index) {
      return '${minDay + index}${_localeDay()}';
    });
  }

  @override
  void setLeftIndex(int index) {
    super.setLeftIndex(index);
    //adjust middle
    int destYear = index + minTime.year;
    int minMonth = _minMonthOfCurrentYear();
    DateTime newTime;
    //change date time
    if (currentTime?.month == 2 && currentTime?.day == 29) {
      newTime = currentTime!.isUtc
          ? DateTime.utc(
              destYear,
              currentTime!.month,
              calcDateCount(destYear, 2),
            )
          : DateTime(
              destYear,
              currentTime!.month,
              calcDateCount(destYear, 2),
            );
    } else {
      newTime = currentTime!.isUtc
          ? DateTime.utc(
              destYear,
              currentTime!.month,
              currentTime!.day,
            )
          : DateTime(
              destYear,
              currentTime!.month,
              currentTime!.day,
            );
    }
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    _fillMiddleLists();
    _fillRightLists();
    minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();
    _currentMiddleIndex = currentTime!.month - minMonth;
    _currentRightIndex = currentTime!.day - minDay;
  }

  @override
  void setMiddleIndex(int index) {
    super.setMiddleIndex(index);
    //adjust right
    int minMonth = _minMonthOfCurrentYear();
    int destMonth = minMonth + index;
    DateTime newTime;
    //change date time
    int dayCount = calcDateCount(currentTime!.year, destMonth);
    newTime = currentTime!.isUtc
        ? DateTime.utc(
            currentTime!.year,
            destMonth,
            currentTime!.day <= dayCount ? currentTime!.day : dayCount,
          )
        : DateTime(
            currentTime!.year,
            destMonth,
            currentTime!.day <= dayCount ? currentTime!.day : dayCount,
          );
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    _fillRightLists();
    int minDay = _minDayOfCurrentMonth();
    _currentRightIndex = currentTime!.day - minDay;
  }

  @override
  void setRightIndex(int index) {
    super.setRightIndex(index);
    int minDay = _minDayOfCurrentMonth();
    currentTime = currentTime!.isUtc
        ? DateTime.utc(
            currentTime!.year,
            currentTime!.month,
            minDay + index,
          )
        : DateTime(
            currentTime!.year,
            currentTime!.month,
            minDay + index,
          );
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < leftList.length) {
      return leftList[index];
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < middleList.length) {
      return middleList[index];
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < rightList.length) {
      return rightList[index];
    } else {
      return null;
    }
  }

  String _localeYear() {
    if (locale == LocaleType.zh) {
      return '年';
    } else if (locale == LocaleType.ko) {
      return '년';
    } else {
      return '';
    }
  }

  String _localeMonth(int month) {
    if (locale == LocaleType.zh) {
      return '$month月';
    } else if (locale == LocaleType.ko) {
      return '$month월';
    } else {
      List monthStrings = i18nObjInLocale(locale)?['monthLong'];
      return monthStrings[month - 1];
    }
  }

  String _localeDay() {
    if (locale == LocaleType.zh) {
      return '日';
    } else if (locale == LocaleType.ko) {
      return '일';
    } else {
      return '';
    }
  }

  @override
  DateTime? finalTime() {
    return currentTime;
  }
}

//a time picker model
class TimePickerModel extends CommonPickerModel {
  late DateTime maxTime;
  late DateTime minTime;

  TimePickerModel({DateTime? currentTime, LocaleType? locale, DateTime? minTime, DateTime? maxTime})
      : super(locale: locale) {
    this.maxTime = maxTime ?? DateTime(2049, 12, 31, 23, 59, 59);
    this.minTime = minTime ?? DateTime(1970, 1, 1, 0, 0, 0);

    currentTime = currentTime ?? DateTime.now();
    if (currentTime != null) {
      if (currentTime.compareTo(this.maxTime) > 0) {
        currentTime = this.maxTime;
      } else if (currentTime.compareTo(this.minTime) < 0) {
        currentTime = this.minTime;
      }
    }
    this.currentTime = currentTime;

    _currentLeftIndex = this.currentTime!.hour - _minHour();
    _currentMiddleIndex = this.currentTime!.minute - _minMinute();
    _currentRightIndex = this.currentTime!.second - _minSecond();
  }

  int _minHour() {
    return _isSameDay() ? minTime.hour : 0;
  }

  int _maxHour() {
    return _isSameDay() ? maxTime.hour : 23;
  }

  int _minMinute() {
    if (_isSameDay() && _currentLeftIndex + _minHour() == minTime.hour) {
      return minTime.minute;
    }
    return 0;
  }

  int _maxMinute() {
    if (_isSameDay() && _currentLeftIndex + _minHour() == maxTime.hour) {
      return maxTime.minute;
    }
    return 59;
  }

  int _minSecond() {
    if (_isSameDay() && _currentLeftIndex + _minHour() == minTime.hour &&
        _currentMiddleIndex + _minMinute() == minTime.minute) {
      return minTime.second;
    }
    return 0;
  }

  int _maxSecond() {
    if (_isSameDay() && _currentLeftIndex + _minHour() == maxTime.hour &&
        _currentMiddleIndex + _minMinute() == maxTime.minute) {
      return maxTime.second;
    }
    return 59;
  }

  bool _isSameDay() {
    return minTime.year == maxTime.year &&
        minTime.month == maxTime.month &&
        minTime.day == maxTime.day;
  }

  int _hourCount() {
    return _maxHour() - _minHour() + 1;
  }

  int _minuteCount() {
    return _maxMinute() - _minMinute() + 1;
  }

  int _secondCount() {
    return _maxSecond() - _minSecond() + 1;
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < _hourCount()) {
      return digits(_minHour() + index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < _minuteCount()) {
      return digits(_minMinute() + index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < _secondCount()) {
      return digits(_minSecond() + index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return ":";
  }

  @override
  String rightDivider() {
    return ":";
  }

  @override
  DateTime finalTime() {
    int hour = _currentLeftIndex + _minHour();
    int minute = _currentMiddleIndex + _minMinute();
    int second = _currentRightIndex + _minSecond();
    return currentTime!.isUtc
        ? DateTime.utc(currentTime!.year, currentTime!.month, currentTime!.day,
            hour, minute, second)
        : DateTime(currentTime!.year, currentTime!.month, currentTime!.day,
            hour, minute, second);
  }
}

//a date&time picker model
class DateTimePickerModel extends CommonPickerModel {
  late DateTime maxTime;
  late DateTime minTime;
  late List<String> _leftList;

  DateTimePickerModel({DateTime? currentTime, LocaleType? locale, DateTime? minTime, DateTime? maxTime})
      : super(locale: locale) {
    this.maxTime = maxTime ?? DateTime(2049, 12, 31, 23, 59, 59);
    this.minTime = minTime ?? DateTime(1970, 1, 1, 0, 0, 0);

    currentTime = currentTime ?? DateTime.now();
    if (currentTime != null) {
      if (currentTime.compareTo(this.maxTime) > 0) {
        currentTime = this.maxTime;
      } else if (currentTime.compareTo(this.minTime) < 0) {
        currentTime = this.minTime;
      }
    }
    this.currentTime = currentTime;

    _fillLeftLists();
    _currentLeftIndex = this.currentTime!.difference(this.minTime).inDays;
    _currentMiddleIndex = this.currentTime!.hour - _minHour();
    _currentRightIndex = this.currentTime!.minute - _minMinute();
  }

  void _fillLeftLists() {
    int totalDays = maxTime.difference(minTime).inDays;
    this._leftList = List.generate(totalDays + 1, (int index) {
      DateTime time = minTime.add(Duration(days: index));
      return formatDate(time, [ymdw], locale);
    });
  }

  int _dayCount() {
    return _leftList.length;
  }

  DateTime _currentDay() {
    return minTime.add(Duration(days: _currentLeftIndex));
  }

  bool _isFirstDay() {
    return _currentLeftIndex == 0;
  }

  bool _isLastDay() {
    return _currentLeftIndex == _dayCount() - 1;
  }

  int _minHour() {
    if (_isFirstDay()) return minTime.hour;
    return 0;
  }

  int _maxHour() {
    if (_isLastDay()) return maxTime.hour;
    return 23;
  }

  int _minMinute() {
    if (_isFirstDay() && _currentMiddleIndex + _minHour() == minTime.hour) {
      return minTime.minute;
    }
    if (_isLastDay() && _currentMiddleIndex + _minHour() == maxTime.hour) {
      return 0;
    }
    return 0;
  }

  int _maxMinute() {
    if (_isLastDay() && _currentMiddleIndex + _minHour() == maxTime.hour) {
      return maxTime.minute;
    }
    return 59;
  }

  int _hourCount() {
    return _maxHour() - _minHour() + 1;
  }

  int _minuteCount() {
    return _maxMinute() - _minMinute() + 1;
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < _dayCount()) {
      return _leftList[index];
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < _hourCount()) {
      return digits(_minHour() + index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < _minuteCount()) {
      return digits(_minMinute() + index, 2);
    } else {
      return null;
    }
  }

  @override
  DateTime finalTime() {
    DateTime day = _currentDay();
    int hour = _currentMiddleIndex + _minHour();
    int minute = _currentRightIndex + _minMinute();
    return currentTime!.isUtc
        ? DateTime.utc(day.year, day.month, day.day, hour, minute)
        : DateTime(day.year, day.month, day.day, hour, minute);
  }

  @override
  List<int> layoutProportions() {
    return [3, 1, 1];
  }

  @override
  String rightDivider() {
    return ':';
  }
}

//a date&time picker model
class DateTimeWithStartPickerModel extends CommonPickerModel {
  late  DateTime maxTime;
   late DateTime minTime;
   late DateTime? currentTime;

  DateTimeWithStartPickerModel(
      {DateTime? currentTime, LocaleType? locale, DateTime? minTime, DateTime? maxTime})
      : super(locale: locale) {
    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970, 1, 1);

    this.currentTime = currentTime ?? DateTime.now();
    if (currentTime != null) {
      if (currentTime.compareTo(this.maxTime) > 0) {
        currentTime = this.maxTime;
      } else if (currentTime.compareTo(this.minTime) < 0) {
        currentTime = this.minTime;
      }
    }
    _fillLeftLists();
    _currentLeftIndex = this.currentTime!.difference(this.minTime).inDays;
    _currentMiddleIndex = this.currentTime!.hour;
    _currentRightIndex = this.currentTime!.minute;
  }

  void _fillLeftLists() {
    this.leftList =
        List.generate(maxTime.difference(minTime).inDays, (int index) {
      // print('LEFT LIST... ${minTime.year + index}${_localeYear()}');
      DateTime time = minTime.add(new Duration(days: index));
      return formatDate(time, [yyyy,"年",mm,"月",dd,"日"], locale);
    });
  }

  @override
  String? leftStringAtIndex(int index) {
//    DateTime time = currentTime.add(Duration(days: index));
//    return formatDate(time, [ymdw], locale);
    if (index >= 0 && index < leftList.length) {
      return leftList[index];
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  DateTime? finalTime() {
    DateTime time = currentTime!.add(Duration(days: _currentLeftIndex));
    return currentTime!.isUtc
        ? DateTime.utc(time.year, time.month, time.day, _currentMiddleIndex,
            _currentRightIndex)
        : DateTime(time.year, time.month, time.day, _currentMiddleIndex,
            _currentRightIndex);
  }

  @override
  List<int> layoutProportions() {
    return [3, 1, 1];
  }

  @override
  String rightDivider() {
    return ':';
  }
}

//a date picker model
class MonthPickerModel extends CommonPickerModel {
  late DateTime maxTime;
  late DateTime minTime;

  MonthPickerModel(
      {DateTime? currentTime,
        DateTime? maxTime,
        DateTime? minTime,
        LocaleType? locale})
      : super(locale: locale) {
    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970, 1, 1);

    currentTime = currentTime ?? DateTime.now();
    if (currentTime != null) {
      if (currentTime.compareTo(this.maxTime) > 0) {
        currentTime = this.maxTime;
      } else if (currentTime.compareTo(this.minTime) < 0) {
        currentTime = this.minTime;
      }
    }
    this.currentTime = currentTime;

    _fillLeftLists();
    _fillMiddleLists();
    _fillRightLists();
    int minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();
    _currentLeftIndex = (this.currentTime!.year - this.minTime.year);
    _currentMiddleIndex = (this.currentTime!.month - minMonth);
    _currentRightIndex = (this.currentTime!.day - minDay);
  }

  void _fillLeftLists() {
    this.leftList = List.generate(maxTime.year - minTime.year + 1, (int index) {
      // print('LEFT LIST... ${minTime.year + index}${_localeYear()}');
      return '${minTime.year + index}${_localeYear()}';
    });
  }

  int _maxMonthOfCurrentYear() {
    return currentTime?.year == maxTime.year ? maxTime.month : 12;
  }

  int _minMonthOfCurrentYear() {
    return currentTime?.year == minTime.year ? minTime.month : 1;
  }

  int _maxDayOfCurrentMonth() {
    int dayCount = calcDateCount(currentTime!.year, currentTime!.month);
    return currentTime?.year == maxTime.year &&
        currentTime?.month == maxTime.month
        ? maxTime.day
        : dayCount;
  }

  int _minDayOfCurrentMonth() {
    return currentTime?.year == minTime.year &&
        currentTime?.month == minTime.month
        ? minTime.day
        : 1;
  }

  void _fillMiddleLists() {
    int minMonth = _minMonthOfCurrentYear();
    int maxMonth = _maxMonthOfCurrentYear();

    this.middleList = List.generate(maxMonth - minMonth + 1, (int index) {
      return '${_localeMonth(minMonth + index)}';
    });
  }

  void _fillRightLists() {
    int maxDay = _maxDayOfCurrentMonth();
    int minDay = _minDayOfCurrentMonth();
    this.rightList = List.generate(maxDay - minDay + 1, (int index) {
      return '${minDay + index}${_localeDay()}';
    });
  }

  @override
  void setLeftIndex(int index) {
    super.setLeftIndex(index);
    //adjust middle
    int destYear = index + minTime.year;
    int minMonth = _minMonthOfCurrentYear();
    DateTime newTime;
    //change date time
    if (currentTime?.month == 2 && currentTime?.day == 29) {
      newTime = currentTime!.isUtc
          ? DateTime.utc(
        destYear,
        currentTime!.month,
        calcDateCount(destYear, 2),
      )
          : DateTime(
        destYear,
        currentTime!.month,
        calcDateCount(destYear, 2),
      );
    } else {
      newTime = currentTime!.isUtc
          ? DateTime.utc(
        destYear,
        currentTime!.month,
        currentTime!.day,
      )
          : DateTime(
        destYear,
        currentTime!.month,
        currentTime!.day,
      );
    }
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    _fillMiddleLists();
    _fillRightLists();
    minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();
    _currentMiddleIndex = currentTime!.month - minMonth;
    _currentRightIndex = currentTime!.day - minDay;
  }

  @override
  void setMiddleIndex(int index) {
    super.setMiddleIndex(index);
    //adjust right
    int minMonth = _minMonthOfCurrentYear();
    int destMonth = minMonth + index;
    DateTime newTime;
    //change date time
    int dayCount = calcDateCount(currentTime!.year, destMonth);
    newTime = currentTime!.isUtc
        ? DateTime.utc(
      currentTime!.year,
      destMonth,
      currentTime!.day <= dayCount ? currentTime!.day : dayCount,
    )
        : DateTime(
      currentTime!.year,
      destMonth,
      currentTime!.day <= dayCount ? currentTime!.day : dayCount,
    );
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    _fillRightLists();
    int minDay = _minDayOfCurrentMonth();
    _currentRightIndex = currentTime!.day - minDay;
  }

  @override
  void setRightIndex(int index) {
    super.setRightIndex(index);
    int minDay = _minDayOfCurrentMonth();
    currentTime = currentTime!.isUtc
        ? DateTime.utc(
      currentTime!.year,
      currentTime!.month,
      minDay + index,
    )
        : DateTime(
      currentTime!.year,
      currentTime!.month,
      minDay + index,
    );
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < leftList.length) {
      return leftList[index];
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < middleList.length) {
      return middleList[index];
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < rightList.length) {
      return rightList[index];
    } else {
      return null;
    }
  }

  String _localeYear() {
    if (locale == LocaleType.zh) {
      return '年';
    } else if (locale == LocaleType.ko) {
      return '년';
    } else {
      return '';
    }
  }

  String _localeMonth(int month) {
    if (locale == LocaleType.zh) {
      return '$month月';
    } else if (locale == LocaleType.ko) {
      return '$month월';
    } else {
      List monthStrings = i18nObjInLocale(locale)?['monthLong'];
      return monthStrings[month - 1];
    }
  }

  String _localeDay() {
    if (locale == LocaleType.zh) {
      return '日';
    } else if (locale == LocaleType.ko) {
      return '일';
    } else {
      return '';
    }
  }

  @override
  DateTime? finalTime() {
    return currentTime;
  }
  @override
  List<int> layoutProportions() {
    return [100, 100, 1];
  }
}


