
final float MIN_SIZE_X = 15;
final float MAX_SIZE_X = 45;
final float MIN_SIZE_Y = 20;
final float MAX_SIZE_Y = 35;

final int NUM_OBSTACLES = 16;




class Obstacle{
  float posX,posY,sizeX,sizeY;
  Obstacle(){
    this.posX = random(width);
    this.posY = random(height);
    this.sizeX = random(MIN_SIZE_X,MAX_SIZE_X);
    this.sizeY = random(MIN_SIZE_Y,MAX_SIZE_Y);
  }
  
}

ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
void GenerateObstacles(){
  obstacles.clear();
  for(int i = 0; i < NUM_OBSTACLES; i++)
    obstacles.add( new Obstacle());
}
void DrawObstacles(){
    for(int i = 0; i < NUM_OBSTACLES; i++){
      Obstacle o = obstacles.get(i);
      fill(255,0,0);
      rect(o.posX,o.posY,o.sizeX,o.sizeY);
    }
}
