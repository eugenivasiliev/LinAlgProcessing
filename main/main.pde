import processing.sound.*;
SoundFile bgMusic;

final float FPS = 60;
final float SPEED = 5.0f;
final float INCREMENT = 0.01f;
final float MAX_SPEED = 2.5f;
final int MAX_ENEMIES = 100;
final int SPAWN_RATE = 100;
final int WANDER_TIME = 300;
final float ERROR = 1.0f;
final float timeToBeat = 400;
float countdown;
int lifes = 3;
int score = 0; 
int collectedPowerUps = 0;
//Constants


float deltaTime;
//Make deltaTime publicly available for all characters


int N = 0;
boolean mode = true; 
boolean start = false; 
boolean bossScreen = false;
//Start variables

int lastTime = 0;
float y = 0.0f;

boolean moveKeys[] = {false, false, false, false};
//Keyboard movement

Character MouseCursor;
PlayerCharacter PC;
Character NPC1, NPC2;
int spawnRate = 0;
ArrayList<Character> Enemies = new ArrayList<Character>();
ArrayList<Cannon> cannons = new ArrayList<Cannon>();
//Characters

void StartGame(){
  Enemies.clear();
  MouseCursor = new Character(mouseX, mouseY, 0, 0, 0, 0, 0.0f, null, null, 0, 0, "../Images/Rick.png");
  PC = new PlayerCharacter(width/2.0f, height/2.0f, 50, 50, 3, 5.0f, 0.0f, MouseCursor, null, 0, 0, "../Images/Rick.png");
  NPC1 = new Character(random(width), random(height), 50, 50, 3, 5.0f, 0.0f, null, null, 100.0f, 0, "../Images/Morty.png");
  NPC2 = new Character(random(width), random(height), 50, 50, 3, 5.0f, 0.0f, null, null, 100.0f, 0, "../Images/Morty.png");
  start = true;
  countdown = timeToBeat;
  GenerateObstacles();
  GeneratePowerUps();
  bgMusic.stop();
  bgMusic = new SoundFile(this,"../AudioFiles/level.mp3");
  bgMusic.loop();
      
}
void setup() {
  size(1800, 900); 
  frameRate(FPS);
  noStroke();
  bgMusic = new SoundFile(this,"../AudioFiles/R&M-theme.mp3");
  bgMusic.loop();
  printStartScreen();
  
}
float GetDistance(float X1, float X2, float Y1, float Y2){
  float c1 = X1-X2;
  float c2 = Y1-Y2;
  return sqrt((c1*c1)+(c2*c2));
}
void draw() {
  
  
  
  
  //fin collisiones
  
  if(!start) return;
  
    
  
    
  //Only update when started
  
  deltaTime = deltaTime();
  //Set deltaTime once to avoid recomputation
  
  if(bossScreen) {
    background(0);
    if(cannons.size() < 6) {
      for(int i = 0; i < 6; i++) {
        cannons.add(new Cannon(30.0f, 0.0f, 0.0f, 100.0f, 50.0f, 1, color(0, 0, 255), i * 60.0f, 300.0f));
      }
    }
    fill(color(255, 0, 0));
    rect(width / 2.0f - 50.0f, height / 2.0f - 50.0f, 100.0f, 100.0f);
    PC.Movement(mode);
    PC.posCheck();
    PC.Draw();
    boolean defeated = true;
    for(int i = 0; i < 6; i++) {
      if(cannons.get(i).animationDone) {
        defeated = false;
      }
    }
    if(defeated) {
      background(0);
      textSize(50);
      text("You win!", 40, 40); 
      while(!keyPressed);
      exit();
    }
    return;
  }
  
  if(Enemies.size() < N && ++spawnRate > SPAWN_RATE) { 
    Enemies.add(new Character(0, random(0, height), 50.0f, 50.0f, 3, 2.5f, INCREMENT, NPC2, PC, 0.0f, 200.0f, "../Images/CROMULON.png"));
    spawnRate = 0;
  }
  //Spawn the enemies every so often until no enemies are left to spawn
  
  background(0);
  //Erase screen
  
  PC.Movement(mode);
  PC.posCheck();
  PC.Draw();
  NPC1.Follow();
  NPC1.posCheck();
  NPC1.Draw();
  NPC2.Follow();
  NPC2.posCheck();
  NPC2.Draw();
  //Update and draw all main characters
  
  for(int i = 0; i < Enemies.size(); i++) {
    Character Enemy = Enemies.get(i);
    if(i < (Enemies.size()+1)/2) Enemy.Follow();
    else Enemy.Wander();
    Enemy.posCheck();
    Enemy.Draw();
  }
  DrawObstacles();
  DrawPowerUps();
  //Update and draw all enemies
  if(start){
    countdown -= deltaTime/FPS;
    textSize(24);
    text("Lifes: "+lifes+"\nRemaining Time: " + (int)countdown +"\nScore: " +score, 40, 40); 
      if(countdown <= 0){
        lifes--;
        countdown = timeToBeat;
        if(lifes <= 0) {
          background(0);
          textSize(50);
          text("You lost!", 40, 40); 
          while(!keyPressed);
          exit();
        }
      else{
        StartGame();
      }
    }
  }
  //collisions enemics 
  //int col = 0;
  for(int i = 0 ; i<(Enemies.size()) ; i++){
    Character currentEnemy = Enemies.get(i);
    if(
        (currentEnemy.posX + currentEnemy.sizeX > PC.posX && currentEnemy.posY + currentEnemy.sizeY > PC.posY) &&
        (currentEnemy.posX < PC.posX +PC.sizeX && currentEnemy.posY < PC.posY +PC.sizeY) 
    ){
      score+= 10;
      Enemies.remove(i);
    }
    if(
        (currentEnemy.posX + currentEnemy.sizeX > NPC2.posX && currentEnemy.posY + currentEnemy.sizeY > NPC2.posY) &&
        (currentEnemy.posX < NPC2.posX +NPC2.sizeX && currentEnemy.posY < NPC2.posY +NPC2.sizeY) 
    ){
      NPC2.life--;
      if(NPC2.life <= 0){   
        lifes--;
        if(lifes <= 0) {
          background(0);
          textSize(50);
          text("You lost!", 40, 40); 
          while(!keyPressed);
          exit();
        }
        else
          StartGame();      
      }
      else
        Enemies.remove(i);
    }
    
  }
 // text("Colisions with player: " + col, 500, 40); 
  //colisions npc player
  if(NPC1.characterToFollow == null){
     if(
        (NPC1.posX + NPC1.sizeX > PC.posX && NPC1.posY + NPC1.sizeY > PC.posY) &&
        (NPC1.posX < PC.posX +PC.sizeX && NPC1.posY < PC.posY +PC.sizeY) 
      )NPC1.characterToFollow = PC;
  }
  if(NPC2.characterToFollow == null){
     if(
        (NPC2.posX + NPC2.sizeX > PC.posX && NPC2.posY + NPC2.sizeY > PC.posY) &&
        (NPC2.posX < PC.posX +PC.sizeX && NPC2.posY < PC.posY +PC.sizeY) 
      )NPC2.characterToFollow = NPC1;
  }
}

