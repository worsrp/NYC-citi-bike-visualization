PImage backgroundMap;
Table table;
TableRow row;
String url_map = "Newyork.png";

PFont font;

float mapGeoLeft   = -74.124987;       // Longitude degree west
float mapGeoRight  = -73.885786;       // Longitude degree east
float mapGeoTop    = 40.779157;       // Latitude degree north
float mapGeoBottom = 40.645007;          // Latitude degree south

float mapScreenWidth, mapScreenHeight;

String status ;

String all = "All", start = "Start", end = "End", reset = "Reset";
float sizest = 0;

float[] st_lat, st_lon, en_lat, en_lon, x_st, y_st, x_en, y_en; 
String[] st_name, en_name;

float leftright = 0, updown = 0;


float x;
void setup() {
    size(1200, 800, P3D);
    ellipseMode(CENTER);
    // rectMode(CENTER);
    smooth();
    backgroundMap = loadImage(url_map);

    // Set map dimension to display window's width and height

    mapScreenWidth  = 1000;
    mapScreenHeight = 800;

    //set font

    font = createFont("Poppins Medium",40,true);

    //Set framerate to 5
    frameRate(60);
    table = loadTable("cleaned_citibike052022.csv","header");

    x_st = new float[table.getRowCount()];
    y_st = new float[table.getRowCount()];
    x_en = new float[table.getRowCount()];
    y_en = new float[table.getRowCount()];
    st_lat = new float[table.getRowCount()];
    st_lon = new float[table.getRowCount()];
    en_lat = new float[table.getRowCount()];
    en_lon = new float[table.getRowCount()];
    st_name = new String[table.getRowCount()];
    en_name = new String[table.getRowCount()];
    
    // bike = new Pointbike[table.getRowCount()];
    for(int i=0;i<table.getRowCount();i++){
        row = table.getRow(i);
        st_lat[i] = row.getFloat("start_lat");
        st_lon[i] = row.getFloat("start_lng");
        en_lat[i] = row.getFloat("end_lat");
        en_lon[i] = row.getFloat("end_lng");
        st_name[i] = row.getString("start_station_name");
        en_name[i] = row.getString("end_station_name");
    }

    x = 0;


}

