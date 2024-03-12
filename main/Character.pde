class Character{

  float posX,posY,sizeX,sizeY;
  int life, maxLife;
  float speed, increment;
  float maxSpeed = 50;
  Character characterToFollow, characterToAvoid;
  float followingDistance, avoidDistance;
  PImage sprite;
  PImage[] lifebar = new PImage[4];
  //Main variables
  
  int sign = 1;
  int wanderCommit = 0;
  int wanderX = -1, wanderY = 0;
  //Wander variables
  
  
  Character(float initialPosX, float initialPosY, float initialSizeX, float initialSizeY, int lifeValue, float speedValue, float incrementValue, Character ctf, Character cta, float fd, float ad, String spritePath){ //Character constructor
    this.posX = initialPosX;
    this.posY = initialPosY;
    this.sizeX = initialSizeX;
    this.sizeY = initialSizeY;
    this.maxLife = lifeValue;
    this.life = this.maxLife;
    this.speed = speedValue;
    this.increment = incrementValue;
    this.characterToFollow = ctf;
    this.characterToAvoid = cta;
    this.followingDistance = fd;
    this.avoidDistance = ad;
    this.sprite = loadImage(spritePath);
    for (int i = 0; i < 4; i++)
      this.lifebar[i] = loadImage("../Images/lifebar"+i+".png");
  }
  
  void Follow() {
    if(this.characterToFollow != null){
      this.speed += this.sign * deltaTime * this.increment;
      if(this.speed > MAX_SPEED || this.speed < 1.0f) this.sign *= -1;
      //Accelerate/Decelerate when chasing the characters
    
      if((this.characterToFollow.posX - this.posX) * (this.characterToFollow.posX - this.posX) + 
        (this.characterToFollow.posY - this.posY) * (this.characterToFollow.posY - this.posY) >= 
        this.followingDistance * this.followingDistance + ERROR) { 
        //Check for the distance to be far enough to need movement, up to a small error.
        
        float xDir = this.characterToFollow.posX - this.posX, yDir = this.characterToFollow.posY - this.posY;
        float modulus = sqrt(xDir * xDir + yDir * yDir);
        modulus = GetDistance(this.characterToFollow.posX , this.posX, this.characterToFollow.posY,this.posY);
        xDir /= modulus;
        yDir /= modulus;
        if(this.characterToAvoid!=null){
          float newposX =  this.posX + xDir * deltaTime * this.speed;
          float newposY = this.posY + yDir * deltaTime * this.speed;
          
          float distanceBtwn = GetDistance(this.characterToAvoid.posX, newposX, this.characterToAvoid.posY, newposY);
          if(distanceBtwn>this.avoidDistance*1.1f){
            boolean canMove = true;
            for(int i = 0 ; i<(obstacles.size()) ; i++){
              Obstacle o = obstacles.get(i);
              if(
                (o.posX + o.sizeX > newposX && o.posY + o.sizeY > newposY) &&
                (o.posX < newposX + this.sizeX && o.posY < newposY +this.sizeY) 
              ){
                canMove = false;
              }
              if(canMove){
                this.posX = newposX;
                this.posY = newposY;
              }
            }
          }
          else if(distanceBtwn < this.avoidDistance*.9f){
            newposX = this.posX - xDir * deltaTime * this.speed;
            newposY = this.posY - yDir * deltaTime * this.speed;
            boolean canMove = true;
            for(int i = 0 ; i<(obstacles.size()) ; i++){
              Obstacle o = obstacles.get(i);
              if(
                (o.posX + o.sizeX > newposX && o.posY + o.sizeY > newposY) &&
                (o.posX < newposX + this.sizeX && o.posY < newposY +this.sizeY) 
              ){
                canMove = false;
              }
              if(canMove){
                this.posX = newposX;
                this.posY = newposY;
              }
            }
          }
        }
        else{
          float newposX = this.posX + xDir * deltaTime * this.speed;
          float newposY = this.posY + yDir * deltaTime * this.speed;
          boolean canMove = true;
          for(int i = 0 ; i<(obstacles.size()) ; i++){
            Obstacle o = obstacles.get(i);
            if(
              (o.posX + o.sizeX > newposX && o.posY + o.sizeY > newposY) &&
              (o.posX < newposX + this.sizeX && o.posY < newposY +this.sizeY) 
            ){
              canMove = false;
            }
          }
          if(canMove){
            this.posX = newposX;
            this.posY = newposY;
          }
        }
      }
    }
  }
  
  void Draw() {
    image(this.sprite, this.posX - this.sizeX/2.0f, this.posY - this.sizeY/2.0f, this.sizeX,this.sizeY);
    image(lifebar[life], this.posX - this.sizeX/2.0f, this.posY - this.sizeY, this.sizeX,this.sizeY);
    //Draw the character
  }
  void increaseSpeed(){
    this.speed += this.increment;
    this.speed%=this.maxSpeed;
  }
  
  void Wander() {
  
    if(++this.wanderCommit > WANDER_TIME) {
      this.wanderCommit = 0;
      this.wanderX = int(random(-1.5,1.5));
      this.wanderY = int(random(-1.5,1.5));
      if(this.wanderX == 0 && this.wanderY == 0) {
        if(int(random(2)) == 0) this.wanderX = 2 * int(random(2)) - 1;
        else this.wanderY = 2 * int(random(2)) - 1;
      }
      //Set a random wander direction every some frames
    }
    float newposX = this.posX += this.speed * deltaTime * this.wanderX;
    float newposY = this.posY += this.speed * deltaTime * this.wanderY;
    boolean canMove = true;
    //col·lisions amb obstacles
    for(int i = 0 ; i<(obstacles.size()) ; i++){
      Obstacle o = obstacles.get(i);
       if(
        (o.posX + o.sizeX > this.posX && o.posY + o.sizeY > this.posY) &&
        (o.posX < this.posX + this.sizeX && o.posY < this.posY +this.sizeY) 
      ){
        canMove = false;
      }
    }
    if(canMove){
      this.posX = newposX;
      this.posY = newposY;
      increaseSpeed();
    }
    //Wander in the random direction
  }
  
  void posCheck() {
    if(this.posX - this.sizeX/2.0f < 0.0f + ERROR) { this.posX = this.sizeX/2.0f; this.wanderX = 1; }
    else if(this.posX + this.sizeX/2.0f > width - ERROR) { this.posX = width - this.sizeX/2.0f; this.wanderX = -1; }
    if(this.posY - this.sizeY/2.0f < 0.0f + ERROR) { this.posY = this.sizeY/2.0f; this.wanderY = 1; }
    else if(this.posY + this.sizeY/2.0f > height - ERROR) { this.posY = height - this.sizeY/2.0f; this.wanderX = -1; }
    //Make sure the position is kept in bounds (up to an error), and turn around the wanderer if needed
  }
  
}


