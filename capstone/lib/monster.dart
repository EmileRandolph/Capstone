

class Monster{
  int health = 100;
  int currentHealth = 100;
  String imageName = "temp_dragpn.jpg";
  Monster(this.currentHealth, this.health, this.imageName);

    Map toJson()=>{
    '"health"': health,
    '"currentHealth"': currentHealth,
    '"imageName"': '"$imageName"'
  };

  factory Monster.fromJson(dynamic json) {
    return Monster(json['currentHealth'] as int, json['health'] as int, json['imageName'] as String);
  }

  int getHealth(){
    return health;
  }

  void setHealth(int num){
    health = num;
  }

  int getCurrentHealth(){
    return currentHealth;
  }

  void setCurrentHealth(int num){
    currentHealth = num;
  }

  String getimageName(){
    return imageName;
  }

  void setImageName(String name){
    imageName = name;
  }

}