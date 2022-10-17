import pandas as pd
import math

screen_width = 1000
screen_height = 800

map_left   = -74.124987;      
map_right  = -73.885786;      
map_top    = 40.779157;       
map_bottom = 40.645007; 

filter_date = ['2022-05-30']


def time_to_min(t):
   h, m, s = map(int, t.split(':'))
#    return h * 60 + m
   return h * 6 + math.ceil(m/10) 

data = pd.read_csv('cleaned_citibike052022.csv')


data = data.dropna(subset=['start_lat', 'start_lng', 'end_lat', 'end_lng'])

data[['date', 'started_time']] = data['started_at'].str.split(' ', 1, expand=True)
data['ended_time'] = data['ended_at'].str.split(' ', 1, expand=True)[1]

data = data[data['date'].isin(filter_date)]


data['start_x'] = screen_width*(data['start_lng'] - map_left)/(map_right - map_left)
data['start_y'] = screen_height - (screen_height*(data['start_lat'] - map_bottom)/(map_top - map_bottom))

data['end_x'] = screen_width*(data['end_lng'] - map_left)/(map_right - map_left)
data['end_y'] = screen_height - (screen_height*(data['end_lat'] - map_bottom)/(map_top - map_bottom))

# data['started_time'] = data['started_time'].apply(lambda f: time_to_min(f))
# data['ended_time'] = data['ended_time'].apply(lambda f: time_to_min(f))

# data['start_box_x'] = data['start_x'].apply(lambda f: math.ceil(f%20))
# data['start_box_y'] = data['start_y'].apply(lambda f: math.ceil(f%20))

# data['end_box_x'] = data['end_x'].apply(lambda f: math.ceil(f%20))
# data['end_box_y'] = data['end_y'].apply(lambda f: math.ceil(f%20))

print(data)

start_box = pd.DataFrame()
end_box = pd.DataFrame()

start_box['box_x'] = data['start_x'].apply(lambda f: math.ceil(f/20))
start_box['box_y'] = data['start_y'].apply(lambda f: math.ceil(f/20))
start_box['timestamp'] = data['started_time'].apply(lambda f: time_to_min(f))

end_box['box_x'] = data['end_x'].apply(lambda f: math.ceil(f/20))
end_box['box_y'] = data['end_y'].apply(lambda f: math.ceil(f/20))
end_box['timestamp'] = data['ended_time'].apply(lambda f: time_to_min(f))

box = pd.concat([start_box, end_box]).reset_index().drop(['index'], axis=1)
box = box.groupby(['box_x','box_y','timestamp']).size()
box.rename_axis(index={'0': 'density'})
# box = box.groupby('box_x')
# start_box.groupby('start_timestamp')

print(start_box)
print(end_box)
print(box)

box.to_csv('box_citibike052022.csv')
data.to_csv('processed_citibike052022.csv')

