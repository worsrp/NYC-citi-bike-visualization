PImage backgroundMap;
Table table;
TableRow row;
String url_map = "Newyork.png";

float mapGeoLeft   = -74.124987;       // Longitude degree west
float mapGeoRight  = -73.885786;       // Longitude degree east
float mapGeoTop    = 40.779157;       // Latitude degree north
float mapGeoBottom = 40.645007;          // Latitude degree south

float mapScreenWidth, mapScreenHeight;

float[] st_lat, st_lon, en_lat, en_lon; 

void setup() {
    size(1000, 800);
    ellipseMode(CENTER);
    smooth();
    backgroundMap = loadImage(url_map);
    // Set map dimension to dispaly window's width and height
    mapScreenWidth  = width;
    mapScreenHeight = height;
    //Set framerate to 5
    frameRate(5);
    table = loadTable("citibike052022.csv","header");
    st_lat = new float[table.getRowCount()];
    st_lon = new float[table.getRowCount()];
    en_lat = new float[table.getRowCount()];
    en_lon = new float[table.getRowCount()];
    for(int i=0;i<table.getRowCount();i++){
        row = table.getRow(i);
        st_lat[i] = row.getFloat("start_lat");
        st_lon[i] = row.getFloat("start_lng");
        en_lat[i] = row.getFloat("end_lat");
        en_lon[i] = row.getFloat("end_lng");
    }
}

void draw() {
    image(backgroundMap, 0, 0, mapScreenWidth, mapScreenHeight);

    //plot trip

    for(int i=0; i<st_lat.length; i++){
       // Converting geogrphical coordinates into (x, y) coordinates  
        float x1 = mapScreenWidth*(st_lon[i]-mapGeoLeft)/(mapGeoRight-mapGeoLeft);
        float y1 = mapScreenHeight - mapScreenHeight*(st_lat[i]-mapGeoBottom)/(mapGeoTop-mapGeoBottom);
       // Draw a circle
        noStroke();
        fill(0,255,100);
        ellipse(x1, y1, 5, 5);
    }
    // for(int i=0; i<st_lat.length; i++){
    //    // Converting geogrphical coordinates into (x, y) coordinates  
    //     float x2 = mapScreenWidth*(en_lon[i]-mapGeoLeft)/(mapGeoRight-mapGeoLeft);
    //     float y2 = mapScreenHeight - mapScreenHeight*(en_lat[i]-mapGeoBottom)/(mapGeoTop-mapGeoBottom);
    //    // Draw a circle
    //     noStroke();
    //     fill(255,100,0);
    //     ellipse(x2, y2, 5, 5);
    // }

    //test 1 point

    //     float x1 = mapScreenWidth*(st_lon[0]-mapGeoLeft)/(mapGeoRight-mapGeoLeft);
    //     float y1 = mapScreenHeight - mapScreenHeight*(st_lat[0]-mapGeoBottom)/(mapGeoTop-mapGeoBottom);
    //    // Draw a circle
    //     noStroke();
    //     fill(0,255,100);
    //     ellipse(x1, y1, 5, 5);
    //     float x2 = mapScreenWidth*(en_lon[0]-mapGeoLeft)/(mapGeoRight-mapGeoLeft);
    //     float y2 = mapScreenHeight - mapScreenHeight*(en_lat[0]-mapGeoBottom)/(mapGeoTop-mapGeoBottom);
    //    // Draw a circle
    //     noStroke();
    //     fill(255,100,0);
    //     ellipse(x2, y2, 5, 5);
}