void draw() {
    
    background(0);
    
    //font set

    textFont(font,15);
    textAlign(LEFT);

    pushMatrix();

        translate(200,0,0);   

        pushMatrix();

            translate(width/2,height/2,0);
            rotateX(PI*updown/(height*2));
            rotateY(PI*leftright/(width*2));

            image(backgroundMap, -width/2, -height/2,  mapScreenWidth, mapScreenHeight);

            if(status=="All"){

                for(int i=0; i<st_lat.length; i++){
                    x_st[i] = (mapScreenWidth*(st_lon[i]-mapGeoLeft)/(mapGeoRight-mapGeoLeft))-(width/2);
                    y_st[i] = (mapScreenHeight - mapScreenHeight*(st_lat[i]-mapGeoBottom)/(mapGeoTop-mapGeoBottom))-(height/2);
                    noStroke();
                    fill(0,255,0);
                    ellipse(x_st[i], y_st[i], 5, 5);
                }

                for(int i=0; i<st_lat.length; i++){
                    x_en[i] = mapScreenWidth*(en_lon[i]-mapGeoLeft)/(mapGeoRight-mapGeoLeft)-(width/2);
                    y_en[i] = mapScreenHeight - mapScreenHeight*(en_lat[i]-mapGeoBottom)/(mapGeoTop-mapGeoBottom)-(height/2);
                    noStroke();
                    fill(255,100,0);
                    ellipse(x_en[i], y_en[i], 5, 5);
                }

                for(int i=0;i<x_st.length;i++){
                    if((dist(mouseX-200, mouseY, x_st[i]+(width/2), y_st[i]+(height/2))<=3)){
                        float size=6;
                        fill(255);
                        for(int j=0;j<st_name[i].length();j++){
                            size += textWidth(st_name[i].charAt(j));
                        }
                        rect(x_st[i]-1,y_st[i]-10,size,20,40);
                        fill(10,160,96);
                        text(st_name[i],x_st[i]+2,y_st[i]+5);
                    }
                    if((dist(mouseX-200, mouseY, x_en[i]+(width/2), y_en[i]+(height/2))<=3)){
                        float size=6;
                        fill(255);
                        for(int j=0;j<en_name[i].length();j++){
                            size += textWidth(en_name[i].charAt(j));
                        }
                        rect(x_en[i]-1,y_en[i]-10,size,20,40);
                        fill(247,90,192);
                        text(en_name[i],x_en[i]+2,y_en[i]+5);
                    }
                }

            }else if(status=="Start"){

                for(int i=0; i<st_lat.length; i++){
                    x_st[i] = mapScreenWidth*(st_lon[i]-mapGeoLeft)/(mapGeoRight-mapGeoLeft)-(width/2);
                    y_st[i] = mapScreenHeight - mapScreenHeight*(st_lat[i]-mapGeoBottom)/(mapGeoTop-mapGeoBottom)-(height/2);
                    noStroke();
                    fill(0,255,0);
                    ellipse(x_st[i], y_st[i], 5, 5);
                }   

                for(int i=0;i<x_st.length;i++){
                    if((dist(mouseX-200, mouseY, x_st[i]+(width/2), y_st[i]+(height/2))<=3)){
                        float size=6;
                        fill(255);
                        for(int j=0;j<st_name[i].length();j++){
                            size += textWidth(st_name[i].charAt(j));
                        }
                        rect(x_st[i]-1,y_st[i]-10,size,20,40);
                        fill(10,160,96);
                        text(st_name[i],x_st[i]+2,y_st[i]+5);
                    }
                }

            }else if(status=="End"){

                for(int i=0; i<st_lat.length; i++){
                    x_en[i] = mapScreenWidth*(en_lon[i]-mapGeoLeft)/(mapGeoRight-mapGeoLeft)-(width/2);
                    y_en[i] = mapScreenHeight - mapScreenHeight*(en_lat[i]-mapGeoBottom)/(mapGeoTop-mapGeoBottom)-(height/2);
                    noStroke();
                    fill(255,100,0);
                    ellipse(x_en[i], y_en[i], 5, 5);
                }

                for(int i=0;i<x_st.length;i++){
                    if((dist(mouseX-200, mouseY, x_en[i]+(width/2), y_en[i]+(height/2))<=3)){
                    float size=6;
                    fill(255);
                    for(int j=0;j<en_name[i].length();j++){
                        size += textWidth(en_name[i].charAt(j));
                    }
                    rect(x_en[i]-1,y_en[i]-10,size,20,40);
                    fill(247,90,192);
                    text(en_name[i],x_en[i]+2,y_en[i]+5);
                }
            }
        }

        popMatrix();

    popMatrix();

    //tap for mode
    fill(0);
    rect(0,0,200,height);
    textSize(60);
    textAlign(CENTER);
    fill(255,255,0);
    rect(25,50,150,100,50);
    fill(0);      
    text(all,100,125);
        

    fill(255,255,0);
    rect(25,200,150,100,50);
    fill(0);
    text(start,100,275);
        
    fill(255,255,0);
    rect(25,350,150,100,50);
    fill(0);
    text(end,100,425);

    fill(255,255,0);
    rect(25,500,150,100,50);
    fill(0);
    text(reset,100,575);
        
    //key
    if(keyPressed){
        if (key == CODED) {
            if (keyCode == UP) {
                updown += 30;
            } else if (keyCode == DOWN) {
                updown -= 30;
            } else if (keyCode == LEFT) {
                leftright += 30;
            } else if (keyCode == RIGHT) {
                leftright -= 30;
            } 
            updown = constrain(updown,-height,height);
            leftright = constrain(leftright,-width,width);
        }
    }
    
}

void mousePressed(){
    if(( mouseX > 25 && mouseX < 175 && mouseY < 150 && mouseY > 50) && mousePressed){
            status=all;
    }
    if(( mouseX > 25 && mouseX < 175 && mouseY < 300 && mouseY > 200) && mousePressed){
            status=start;
    }
    if(( mouseX > 25 && mouseX < 175 && mouseY < 450 && mouseY > 350) && mousePressed){
            status=end;
    }
    if(( mouseX > 25 && mouseX < 175 && mouseY < 600 && mouseY > 500) && mousePressed){
            updown=0;
            leftright=0;
    }
}
