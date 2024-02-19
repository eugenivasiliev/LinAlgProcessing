final float FPS = 120;
final float SPEED = 5.0f;
final float INCREMENT = 0.01f;
final float MAX_SPEED = 2.5f;
final int MAX_ENEMIES = 100;
final int SPAWN_RATE = 100;
final int WANDER_TIME = 300;

int N = 0;
boolean mode = true; 
boolean start = false; 

int lastTime = 0;
float y = 0.0f;

boolean moveKeys[] = {false, false, false, false};

Character Rick, Morty1, Morty2;

void setup() {
  size(1280, 720); 
  frameRate(FPS);
  noStroke();
  Rick = new Character(0, 0, 50, 50, 3, 0.05f, null, null, 0, 0, "../Rick.png");
  Morty1 = new Character(100, -100, 50, 50, 3, 0.05f, null, null, 0, 0, "../Morty.png");
  Morty2 = new Character(200, -200, 50, 50, 3, 0.05f, null, null, 0, 0, "../Morty.png");
}

void draw() { 
  background(51);
  Rick.MoveToCursor();
  
}
