class Character{

  float posX,posY,sizeX,sizeY;
  int life, maxLife;
  float easing;
  Character characterToFollow, characterToAvoid;
  float followingDistance, avoidDistance;
  PImage sprite;
  
  
  Character(float initialPosX, float initialPosY, float initialSizeX, float initialSizeY, int lifeValue, float easingValue, Character ctf, Character cta, float fd, float ad, String spritePath){
    this.posX = initialPosX;
    this.posY = initialPosY;
    this.sizeX = initialSizeX;
    this.sizeY = initialSizeY;
    this.maxLife = lifeValue;
    this.life = this.maxLife;
    this.easing = easingValue;
    this.characterToFollow = ctf;
    this.characterToAvoid = cta;
    this.followingDistance = fd;
    this.avoidDistance = ad;
    this.sprite = loadImage(spritePath);
  }
  void MoveToCursor(){
    this.posX += (mouseX - this.posX) * this.easing;
    this.posY += (mouseY - this.posY) * this.easing;
    image(this.sprite,this.posX, this.posY, this.sizeX,this.sizeY);
  }
  void AutoMove(){
    //float newPosX = this.posX + (this.characterToFollow.posX - this.posX) * this.easing;
    //float newPosY = this.posY + (this.characterToFollow.posY - this.posY) * this.easing; 
    
  }
}
