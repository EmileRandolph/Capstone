import 'package:flutter/material.dart';

class Monster{
  Image picture = Image(image: NetworkImage("capstone\\lib\\images\\temp_dragon.jfif"));
  int health = 0;

  Monster(Image image, int health){
    this.health = health;
    picture = image;
  }
  void setPicture(Image image){
    picture = image;
  }

  Image getPicture(){
    return picture;
  }

  int getHealth(){
    return health;
  }

  void setHealth(int num){
    health = num;
  }

}