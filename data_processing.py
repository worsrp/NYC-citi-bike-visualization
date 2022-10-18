import pandas as pd
import math

screen_width = 1000
screen_height = 800

map_left   = -74.124987;      
map_right  = -73.885786;      
map_top    = 40.779157;       
map_bottom = 40.645007; 

filter_date = ['2022-05-30']

# this function is about conveting timestamp to 10-minutes count
def time_to_min(t): 
   h, m, s = map(int, t.split(':'))
   return h * 6 + math.ceil(m/10) 

data = pd.read_csv('citibike052022.csv')

# drop records that have missing value on these columns
data = data.dropna(subset=['start_lat', 'start_lng', 'end_lat', 'end_lng'])

# split date+time to new columns
data[['date', 'started_time']] = data['started_at'].str.split(' ', 1, expand=True)
data['ended_time'] = data['ended_at'].str.split(' ', 1, expand=True)[1]

# filter only the target date
data = data[data['date'].isin(filter_date)]

# covert geo-coordinates to x,y
data['start_x'] = screen_width*(data['start_lng'] - map_left)/(map_right - map_left)
data['start_y'] = screen_height - (screen_height*(data['start_lat'] - map_bottom)/(map_top - map_bottom))

data['end_x'] = screen_width*(data['end_lng'] - map_left)/(map_right - map_left)
data['end_y'] = screen_height - (screen_height*(data['end_lat'] - map_bottom)/(map_top - map_bottom))

# create box file
start_box = pd.DataFrame()
end_box = pd.DataFrame()

# calculate the box position by x,y 
start_box['box_x'] = data['start_x'].apply(lambda f: math.ceil(f/20))
start_box['box_y'] = data['start_y'].apply(lambda f: math.ceil(f/20))
start_box['timestamp'] = data['started_time'].apply(lambda f: time_to_min(f))

end_box['box_x'] = data['end_x'].apply(lambda f: math.ceil(f/20))
end_box['box_y'] = data['end_y'].apply(lambda f: math.ceil(f/20))
end_box['timestamp'] = data['ended_time'].apply(lambda f: time_to_min(f))

box = pd.concat([start_box, end_box]).reset_index().drop(['index'], axis=1)
box = box.groupby(['box_x','box_y','timestamp']).size().to_frame()
box = box.rename(columns={box.columns[0]: 'density'})

# export file
box.to_csv('box_citibike052022.csv')
data.to_csv('processed_citibike052022.csv')