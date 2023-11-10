// ignore_for_file: camel_case_types

class listItem{
String title;
String description = "";
int weight;
bool done = false;
  listItem(this.title, this.weight, this.done);

  listItem.withDescription(this.title, this.description, this.weight, this.done);

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
    void setWeight(int weight){
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