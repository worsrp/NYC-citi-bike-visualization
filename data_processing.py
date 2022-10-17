import pandas as pd

screen_width = 1000
screen_height = 800

map_left   = -74.124987;      
map_right  = -73.885786;      
map_top    = 40.779157;       
map_bottom = 40.645007; 

data = pd.read_csv('citibike052022.csv')

data = data.dropna(subset=['start_lat', 'start_lng', 'end_lat', 'end_lng'])

# df['ride_id'] = data['ride_id']
# df['start_lat'] = data['start_lat']
# df['start_lng'] = data['start_lng']
# df['end_lat'] = data['end_lat']
# df['end_lng'] = data['end_lng']
# df['start_x'] = screen_width*(data['start_lng'] - map_left)/(map_right - map_left)
# df['start_y'] = screen_height - (screen_height*(data['start_lat'] - map_bottom)/(map_top - map_bottom))
# df['end_x'] = screen_width*(data['end_lng'] - map_left)/(map_right - map_left)
# df['end_y'] = screen_height - (screen_height*(data['end_lat'] - map_bottom)/(map_top - map_bottom))

# df = df.dropna(subset=['start_lat', 'start_lng', 'end_lat', 'end_lng'])

# df = data
print(data)
# print(df)

data.to_csv('cleaned_citibike052022.csv')  

