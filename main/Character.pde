class Character{

  float posX,posY,sizeX,sizeY;
  int life, maxLife;
  float easing;
  Character characterToFollow, characterToAvoid;
  float followingDistance, avoidDistance;
  PImage sprite;
  
  int sign = 1;
  int wanderCommit = 0;
  int wanderX = -1, wanderY = 0;
  
  
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
  
  void Movement(boolean mode, float deltaTime) {
    if(mode) { //Mouse mode
      MoveToCursor(deltaTime);
    } else { //Keyboard mode
      MoveKeyboard(deltaTime);
    }
  }
  
  void MoveToCursor(float deltaTime){
    this.characterToFollow.posX = mouseX;
    this.characterToFollow.posY = mouseY;
    this.Follow(deltaTime, 0.0f, 0.0f);
  }
  
  void MoveKeyboard(float deltaTime) {
    float xSpeed = deltaTime * easing * int(moveKeys[1]) - deltaTime * easing * int(moveKeys[0]);
    float ySpeed = deltaTime * easing * int(moveKeys[3]) - deltaTime * easing * int(moveKeys[2]);
    float modulus = sqrt(xSpeed * xSpeed + ySpeed * ySpeed);
    if(xSpeed != 0.0f || ySpeed != 0.0f) {
      xSpeed = xSpeed/modulus;
      xSpeed *= 5.0f;
      ySpeed = ySpeed/modulus;
      ySpeed *= 5.0f;
    }
    this.posX = this.posX + xSpeed;
    this.posY = this.posY + ySpeed;
  }
  
  void Follow(float deltaTime, float distance, float increment) {
    
    easing += sign * deltaTime * increment;
    if(easing > MAX_SPEED || easing < 1.0f) sign *= -1;
    
    if((this.characterToFollow.posX - this.posX) * (this.characterToFollow.posX - this.posX) + 
      (this.characterToFollow.posY - this.posY) * (this.characterToFollow.posY - this.posY) >= 
      distance * distance) {
        
      float xDir = this.characterToFollow.posX - this.posX, yDir = this.characterToFollow.posY - this.posY;
      float modulus = sqrt(xDir * xDir + yDir * yDir);
      xDir /= modulus;
      yDir /= modulus;
      this.posX += xDir * deltaTime * this.easing;
      this.posY += yDir * deltaTime * this.easing;
    }
  }
  
  void Draw() {
    image(this.sprite,this.posX - this.sizeX/2.0f, this.posY - this.sizeY/2.0f, this.sizeX,this.sizeY);
  }
  
  void Wander(float deltaTime) {
    if(++this.wanderCommit > WANDER_TIME) {
      this.wanderCommit = 0;
      this.wanderX = int(random(-1.5,1.5));
      this.wanderY = int(random(-1.5,1.5));
      if(this.wanderX == 0 && this.wanderY == 0) {
        if(int(random(2)) == 0) this.wanderX = 2 * int(random(2)) - 1;
        else this.wanderY = 2 * int(random(2)) - 1;
      }
    }
    this.posX += this.easing * deltaTime * this.wanderX;
    this.posY += this.easing * deltaTime * this.wanderY;
  }
  
  void posCheck() {
    if(this.posX - this.sizeX/2.0f < 0.0f) { this.posX = this.sizeX/2.0f; this.wanderX = 1; }
    else if(this.posX + this.sizeX/2.0f > width) { this.posX = width - this.sizeX/2.0f; this.wanderX = -1; }
    if(this.posY - this.sizeY/2.0f < 0.0f) { this.posY = this.sizeY/2.0f; this.wanderY = 1; }
    else if(this.posY + this.sizeY/2.0f > height) { this.posY = height - this.sizeY/2.0f; this.wanderX = -1; }
  }
  
}
