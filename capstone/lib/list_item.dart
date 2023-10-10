class listItem{
var title;
var description;
var weight;
  listItem(String title, int weight){
    this.title = title;
    this.weight = weight;
  }

  listItem.withDescription(String title, String description, int weight){
    this.title = title;
    this.description = description;
    this.weight = weight;
  }

  Map toJson()=>{
    'title':title,
    'description': description,
    'weight':weight
  };

  factory listItem.fromJson(dynamic json) {
    return listItem.withDescription(json['title'] as String, json['description'] as String, json['weight'] as int);
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
}