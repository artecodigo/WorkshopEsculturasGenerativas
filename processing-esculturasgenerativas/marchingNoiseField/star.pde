

class Star{
  float x,y,z,s; 
  float vx,vy,vz;
    float w = width; 
    float h = height; 
  Star(){
    field();
  }  
  void field(){
    x = noise(millis())*w;
    y = noise(second()+random(1000))*h;
    z = noise(minute() +random(100))*-w;
    s = random(1)*10.;   
//    println("z "+z);
  }  

  void zz(){
    z = -w;//noise(minute() +random(100)) * -100000;      
  }

  void render(){

    if(z>500) z = -w;
    
    z+=speed;


    vx = (noise(mouseX/10 + y/100)-0.5)*(s+speed);//10.0f;
    vy = (noise(mouseY/10 + x/100)-0.5)*(s+speed);
    vz = (noise(mouseY/20 + z/100)-0.5)*(s+speed);
    x+=vx;
    y+=vy;
    z+=vz;
    
    if(x>starmaxx) x=starminx;
    if(x<starminx) x=starmaxx;
    if(y<starminy) y=starminy;
    if(y>starmaxy) y=starmaxy;
    if(z<starminz) z=starmaxz;
    if(z>starmaxz) z=starminz;
    
    line(x,y,z,x-vx,y-vy, z-vz);



  }
}
