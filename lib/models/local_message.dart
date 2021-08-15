class LocalMessage {
  String chatId;
  int _id;
  int get id => _id;
  String sender;
  String receiver;
  String message;
  String receivedAt;

  LocalMessage(this.chatId, this.sender, this.message, this.receivedAt, this.receiver);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {

      'chat_id': chatId,
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'received_at': receivedAt
    };

    if (_id != null) {
      map['_id'] = _id;
    }
    return map;
  }

  factory LocalMessage.fromMap(Map<String, dynamic> json) {
    final localMessage = LocalMessage(
        json['chat_id'], json['sender'], json['message'], json['receivedAt'], json['receiver']);
    localMessage._id = json['id'];
    return localMessage;
  }
}