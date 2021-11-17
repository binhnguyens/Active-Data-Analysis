%% Pre-face material

clear; clc; close all;
format long;

%% Import Data
path = 'Participant Data/';

subjects = cell (1,8);
subjects{1} = 'U0099725385';
subjects{2} = 'U0571781825';
subjects{3} = 'U1320514293';
subjects{4} = 'U1431916954';
subjects{5} = 'U3354287398';
subjects{6} = 'U6404631153';
subjects{7} = 'U7529931256';
subjects{8} = 'U7835074301';
subjects{8} = 'U7835074301';
subjects{9} = 'U8509049816';
subjects{10}= 'U8920175053';

subject = 3;

% % Subject 3
% filename = strcat (path,subjects{subject},'/result_event.csv');
% sensor_path = 'DiiGExtractTool/U1320514293_lamp.accelerometer_1623196800000_1627171200000.csv';

% Subject 10
filename = strcat (path,subjects{subject},'/result_event.csv');
sensor_path = 'DiiGExtractTool/U8920175053_lamp.accelerometer_1622505600000_1625011200000.csv';

%% Load the file
active_data = readtable (filename);
sensor_data = readtable (sensor_path);

%% Preprocessing
% Re-order timestamps in sensor
sensor_data = sortrows(sensor_data,'timestamp');

% Extract time stamps from timestamps
if (subject == 3)
    % P3
    timestamps1 = active_data.Var1;
    timestamps = timestamps1 (~isnan (timestamps1));

elseif (subject == 10)
    % P10
    timestamps1 = active_data.timestamp; % Used for P10
    timestamps =  timestamps1(~any(cellfun(@isempty, timestamps1),2), :);
    
end

%% Preparing for windowing of passive data
timestamp_window = cell (length (timestamps),1);

n_len = length (timestamps);

for i = 1:(n_len-1)
   timestamp_start = timestamps(i);
   timestamp_end = timestamps(i+1);
   timestamp_window{i} = sensor_data(timestamp_start:timestamp_end,:);
end

%% Activity determination
% activity = val.Var3;
% unique_activity = unique (activity);
% unique_activity(1) = [];
% 
% for i = 1:length (unique_activity)
%    index = find(strcmp(activity, unique_activity(i)))
% end
% 
% 
% 
% index = find(strcmp(activity, 'h39ht4s359vqamkggb27'))
% 
% index = find(strcmp(activity, unique_activity(1)))
