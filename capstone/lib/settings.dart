class settings{
  bool darkMode = false;
  bool halloweenMode = false;
  bool openDyslexicfont = true;
  bool healMonster = false;
  bool notification = true;
  settings(this.darkMode, this.halloweenMode, this.openDyslexicfont, this.healMonster, this.notification);
  Map toJson()=>{
    '"darkMode"': darkMode,
    '"halloweenMode"': halloweenMode,
    '"openDyslexicfont"': openDyslexicfont,
    '"healMonster"': healMonster,
    '"notification"': notification
  };
// ignore: empty_constructor_bodies
settings.empty(){

}
  factory settings.fromJson(dynamic json) {
    return settings(json['darkMode'] as bool, json['halloweenMode'] as bool, json['openDyslexicfont'] as bool, json['healMonster'] as bool, json['notification'] as bool);
  }
}