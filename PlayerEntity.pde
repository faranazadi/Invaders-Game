class PlayerEntity
{
  //Variables
  float x, y;
  
  //Image object of player
  PImage player;
  
  //Player's CURRENT score
  int score = 0;
  
  //Player's number of lives
  int lives = 5;
  
  //Constructor
  PlayerEntity(int x, int y) 
  {
    this.x = x;
    this.y = y;
    player = loadImage("Sprites/Player/Player.png");
    //imageMode(CENTER);
  }
  
  void update()
  {
    render();
  }
  
  void render() 
  {
    image(player, x, y);
  }
  
  void fireBullet()
  {
      //Create new bullet
      Bullet bullet = new Bullet(this.x + 25, this.y + 15, -5); 

      //Add to ArrayList
      bullets.add(bullet);  
  }
  
} //End of class