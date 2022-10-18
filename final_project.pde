Table table,box_table;
TableRow row;

PFont font;

PImage backgroundMap, ping_st, ping_en;
String url_map = "Newyork.png";
String url_st = "ping1.png";
String url_en = "ping.png";


float mapScreenWidth, mapScreenHeight, scale=1;

String status ;
String all = "All", start = "Start", end = "End", reset = "Reset", dense = "Density"  ;

float[] st_lat, st_lon, en_lat, en_lon, box_x, box_y, timestamp, density;
color[] box_color;
String[] st_name, en_name;

float leftright = 0, updown = 0;

int box_size = 20;

int started_time = 0;
int ended_time = 1440;
float current_time = 0;
float speed = 1;
int hour,minute;

void setup() {

    //setup
    size(1200, 800, P3D);
    ellipseMode(CENTER);
    smooth();
    backgroundMap = loadImage(url_map);
    ping_st = loadImage(url_st);
    ping_en = loadImage(url_en);
    

    // Set map dimension to display window's width and height
    mapScreenWidth  = 1000;
    mapScreenHeight = 800;

    //set font
    font = createFont("Poppins",24,true);

    //Set framerate to 30
    frameRate(30);

    //load data from csv files
    table = loadTable("processed_citibike052022.csv","header");
    box_table = loadTable("box_citibike052022.csv","header");

    //load data from original file
    st_lat = new float[table.getRowCount()];
    st_lon = new float[table.getRowCount()];
    en_lat = new float[table.getRowCount()];
    en_lon = new float[table.getRowCount()];
    st_name = new String[table.getRowCount()];
    en_name = new String[table.getRowCount()];
    
    for(int i=0;i<table.getRowCount();i++){
        row = table.getRow(i);
        st_lat[i] = row.getFloat("start_y");
        st_lon[i] = row.getFloat("start_x");
        en_lat[i] = row.getFloat("end_y");
        en_lon[i] = row.getFloat("end_x");
        st_name[i] = row.getString("start_station_name");
        en_name[i] = row.getString("end_station_name");
    }

    // load processed data from box file
    box_x = new float[box_table.getRowCount()];
    box_y = new float[box_table.getRowCount()];
    timestamp = new float[box_table.getRowCount()];
    density = new float[box_table.getRowCount()];
    box_color = new color[box_table.getRowCount()];

    for(int i=0; i < box_table.getRowCount(); i++){
        row = box_table.getRow(i);
        box_x[i] = row.getFloat("box_x");
        box_y[i] = row.getFloat("box_y");
        timestamp[i] = row.getFloat("timestamp");
        density[i] = row.getFloat("density");
        box_color[i] = color(random(100,255),random(100,255),random(100,255),100);
    }
}

void draw() {
    
    background(7, 7, 18);

    //font setting
    textFont(font,15);
    textAlign(LEFT);
    
    //convert current_time to hour and minute
    hour = floor(current_time/60);
    minute = int(current_time-(floor(current_time/60)*60));
    

    pushMatrix();

        translate(200,0,0);   
        
        pushMatrix();

            translate(width/2,height/2,0);
            // make a visualization ratatable
            rotateX(PI*updown/(height*2));
            rotateZ(PI*leftright/(width*2));
            // make a visualization scalable
            scale(scale); 
            // set background image
            image(backgroundMap, -width/2, -height/2,  mapScreenWidth, mapScreenHeight);
            
            // if mode 'All' is selected
            if(status=="All"){ // in this mode the program will show all features
                
                plot_box();
                
                plot_start();
                plot_end();

                for(int i=0;i<st_lon.length;i++){
                    get_start_name(i);
                    get_end_name(i);
                }

            }else if(status=="Density"){ // if mode 'Density' is selected

               plot_box();

            }else if(status=="Start"){ // if mode 'Start' is selected

                plot_start();

                for(int i=0;i<st_lon.length;i++){
                    get_start_name(i);
                }

            }else if(status=="End"){ // if mode 'End' is selected

                plot_end();

                for(int i=0;i<st_lon.length;i++){
                    get_end_name(i);
                }

            }

        popMatrix();

    popMatrix();

    //sidebar for mode
    //background    
    fill(7, 7, 18);
    noStroke();
    rect(0,0,200,height);
    // all buttons
    button(32, color(56, 228, 255, 200), 150, 80, 20, 25, 50, all, 100, 101);
    button(32, color(56, 228, 255, 200), 150, 80, 20, 25, 150, start, 100, 201);
    button(32, color(56, 228, 255, 200), 150, 80, 20, 25, 250, end, 100, 301);
    button(32, color(56, 228, 255, 200), 150, 80, 20, 25, 350, dense, 100, 401);
    button(32, color(56, 228, 255, 200), 150, 80, 20, 25, 450, reset, 100, 501);
    // display date & time when 
    if(status=="All" || status=="Density"){
        textFont(font,32);    
        fill(255);
        textAlign(RIGHT);
        text("30/05/2022", 1180, 40);  
        textFont(font,40);    
        text(hour+" : "+minute, 1180, 90);   
    }

    // key operations
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

    // run time
    current_time += speed;
    current_time = constrain(current_time,started_time,ended_time);
}

