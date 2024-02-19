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

Character MouseCursor;

Character PC, NPC1, NPC2;

int spawnRate = 0;
ArrayList<Character> Enemies = new ArrayList<Character>();

void setup() {
  size(1800, 900); 
  frameRate(FPS);
  noStroke();
  printStartScreen();
  
  MouseCursor = new Character(mouseX, mouseY, 0, 0, 0, 0, null, null, 0, 0, "../Rick.png");
  
  PC = new Character(width/2.0f, height/2.0f, 50, 50, 3, 5.0f, MouseCursor, null, 0, 0, "../Rick.png");
  NPC1 = new Character(width/2.0f, height/2.0f, 50, 50, 3, 5.0f, PC, null, 0, 0, "../Morty.png");
  NPC2 = new Character(width/2.0f, height/2.0f, 50, 50, 3, 5.0f, NPC1, null, 0, 0, "../Morty.png");
}

void draw() { 
  if(!start) return;
  
  
  float deltaTime = deltaTime();
  
  if(Enemies.size() < N && ++spawnRate > SPAWN_RATE) { 
    Enemies.add(new Character(0, random(0, height), 50.0f, 50.0f, 3, 2.5f, NPC2, null, 0, 20.0f, "../CROMULON.png"));
    spawnRate = 0;
  }
  
  background(0);
  PC.Movement(mode, deltaTime);
  PC.posCheck();
  PC.Draw();
  NPC1.Follow(deltaTime, 100.0f, 0.0f);
  NPC1.posCheck();
  NPC1.Draw();
  NPC2.Follow(deltaTime, 100.0f, 0.0f);
  NPC2.posCheck();
  NPC2.Draw();
  
  for(int i = 0; i < Enemies.size(); i++) {
    Character Enemy = Enemies.get(i);
    if(i < (Enemies.size()+1)/2) Enemy.Follow(deltaTime, 0.0f, INCREMENT);
    else Enemy.Wander(deltaTime);
    Enemy.posCheck();
    Enemy.Draw();
  }
  
}

void keyPressed() {
  if(key == LEFT || key == 'a' || key == 'A') moveKeys[0] = true;
  if(key == RIGHT || key == 'd' || key == 'D') moveKeys[1] = true;
  if(key == UP || key == 'w' || key == 'W') moveKeys[2] = true;
  if(key == DOWN || key == 's' || key == 'S') moveKeys[3] = true;
}

void keyReleased() {
  if(!start) {
    String nums = "0123456789";
    if(nums.indexOf(key) != -1) {
      N *= 10;
      N += key - '0';
      if(N > MAX_ENEMIES) N = MAX_ENEMIES;
      printStartScreen();
    } else if(key == BACKSPACE) {
      N = 0;
      printStartScreen();
    } else if(key == 'm' || key == 'M') {
      mode = !mode;
      printStartScreen();
    } else if(key == ENTER) {
      start = true;
      return;
    }
  }
  if(key == LEFT || key == 'a' || key == 'A') moveKeys[0] = false;
  if(key == RIGHT || key == 'd' || key == 'D') moveKeys[1] = false;
  if(key == UP || key == 'w' || key == 'W') moveKeys[2] = false;
  if(key == DOWN || key == 's' || key == 'S') moveKeys[3] = false;
  return;
}

void printStartScreen() {
  background(0);
  textSize(100);
  text(N, 100, 200);
  textSize(50);
  if(mode) {
    text("Toggle mode with (M): MOUSE", 100, 300);
  } else {
    text("Toggle mode with (M): KEYBOARD", 100, 300);
  }
  text("Press (ENTER) to start.\nPress (BACKSPACE) to reset the enemies.", 100, 500);
}

float deltaTime() {
  int delta;
  float deltaTime;
  delta = millis() - lastTime;
  lastTime = millis();
  deltaTime = delta*FPS/1000.0f;
  return deltaTime;
}
