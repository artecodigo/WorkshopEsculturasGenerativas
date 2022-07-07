class CubeVol {

  int dimx, dimy, dimz, dimz1;
  float[][][] vals;
  int currentZ = 0;
  float stride;

  float boxSize;
  float minMax, minMaxZ;
  float isoLevel;

  int numBoxes;

  boolean end;

  CubeVol(int dim, float stride, float box) {
    this(dim, dim, dim, dim, stride, box);
  }

  CubeVol(int dimx, int dimy, int dimz, int dimz1, float stride, float boxFact) {
    this.dimx = dimx;
    this.dimy = dimy;
    this.dimz = dimz;
    this.dimz1 = dimz1;
    vals = new float[dimx][dimy][dimz];
    this.stride = stride;

    boxSize = stride * boxFact;//stride*0.97;
    minMax = stride * min(dimx, dimy);//(min(min(dimx,dimy),dimz));
    minMaxZ = stride * dimz;

    isoLevel = 1.0;
    end = false;
  }

  void setBoxFact(float fact) {
    boxSize = stride * fact;
  }


  void clearVals() {
    for (int z = 0; z<dimz; z++)
      for (int y = 0; y<dimy; y++) 
        for (int x = 0; x<dimx; x++)       
          vals[x][y][z] = 0;
  }


  void setMatrix(int[][] grid) {


    for (int y = 0; y < dimy; y++) {
      for (int x = 0; x < dimx; x++) {

        vals[x][y][currentZ] = (float) grid[x][y] * 0.5f;
      }
    }

    currentZ = (currentZ+1) % dimz;

  }




  void saveCubeVol(String fn) {

    String[] txt = {
      "s373 cube vol file"
    }; 
    txt = append(txt, ""+dimx+" "+dimy+" "+dimz);   
    for (int k=0; k<dimz; k++) {     
      for (int j=0; j<dimy; j++) {
        for (int i=0; i<dimx; i++) {
          txt = append(txt, ""+vals[i][j][k]);
        }
      }
    }   


    saveStrings(fn+".txt", txt);
    println();
  }


  double[] getDataDouble() {
    int total = dimx*dimy*dimz;
    double datad[] = new double[total];
    int i, idx=0;
    for (i=0;i<total;i++) {
      int x = i % dimx;
      int y = (i / dimx) % dimy;
      int z = i / (dimx*dimy);
      datad[i] = vals[x][y][z];
    }
    return datad;
  }
  float[] getData() {
    int total = dimx*dimy*dimz;
    float datad[] = new float[total];
    int i, idx=0;
    for (i=0;i<total;i++) {
      int x = i % dimx;
      int y = (i / dimx) % dimy;
      int z = i / (dimx*dimy);
      datad[i] = vals[x][y][z];
    }
    return datad;
  }


  void draw() {

    numBoxes = 0;

    for (int z = 0; z<dimz; z++) {
      for (int y = 0; y<dimy; y++) {
        for (int x = 0; x<dimx; x++) {

          if (vals[x][y][z] > isoLevel) {

            numBoxes++;

            float pos = minMax;//500;
            pushMatrix();
            translate (     

            map(x, 0, dimx-1, -pos, pos), 
            map(y, 0, dimy-1, -pos, pos), 
            map(z, 0, dimz-1, -minMaxZ, minMaxZ)
              ); 

            box(boxSize);//boxSize*2);//stride);

            popMatrix();
          }
        }
      }
    }
  }
}

