


class CellularGrid {

  int gridcell[][], futuregridcell[][]; // as grelhas celulares
  int[] gridcenter = {
    0, 0
  };

  int gridcellularrate=3; //
  int gridrulerate=300; // tempo de mudar de regra
  int gridruleratemin=200, gridruleratemax=1000; // tempos min e max

  float accugrid_factor=0;//2;//0  

    int[] rules = {  
    0, 1, 1, 1, 1, 0, 0, 0, 0, 0
  };
  int numbit=10;

  int res;
  byte celpixels[];
  int numpixels;

  float intx ;
  float inty ;


  CellularGrid(int _res) {

    res = _res;
    numpixels = res*res;
    gridcell = new int[res][res]; 
    futuregridcell = new int[res][res];
    gridcenter[0] = gridcenter[1] = res/2;

    gridcell[res/2][res/2] = 1;

    celpixels = new byte[numpixels];


    intx = (float)width /(float)res;
    inty = (float)height /(float)res;
  }


  boolean go() {

    boolean change = false;
    if (frameCount%gridcellularrate==0) {
      itertercellular();
      change = true;
    }

    if (frameCount%gridrulerate==0) {
      gridrulerate = (int)random(gridruleratemin, gridruleratemax);
      //new rule
      setcelrule();
      accugrid_factor = -1.0f * random(0., 3.);    
      gridcellularrate = (int) random(2, 20);
    }

    return change;
  }




  void itertercellular() {

    for (int x=1; x<res-1; x++)
      for (int y=1; y<res-1; y++) {
        // count cells
        int cc =neighborscel(x, y);// star(x,y);//neighbors(x,y);
        futuregridcell[x][y] = rules[cc];
      }

    //swap grids
    int[][] temp = gridcell;
    gridcell = futuregridcell;
    futuregridcell = temp;

    //copy2pixels
    for (int j=0,k=0; j < res; j++) {
      for (int i=0;i<res;i++) {    
        celpixels[k++] =(byte) (gridcell[i][j]==0?0x00:0xff);          //0xff);
      }
    }
  }

  // count

  int neighborscel(int x, int y) {
    return (
    gridcell[x][y-1] + //north
    gridcell[x+1][y-1] + //northeast
    gridcell[x+1][y] + //east
    gridcell[x+1][y+1] + //southeast
    gridcell[x][y+1] + //south
    gridcell[x-1][y+1] + //southwest
    gridcell[x-1][y] + //west
    gridcell[x-1][y-1]  //northwest
    );
  }


  void setcelrule() {
    for (int i=0;i<numbit;i++) {
      rules[i] = (int)random(2);
      print(rules[i]+ " ");
    }
  }

  int[][] getArray() {
    return gridcell;
  }
}

