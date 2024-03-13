Repelent repelent;
Remover remover;
Teleporter teleporter;
Booster booster;
Healer healer;
void GeneratePowerUps(){
  repelent = new Repelent("../Images/repelent.png",30,30);
  remover = new Remover("../Images/bomb.png",30,30);
  teleporter = new Teleporter("../Images/portalGun.png",30,30);
  booster = new Booster("../Images/wingedBoots.png",30,30);
  healer = new Healer("../Images/FAKit.png",30,30);
}
void DrawPowerUps(){
  repelent.DrawObstacle();
  remover.DrawObstacle();
  teleporter.DrawObstacle();
  booster.DrawObstacle();
  healer.DrawObstacle();
}
class PowerUp{
  boolean collected;
  PImage sprite;
  float posX, posY;
  float sizeX, sizeY;
  
  PowerUp(String spritePath, float sX,float sY){
    collected = false;
    this.sprite = loadImage(spritePath);
    this.posX = random(width);
    this.posY = random(height);
    this.sizeX = sX;
    this.sizeY = sY;
  }
  void DrawObstacle(){
    if(!collected){
      
      image(this.sprite, this.posX - this.sizeX/2.0f, this.posY - this.sizeY/2.0f, this.sizeX,this.sizeY);
      if(
        (this.posX + this.sizeX > PC.posX && this.posY + this.sizeY > PC.posY) &&
        (this.posX < PC.posX +PC.sizeX && this.posY < PC.posY +PC.sizeY) 
      ){
        Activate(PC);
        collectedPowerUps++;
        collected = true;
        score+=10;
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
