class Bullet
{
  //Variables
  float x, y, speed;
  
  //Constructor
  Bullet(float x, float y, float speed) 
  {
    this.x = x;
    this.y = y;
    this.speed = speed;
  }
  
  void update()
  {
    render();
    checkYPos();
  }
  
  void render()
  {
    //Draw bullet
    rect(x, y-30, 5, 10);
    
    //Give bullet some speed
    this.y += this.speed; 
  }
  
  void checkYPos()
  {
    if (this.y > height || this.y < 0) 
    {
      bullets.remove(this); //Deletes bullet from ArrayList when off screen
      //System.out.println("Player bullet deleted");
    }
    if (this.y < 0)
    {
      monkeyBullets.remove(this); //Deletes monkey bullet from ArrayList when off screen
      //System.out.println("Monkey bullet deleted");
    }
  }
  
} //End of class