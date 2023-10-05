class listItem{
var title;
var description;
var weight;
  listItem(String title, int weight){
    this.title = title;
    this.weight = weight;
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