void keyPressed() { //Turn on keys
  if(key == LEFT || key == 'a' || key == 'A') moveKeys[0] = true;
  if(key == RIGHT || key == 'd' || key == 'D') moveKeys[1] = true;
  if(key == UP || key == 'w' || key == 'W') moveKeys[2] = true;
  if(key == DOWN || key == 's' || key == 'S') moveKeys[3] = true;
}

void keyReleased() { //Turn off keys, consider enemy number
  //Before start
  if(!start) {
    String nums = "0123456789"; //To filter for nums
    if(nums.indexOf(key) != -1) {
      N *= 10;
      N += key - '0';
      if(N > MAX_ENEMIES) N = MAX_ENEMIES;
      printStartScreen();
      //Add values to the enemy count
    } else if(key == BACKSPACE) {
      N /= 10;
      printStartScreen();
      //Erase enemy count
    } else if(key == 'm' || key == 'M') {
      mode = !mode;
      printStartScreen();
      //Select mode
    } else if(key == ENTER) {
      start = true;
      
      StartGame();
      bgMusic.stop();
      return;
      //Start game
    }
  }
  if(key == LEFT || key == 'a' || key == 'A') moveKeys[0] = false;
  if(key == RIGHT || key == 'd' || key == 'D') moveKeys[1] = false;
  if(key == UP || key == 'w' || key == 'W') moveKeys[2] = false;
  if(key == DOWN || key == 's' || key == 'S') moveKeys[3] = false;
  //Update keys
}

void printStartScreen() { //Print the start screen data: enemy count, mode, and instructions
  background(0);
  textSize(100);
  text(N, 100, 200);
  textSize(50);
  if(mode) {
    text("Toggle mode with (M): MOUSE", 100, 300);
  } else {
    text("Toggle mode with (M): KEYBOARD", 100, 300);
  }
  text("Press (ENTER) to start", 100, 500);
}

float deltaTime() { //Scale speed and other physics computations wrt frame duration
  int delta;
  float deltaTime;
  delta = millis() - lastTime;
  lastTime = millis();
  deltaTime = delta*FPS/1000.0f;
  return deltaTime;
}
