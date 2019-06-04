class InvaderEntity 
{
  
  //Variables
  float x, y, speed;
  
  //Variables for monkey animations
  int animCounter = 0;
  PImage monkey, monkey1;
  
  //Constructor
  InvaderEntity(float x, float y, float speed)
  {
    this.x = x;
    this.y = y;
    this.speed = speed;
    monkey = loadImage("Sprites/Invaders/Monkey.png"); 
    monkey1 = loadImage("Sprites/Invaders/Monkey1.png"); 
    //imageMode(CENTER);
  }
  
  void update() {
    render();
    move();
  }
  
  void render()
  {
    //Display animated monkeys
    if (animCounter >= 0 && animCounter < 20) {
      image(monkey, x, y);
    }
    else if (animCounter >= 20 && animCounter < 40) {
      image(monkey1, x, y);
    }
    else {
      animCounter = 0;
    }
    animCounter++;
  }
   
  void move() 
  { 
    /*x = x + speed;
    if(x < 0)
    {
      x = width;
      int stepDown = (int)random(50)-5;
      y = y + stepDown;
    }*/
    
    //Better version found online
    x += speed; //Give monkey some speed
    if (this.x > width*.9) {
      this.x = width*.9;
      this.speed *= -1; //Send monkey back the other way
      this.y += 15; //Drop down by 15 pixels
    }
 
    if (this.x < width*.1) {
      this.speed *= -1;
      this.x = width*.1;
      this.y += 15;
    }
  }
  
  //Checks to see if monkey has reached bottom of screen - if so, game over
  boolean yPosLimit()
  { 
    if (y > (height - 80)) {
      return true; 
    }
    else
    {
      return false;
    }
  }
  
  void fireBullet()
  {
      //Create new bullet
      Bullet monkeyBullet = new Bullet(this.x, this.y + 25, 2); 

      //Add to ArrayList
      monkeyBullets.add(monkeyBullet);  
  }

} //End of class