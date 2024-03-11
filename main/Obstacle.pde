
final float MIN_SIZE_X = 15;
final float MAX_SIZE_X = 25;
final float MIN_SIZE_Y = 10;
final float MAX_SIZE_Y = 15;

final int NUM_OBSTACLES = 12;

ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();

class Obstacle{
  float posX,posY,sizeX,sizeY;
  Obstacle(){
    this.posX = random(width);
    this.posY = random(height);
    this.sizeX = random(MIN_SIZE_X,MAX_SIZE_X);
    this.sizeY = random(MIN_SIZE_Y,MAX_SIZE_Y);
  }
  
}

void GenerateObstacles(){
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
