
void main() {
  Duck().canFly();
}

class Animal {

  void move() {
    print('changed position');
  }
}

mixin Fish {
 void canSwim() {
   print('changing position by swimming');
 }
}

mixin Bird {
  void canFly() {
    print('changing position by flying');
  }
}

class Duck with Fish, Bird {

}