//PlayerCharacter class, to add the movement requirements
class PlayerCharacter extends Character {
  PlayerCharacter(float initialPosX, float initialPosY, float initialSizeX, float initialSizeY, int lifeValue, float speedValue, float incrementValue, Character ctf, Character cta, float fd, float ad, String spritePath) {
    super(initialPosX, initialPosY, initialSizeX, initialSizeY, lifeValue, speedValue, incrementValue, ctf, cta, fd, ad, spritePath); 
  }
  
  void Movement(boolean mode) { //Filter the movement wrt mode
    if(mode) { //Mouse mode
      MoveToCursor();
    } else { //Keyboard mode
      MoveKeyboard();
    }
  }
  
  void MoveToCursor(){
    this.characterToFollow.posX = mouseX;
    this.characterToFollow.posY = mouseY;
    this.Follow();
    //Follow an invisible character in the mouse position
  }
  
  void MoveKeyboard() {
    float xSpeed = deltaTime * this.speed * int(moveKeys[1]) - deltaTime * this.speed * int(moveKeys[0]);
    float ySpeed = deltaTime * this.speed * int(moveKeys[3]) - deltaTime * this.speed * int(moveKeys[2]);
    float modulus = sqrt(xSpeed * xSpeed + ySpeed * ySpeed);
    if(xSpeed != 0.0f || ySpeed != 0.0f) {
      xSpeed = xSpeed/modulus;
      xSpeed *= 5.0f;
      ySpeed = ySpeed/modulus;
      ySpeed *= 5.0f;
    }
    float newposX = this.posX + xSpeed;
    float newposY = this.posY + ySpeed;
    boolean canMove = true;
    //Move with keys
    for(int i = 0 ; i<(obstacles.size()) ; i++){
      Obstacle o = obstacles.get(i);
       if(
        (o.posX + o.sizeX > this.posX && o.posY + o.sizeY > this.posY) &&
        (o.posX < this.posX + this.sizeX && o.posY < this.posY +this.sizeY) 
      ){
        canMove = false;
      }
    }
    if(canMove){
      this.posX = newposX;
      this.posY = newposY;
      increaseSpeed();
    }
  }
  
}
