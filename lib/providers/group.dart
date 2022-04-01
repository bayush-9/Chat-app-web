import 'package:flutter/cupertino.dart';

class Group {
  String id;
  String name;
  Group(this.id, this.name);
}

class GroupId {
  String id;
  GroupId(this.id);
}

class Groups with ChangeNotifier {
  Group _activeGroup = new Group('', '');

  List<GroupId> _totalGroups = [];

  void setTotalGroups(List<GroupId> k) {
    _totalGroups = k;
    notifyListeners();
  }

  List<GroupId> get groupsList {
    return _totalGroups;
  }

  Group get activeGroup {
    return _activeGroup;
  }

  void setActiveGroup(String id, String name) {
    if (id == null) {
      return;
    }
    _activeGroup.id = id;
    _activeGroup.name = name;
    print(id);
    notifyListeners();
  }

  String get activeGroupId {
    return _activeGroup.id;
  }

  void unactivateGroup() {
    _activeGroup.name = "";
    _activeGroup.id = "";
    notifyListeners();
  }
}
