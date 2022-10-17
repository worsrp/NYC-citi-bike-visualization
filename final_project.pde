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

float[] st_lat, st_lon, en_lat, en_lon, x_st, y_st, x_en, y_en; 
String[] st_name, en_name;

void setup() {
    size(1000, 800);
    ellipseMode(CENTER);
    // rectMode(CENTER);
    smooth();
    backgroundMap = loadImage(url_map);

    // Set map dimension to dispaly window's width and height

    mapScreenWidth  = width;
    mapScreenHeight = height;

    //set font

    font = createFont("Poppins",40,true);

    //Set framerate to 5

    frameRate(5);

    //load data

    table = loadTable("citibike052022.csv","header");

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

}

void draw() {

    //font set

    textFont(font,15);

    image(backgroundMap, 0, 0, mapScreenWidth, mapScreenHeight);

    //plot trip

    for(int i=0; i<st_lat.length; i++){//start

       // Converting geogrphical coordinates into (x, y) coordinates  

        x_st[i] = mapScreenWidth*(st_lon[i]-mapGeoLeft)/(mapGeoRight-mapGeoLeft);
        y_st[i] = mapScreenHeight - mapScreenHeight*(st_lat[i]-mapGeoBottom)/(mapGeoTop-mapGeoBottom);

       // Draw a circle

        noStroke();
        // bike[i] = new Pointbike(x_st,y_st[i],color(0,255,100));
        // bike[i].display();
        // if((mouseX==int(x_st[i]) && mouseY==int(y_st[i])) || mousePressed){
        //     println(mouseX+" " +mouseY);
        //     println(x_st[i]+" "+y_st[i]);
        //     fill(255,0,0);
        //     text(st_name[i],x_st[i]+2,y_st[i]+5);
        //     println(st_name[i]);
        // }
        fill(0,255,0);
        ellipse(x_st[i], y_st[i], 5, 5);
    }

    for(int i=0; i<st_lat.length; i++){//end

       // Converting geogrphical coordinates into (x, y) coordinates  

        x_en[i] = mapScreenWidth*(en_lon[i]-mapGeoLeft)/(mapGeoRight-mapGeoLeft);
        y_en[i] = mapScreenHeight - mapScreenHeight*(en_lat[i]-mapGeoBottom)/(mapGeoTop-mapGeoBottom);

       // Draw a circle

        noStroke();
        fill(255,100,0);
        ellipse(x_en[i], y_en[i], 5, 5);
    }

    //test 1 point

    //     float x_st[i] = mapScreenWidth*(st_lon[0]-mapGeoLeft)/(mapGeoRight-mapGeoLeft);
    //     float y_st[i] = mapScreenHeight - mapScreenHeight*(st_lat[0]-mapGeoBottom)/(mapGeoTop-mapGeoBottom);
    //    // Draw a circle
    //     noStroke();
    //     fill(0,255,100);
    //     ellipse(x_st, y_st[i], 5, 5);
    //     float x_en[i] = mapScreenWidth*(en_lon[0]-mapGeoLeft)/(mapGeoRight-mapGeoLeft);
    //     float y_en[i] = mapScreenHeight - mapScreenHeight*(en_lat[0]-mapGeoBottom)/(mapGeoTop-mapGeoBottom);
    //    // Draw a circle
    //     noStroke();
    //     fill(255,100,0);
    //     ellipse(x_en[i], y_en[i], 5, 5);

    //check mouse x,y

    for(int i=0;i<x_st.length;i++){
        if((dist(mouseX, mouseY, x_st[i], y_st[i])<=3)){
            // println(mouseX+" " +mouseY);
            // println(x_st[i]+" "+y_st[i]);
            float size=6;
            fill(255);
            for(int j=0;j<st_name[i].length();j++){
                size += textWidth(st_name[i].charAt(j));
            }
            rect(x_st[i]-1,y_st[i]-10,size,20);
            fill(247,90,192);
            text(st_name[i],x_st[i]+2,y_st[i]+5);
            // println(st_name[i]);
        }
        if((dist(mouseX, mouseY, x_en[i], y_en[i])<=3)){
            // println(mouseX+" " +mouseY);
            // println(x_st[i]+" "+y_st[i]);
            float size=6;
            fill(255);
            for(int j=0;j<en_name[i].length();j++){
                size += textWidth(en_name[i].charAt(j));
            }
            rect(x_en[i]-1,y_en[i]-10,size,20);
            fill(247,90,192);
            text(en_name[i],x_en[i]+2,y_en[i]+5);
            // println(st_name[i]);
        }
    }
}