void mousePressed(){
    if(( mouseX > 25 && mouseX < 175 && mouseY < 130 && mouseY > 50) && mousePressed){
            current_time=0;
            status=all;
    }
    if(( mouseX > 25 && mouseX < 175 && mouseY < 230 && mouseY > 150) && mousePressed){
            current_time=0;
            status=start;
    }
    if(( mouseX > 25 && mouseX < 175 && mouseY < 330 && mouseY > 250) && mousePressed){
            current_time=0;
            status=end;
    }
    if(( mouseX > 25 && mouseX < 175 && mouseY < 430 && mouseY > 350) && mousePressed){
            current_time=0;
            status=dense;
    }
    if(( mouseX > 25 && mouseX < 175 && mouseY < 530 && mouseY > 450) && mousePressed){
            status="";
            updown=0;
            leftright=0;
            current_time=0;
            scale=1;
    }
}

void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    if(e==-1){
        scale*=1.1;
    }else if(e==1){
        scale/=1.1;
    }
}

void button(int _textsize, color _color, int _width, int _height, int _rad,
            int _x, int _y, String _text, int _text_x, int _text_y) {
    textSize(_textsize);
    textAlign(CENTER);
    noFill();
    stroke(_color);
    strokeWeight(5);
    rect(_x,_y,_width,_height,_rad);
    stroke(255);
    strokeWeight(2);
    rect(_x,_y,_width,_height,_rad);
    fill(255);      
    text(_text,_text_x,_text_y);
}

void get_start_name(int _idx) { 
    // this function is about getting started point's name
    if((dist(mouseX-200, mouseY, st_lon[_idx], st_lat[_idx])<=5)){
        float size=14;
        for(int j=0;j<st_name[_idx].length();j++){
            size += textWidth(st_name[_idx].charAt(j));
        }
        fill(0,50);
        stroke(56, 228, 255);
        rect(st_lon[_idx]-(width/2)+9,st_lat[_idx]-(height/2)-30,size,24,20);
        fill(56, 228, 255);
        text(st_name[_idx],st_lon[_idx]-(width/2)+16,st_lat[_idx]-(height/2)-13);
    }
}

void get_end_name(int _idx) {
    // this function is about getting ended point's name
    if((dist(mouseX-200, mouseY, en_lon[_idx], en_lat[_idx])<=5)){
        float size=14;
        fill(255);
        for(int j=0;j<en_name[_idx].length();j++){
            size += textWidth(en_name[_idx].charAt(j));
        }
        fill(0,50);
        stroke(247,90,192);
        rect(en_lon[_idx]-(width/2)+9,en_lat[_idx]-(height/2)-30,size,24,20);
        fill(247,90,192);
        text(en_name[_idx],en_lon[_idx]-(width/2)+16,en_lat[_idx]-(height/2)-13); 
    }
}

void plot_start() {
    // this function is about plotting started points
    for(int i=0; i<st_lat.length; i++){
        // noStroke();
        // fill(0,255,0);
        image(ping_st, st_lon[i]-(width/2)-5, st_lat[i]-(height/2)-10, 10, 10);
    }   
}

void plot_end() {
    // this function is about plotting ended points
    for(int i=0; i<st_lat.length; i++){
        // noStroke();
        // fill(255,100,0);
        image(ping_en, en_lon[i]-(width/2)-5, en_lat[i]-(height/2)-10, 10, 10);
    }
}

void plot_box() {
    // this function is about animating density boxes
    noFill();
    stroke(255,200);
    pushMatrix();
    translate(-(width/2+10),-height/2,0);
        for(int i=0; i<timestamp.length; i++){
            if(floor(current_time/10)==timestamp[i] && timestamp[i]*10<current_time+10){
                fill(box_color[i]);
                pushMatrix();
                    translate(box_x[i]*box_size, box_y[i]*box_size, 0);
                    if(current_time-(timestamp[i]*10) < 6){
                        float box_height = density[i]*(30.0/5.0)*(current_time-(timestamp[i]*10));
                        box(box_size, box_size, box_height);
                    }else{
                        float box_height = density[i]*(30.0/4.0)*((10-(current_time-timestamp[i]*10)));
                        box(box_size, box_size, box_height);
                    }
                popMatrix();
            }
        }
    popMatrix();
}