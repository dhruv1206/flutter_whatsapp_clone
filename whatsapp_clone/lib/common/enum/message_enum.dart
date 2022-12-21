enum MessageEnum {
  text("text"),
  image("image"),
  audio("audio"),
  video("video"),
  gif("gif");

  const MessageEnum(this.type);
  final String type;
}

extension ConvertEnum on String {
  MessageEnum toEnum() {
    switch (this) {
      case "audio":
        return MessageEnum.audio;
      case "text":
        return MessageEnum.text;
      case "video":
        return MessageEnum.video;
      case "image":
        return MessageEnum.image;
      case "gif":
        return MessageEnum.gif;
      default:
        return MessageEnum.text;
    }
  }
}
