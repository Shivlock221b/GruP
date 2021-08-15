class Chat {

  String id;
  int count = 0;
  String name;
  bool isGroup = false;
  Map<String, dynamic> members = {};

  Chat(this.id, this.name, this.isGroup, this.count, this.members);

  toMap() {
    Map<String, dynamic> map = {

      'name': this.name,
      "isGroup": this.isGroup,
      "count": this.count,
      "members": this.members
    };
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory Chat.fromMap(Map<String, dynamic> json) => Chat(json['id'], json['name'], json['isGroup'] == 1, json['count'], json['members']);
}