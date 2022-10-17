PImage backgroundMap;
Table table,box_table;
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

float[] st_lat, st_lon, en_lat, en_lon, box_x, box_y, timestamp, density; 
String[] st_name, en_name;

float leftright = 0, updown = 0;
int boxSize = 20;
int started_time = 0;
int ended_time = 1440;
float current_time = 0;
float speed = 1;

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
    frameRate(30);
    table = loadTable("processed_citibike052022.csv","header");
    box_table = loadTable("box_citibike052022.csv","header");

    st_lat = new float[table.getRowCount()];
    st_lon = new float[table.getRowCount()];
    en_lat = new float[table.getRowCount()];
    en_lon = new float[table.getRowCount()];
    st_name = new String[table.getRowCount()];
    en_name = new String[table.getRowCount()];
    
    // bike = new Pointbike[table.getRowCount()];
    for(int i=0;i<table.getRowCount();i++){
        row = table.getRow(i);
        st_lat[i] = row.getFloat("start_y");
        st_lon[i] = row.getFloat("start_x");
        en_lat[i] = row.getFloat("end_y");
        en_lon[i] = row.getFloat("end_x");
        st_name[i] = row.getString("start_station_name");
        en_name[i] = row.getString("end_station_name");
    }

    box_x = new float[box_table.getRowCount()];
    box_y = new float[box_table.getRowCount()];
    timestamp = new float[box_table.getRowCount()];
    density = new float[box_table.getRowCount()];

    for(int i=0; i < box_table.getRowCount(); i++){
        row = box_table.getRow(i);
        box_x[i] = row.getFloat("box_x");
        box_y[i] = row.getFloat("box_y");
        timestamp[i] = row.getFloat("timestamp");
        density[i] = row.getFloat("density");
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
        println(current_time);
        pushMatrix();

            translate(width/2,height/2,0);
            rotateX(PI*updown/(height*2));
            rotateZ(PI*leftright/(width*2));

            image(backgroundMap, -width/2, -height/2,  mapScreenWidth, mapScreenHeight);
              stroke(255,100);
              noFill();
              pushMatrix();
               translate(-(width/2+10),-height/2,0);
                for(int i=0; i<timestamp.length; i++){
                    if(floor(current_time/10)==timestamp[i] && timestamp[i]*10<current_time+10){
                        println(timestamp[i]);
                        pushMatrix();
                            translate(box_x[i]*boxSize, box_y[i]*boxSize, 0);
                            if(current_time-(timestamp[i]*10) < 6){
                                float box_height = density[i]*(30.0/5.0)*(current_time-(timestamp[i]*10));
                                // float box_height = current_time-(timestamp[i]*10);
                                println(box_height);
                                box(boxSize, boxSize, box_height);
                            }else{
                                float box_height = density[i]*(30.0/4.0)*((10-(current_time-timestamp[i]*10)));
                                // float box_height = current_time-(timestamp[i]*10);
                                println(box_height);
                                box(boxSize, boxSize, box_height);
                            }
                        popMatrix();
                    }
                }
              popMatrix();
            //   pushMatrix();
            //     translate(-width/2,-height/2,boxSize);
            //         for(int i=0; i < width; i+=20){
            //             pushMatrix();
            //                 translate(i, 0, 0);
            //                 for(int j=0; j < height; j+=20){
            //                     pushMatrix();
            //                         translate(0,j,0);
            //                         box(boxSize, boxSize, 40);
            //                     popMatrix();
            //                 }
            //             popMatrix();
            //         }
            //   popMatrix();

            if(status=="All"){

                for(int i=0; i<st_lat.length; i++){
                    noStroke();
                    fill(0,255,0);
                    ellipse(st_lon[i]-(width/2), st_lat[i]-(height/2), 5, 5);
                    fill(255,100,0);
                    ellipse(en_lon[i]-(width/2), en_lat[i]-(height/2), 5, 5);
                }

                for(int i=0;i<st_lon.length;i++){
                    if((dist(mouseX-200, mouseY, st_lon[i], st_lat[i])<=3)){
                        float size=6;
                        fill(255);
                        for(int j=0;j<st_name[i].length();j++){
                            size += textWidth(st_name[i].charAt(j));
                        }
                        rect(st_lon[i]-1-(width/2),st_lat[i]-10-(height/2),size,20,40);
                        fill(10,160,96);
                        text(st_name[i],st_lon[i]+2-(width/2),st_lat[i]+5-(height/2));
                    }
                    if((dist(mouseX-200, mouseY, en_lon[i], en_lat[i])<=3)){
                        float size=6;
                        fill(255);
                        for(int j=0;j<en_name[i].length();j++){
                            size += textWidth(en_name[i].charAt(j));
                        }
                        rect(en_lon[i]-1-(width/2),en_lat[i]-10-(height/2),size,20,40);
                        fill(247,90,192);
                        text(en_name[i],en_lon[i]+2-(width/2),en_lat[i]+5-(height/2));
                    }
                }

            }else if(status=="Start"){

                for(int i=0; i<st_lat.length; i++){
                    noStroke();
                    fill(0,255,0);
                    ellipse(st_lon[i]-(width/2), st_lat[i]-(height/2), 5, 5);
                }   

                for(int i=0;i<st_lon.length;i++){
                    if((dist(mouseX-200, mouseY, st_lon[i], st_lat[i])<=3)){
                        float size=6;
                        fill(255);
                        for(int j=0;j<st_name[i].length();j++){
                            size += textWidth(st_name[i].charAt(j));
                        }
                        rect(st_lon[i]-1-(width/2),st_lat[i]-10-(height/2),size,20,40);
                        fill(10,160,96);
                        text(st_name[i],st_lon[i]+2-(width/2),st_lat[i]+5-(height/2));
                    }
                }

            }else if(status=="End"){

                for(int i=0; i<st_lat.length; i++){
                    noStroke();
                    fill(255,100,0);
                    ellipse(en_lon[i]-(width/2), en_lat[i]-(height/2), 5, 5);
                }

                for(int i=0;i<st_lon.length;i++){
                    if((dist(mouseX-200, mouseY, en_lon[i], en_lat[i])<=3)){
                    float size=6;
                    fill(255);
                    for(int j=0;j<en_name[i].length();j++){
                        size += textWidth(en_name[i].charAt(j));
                    }
                    rect(en_lon[i]-1-(width/2),en_lat[i]-10-(height/2),size,20,40);
                    fill(247,90,192);
                    text(en_name[i],en_lon[i]+2-(width/2),en_lat[i]+5-(height/2));
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
                updown += 10;
            } else if (keyCode == DOWN) {
                updown -= 10;
            } else if (keyCode == LEFT) {
                leftright += 10;
            } else if (keyCode == RIGHT) {
                leftright -= 10;
            } 
            updown = constrain(updown,-height,height);
            leftright = constrain(leftright,-width,width);
        }
    }

    current_time += speed;
    current_time = constrain(current_time,started_time,ended_time);
    println("============================");
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
