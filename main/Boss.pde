class Boss {
  float health;
  float posX, posY;
  float sizeX, sizeY;
  PImage sprite;
  
  void Appear() {
  }
  
  void Attack() {
  }
}

class Cannon {
  float minDist;
  float posX, posY;
  float sizeX, sizeY;
  int interactions;
  color c;
  boolean animation;
  boolean animationDone;
  float animationTimeX;
  float animationTimeY;
  float angle;
  float distFromCenter;
  Bullet b;
  
  Cannon(float _minDist, float _posX, float _posY, float _sizeX, float _sizeY, int _interactions, color _c, float _angle, float _distFromCenter) {
    this.minDist = _minDist;
    this.posX = _posX;
    this.posY = _posY;
    this.sizeX = _sizeX;
    this.sizeY = _sizeY;
    this.interactions = _interactions;
    this.c = _c;
    this.animation = false;
    this.animationDone = false;
    this.animationTimeX = 200.0f;
    this.animationTimeY = 100.0f;
    this.angle = _angle;
    this.distFromCenter = _distFromCenter;
  }
  void CheckInteract() {
    if(GetDistance(PC.posX, width/2.0f - cos(radians(angle)) * distFromCenter, PC.posY, height/2.0f - sin(radians(angle)) * distFromCenter) < minDist && keyPressed && key == 'q' && !animation && !animationDone) {
      animation = true;
      this.c = color(0, 255, 0);
    }
  }
  void Animation() {
    sizeX = sin(animationTimeX) * 1.5f + animationTimeX/2.0f;
    sizeY = sin(animationTimeY) * 1.5f + animationTimeY/2.0f;
    animationTimeX -= 0.25f;
    animationTimeY += 0.25f;
    if(animationTimeX < 135.0f) {
      animation = false;
      animationDone = true;
      sizeX = 50.0f;
      sizeY = 25.0f;
      b = new Bullet(0, 0, 30.0f, 30.0f, angle, distFromCenter, 10.0f);
    }
  }
  void Draw() {
    pushMatrix();
    translate(width/2.0f,height/2.0f);
    rotate(radians(angle));
    translate(-distFromCenter, 0);
    if(animation) Animation();
    else if(animationDone) {
      sizeX = 100.0f; 
      sizeY = 50.0f;
      b.Draw();
    }
    fill(c);
    circle(0, 0, sizeY);
    rect(0, - sizeY / 2.0f, sizeX, sizeY);
    popMatrix();
  }
}

class Bullet {
  float posX, posY;
  float sizeX, sizeY;
  float angle;
  float distFromCenter;
  float speed;
  Bullet(float _posX, float _posY, float _sizeX, float _sizeY, float _angle, float _distFromCenter, float _speed) {
    this.posX = _posX;
    this.posY = _posY;
    this.sizeX = _sizeX;
    this.sizeY = _sizeY;
    this.angle = _angle;
    this.distFromCenter = _distFromCenter;
    this.speed = _speed;
  }
  void Draw() {
    if(posX < distFromCenter) {
      fill(color(255, 0, 255));
      rect(posX - sizeX / 2.0f, posY - sizeY / 2.0f, sizeX, sizeY);
      posX += speed;
    }
  }
}
