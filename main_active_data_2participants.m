%%%%%%%%%%%%%%
% This file will take both sensor and activity data to plot them against each other
% 
% The purpose is to 
% 1. See when the particiapnt answers the questionnaire
% 2. Window the particiapnts passive data to when they answered the questionnaire
% 
% For example:
% Ted answers a questionnaire Monday and Thursday
% This program will plot passive data from Monday to Thursday and indicate that as 
% Questionnaire 1. Followed by that, this program will plot the passive data from Thursday
% to present day (as it is the most recent analysis of how the participant is feeling)
% 
% In result, you will have the windowed passive data in respect to active 
%%%%%%%%%%%%%%

%% Pre-face material

clear; clc; close all;
format long;

%% Import Data
path = '/Users/binhnguyen/Downloads/Participant Data/';

subjects = cell (1,8);
subjects{3} = 'U1320514293';
subjects{10}= 'U8920175053';

subject = 10;


if (subject == 3)% Subject 3
filename = strcat (subjects{subject},'/result_event.json');
sensor_path = 'DiiGExtractTool/U1320514293_lamp.accelerometer_1621036800000_1629504000000.csv';

elseif (subject == 10) % Subject 10
filename = strcat (subjects{subject},'/result_event.json');
sensor_path = 'DiiGExtractTool/U8920175053_lamp.accelerometer_1621036800000_1626307200000.csv';

end

%% Load the file
fid = fopen(filename); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 

active_data = jsondecode(str);
sensor_data = readtable (sensor_path);

%% Preprocessing
% Re-order timestamps in sensor
sensor_data = sortrows(sensor_data,'timestamp');

% Saving active data timestamps to file
n_len = length (active_data);

active_timestamp = zeros (1,n_len);
active_activity = cell (1,n_len);
for i = 1:n_len
    active_timestamp (i) = active_data(i).timestamp;
    active_activity {i} = active_data(i).activity;
end

% Questionnaire legend 
q_legend = questionnaire_legend ();


% Find index of different questionnaires
q_indicies = cell (10,1);
for i = 1:10
    q_indicies{i} = find(contains(active_activity,q_legend{i,1}));
end


%% Plotting of passive windows

plotting_active_passive_windows (subjects,subject,active_data,...
    active_timestamp,sensor_data,q_indicies,q_legend)


%% HARD CODING PLOTS

% 5 and 6 = MIOS
% 3 and 7 = PHQ
% 2 and 9 = PSS
% 4 and 8 = GAD

% Extract the common questionnaires and sort the indices
a=2;
b=9;

q1 = q_indicies{a};
q2 = q_indicies{b};
q1q2 = sort ([q1,q2]);

questionnaire = active_timestamp(q1q2);
q_len = length (questionnaire);

% Scoring of the questionnaires
[scores, n_questions] = scoring_questionnaires(active_data);
n_questions_indicies = n_questions (q1q2);
scores_indices = scores (q1q2);

for j = 1:(q_len-1) % Index in the Questionnaire
    try
        timestamp_start = questionnaire (q_len-j);
        timestamp_end = questionnaire (q_len-j-1);

        timestamp_start_index = closest_value (sensor_data,timestamp_start);
        timestamp_end_index = closest_value (sensor_data,timestamp_end);

        sensor_timestamp = sensor_data.timestamp (timestamp_start_index:timestamp_end_index);
        x = sensor_data.data_x (timestamp_start_index:timestamp_end_index);
        y = sensor_data.data_y (timestamp_start_index:timestamp_end_index);
        z = sensor_data.data_z (timestamp_start_index:timestamp_end_index);

        figure; hold on; axis tight;
        set(gcf,'Position',[100 100 1000 500])
        
        plot (sensor_timestamp,x);
        plot (sensor_timestamp,y);
        plot (sensor_timestamp,z);

        tit_phrase = strcat(...
            'User: ',subjects(subject),'-- Q: ',...
            'PSS', '--(', int2str (n_questions_indicies(q_len-j-1)), ' Questions)',...
            '--Score: ', int2str (scores_indices(q_len-j-1))...
        );

        title (tit_phrase);
        xlabel ('Timestamp (ms)');
        ylabel ('Amplitude');
        saveas(gcf,strcat ('PSS',int2str(j),'.png'));
    
    catch
       continue 
    end
    
end


%% Preparing for windowing of passive data
n_len = length (active_data);
timestamp_window = cell (n_len,1);

for i = 1:(n_len-1)
   timestamp_start = active_data(n_len-i+1).timestamp;
   timestamp_end = active_data(n_len-i).timestamp;

   timestamp_start_index = closest_value (sensor_data,timestamp_start);
   timestamp_end_index = closest_value (sensor_data,timestamp_end);
   
   timestamp_window{i} = sensor_data(timestamp_start_index:timestamp_end_index,:);
end
