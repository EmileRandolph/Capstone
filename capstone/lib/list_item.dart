class listItem{
var title;
var description;
var weight;
bool done = false;
  listItem(String title, int weight, bool done){
    this.title = title;
    this.weight = weight;
    this.done = done;
  }

  listItem.withDescription(String title, String description, int weight, bool done){
    this.title = title;
    this.description = description;
    this.weight = weight;
    this.done = done;
  }

  Map toJson()=>{
    '"title"':"\"$title\"",
    '"description"': "\"$description\"",
    '"weight"':weight,
    '"done"':done
  };

  factory listItem.fromJson(dynamic json) {
    return listItem.withDescription(json['title'] as String, json['description'] as String, json['weight'] as int, json['done']as bool);
  }

  void setDescription(String description){
    this.description = description;
  }

  String getDescription(){
    return description;
  }
  void setTitle(String title){
    this.title = title;
  }

  String getTitle(){
    return title;
  }
    void setWeight(String weight){
    this.weight = weight;
  }

  int getWeight(){
    return weight;
  }
  bool getDone(){
    return done;
  }
  void setDone(bool done){
    this.done = done;
  }
}