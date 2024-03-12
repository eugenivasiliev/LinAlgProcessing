class PowerUp{
  boolean collected;
  PImage sprite;
  float posX, posY;
  float sizeX, sizeY;
  PowerUp(String spritePath, float sX,float sY){
    collected = false;
    this.sprite = loadImage(spritePath);
    this.posX = random(0,width);
    this.posY = random(0,height);
    this.sizeX = sX;
    this.sizeY = sY;
  }
  void Draw(){
    if(!collected){
      image(this.sprite, this.posX - this.sizeX/2.0f, this.posY - this.sizeY/2.0f, this.sizeX,this.sizeY);
      if(
        (this.posX + this.sizeX > PC.posX && this.posY + this.sizeY > PC.posY) &&
        (this.posX < PC.posX +PC.sizeX && this.posY < PC.posY +PC.sizeY) 
      ){
        Activate(PC);
        collectedPowerUps++;
        collected = true;
      }
    }
  }
  void Activate(Character target){
  }
}

class Repelent extends PowerUp{
  Repelent(String spritePath, float sX,float sY){
    super(spritePath, sX, sY);
  }
  void Activate(Character target){
    for(int i = 0; i < Enemies.size(); i++) 
      Enemies.get(i).followingDistance*=1.25;;
  }
}

class Remover extends PowerUp{
  Remover(String spritePath, float sX,float sY){
    super(spritePath, sX, sY);
  }
  void Activate(Character target){
    Enemies.clear();
  }
}

class Teleporter extends PowerUp{
  Teleporter(String spritePath, float sX,float sY){
    super(spritePath, sX, sY);
  }
  void Activate(Character target){
    target.posX = random(0,width);
    target.posY = random(0,height);
  }
}
class Booster extends PowerUp{
  Booster(String spritePath, float sX,float sY){
    super(spritePath, sX, sY);
  }
  void Activate(Character target){
    target.speed*=1.5;
  }
}
class Healer extends PowerUp{
  Healer(String spritePath, float sX,float sY){
    super(spritePath, sX, sY);
  }
  void Activate(Character target){
    target.life = target.maxLife;
  }
}
