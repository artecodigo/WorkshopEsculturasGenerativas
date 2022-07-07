

class star{
  float x,y,z,s; 
  float vx,vy,vz;
    float w = width*10; 
    float h = height*10; 
  star(){
    field();
  }  
  void field(){
    x = noise(millis())*w-w/2;
    y = noise(second()+random(1000))*h-h/2;
    z = noise(minute() +random(100))*-10000;
    s = random(1)*10.;   
//    println("z "+z);
  }  

  void zz(){
    z = noise(minute() +random(100)) * -100000;      
  }

  void render(){

    if(z>500) zz();
    z+=(s+speed);

    vx = (noise(mouseX/10 + y/100)-0.5)*(s+speed);//10.0f;
    vy = (noise(mouseY/10 + x/100)-0.5)*(s+speed);
    x+=vx;
    y+=vy;
    if(x>w) x-=2*w;
    if(x<-w) x+=2*w;
    if(y<-h) y+=2*h;
    if(y>h) y-=2*h;
    
      line(x,y,z,x-vx,y-vy, z - speed*s);



  }
}
