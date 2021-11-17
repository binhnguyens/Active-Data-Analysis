%%%%%%%%%%%%%%
% This file will take a look at active data
% It will count how many times the participant answered each of the
% questionnaires
%%%%%%%%%%%%%%

%% Pre-face material

clear; clc; close all;
format long;

%% Import Data
path = '/Users/binhnguyen/Downloads/Participant Data/';
subject =  15;


subjects = cell (1,8);
subjects{1} = 'U0099725385';
subjects{2} = 'U0571781825';
subjects{3} = 'U1320514293';
subjects{4} = 'U1431916954';
subjects{5} = 'U2104195387';
subjects{6} = 'U3029850491';
subjects{7} = 'U3354287398';
subjects{8} = 'U5666408227';
subjects{9} = 'U6404631153';
subjects{10} = 'U7291247359';
subjects{11} = 'U7529931256';
subjects{12} = 'U7835074301';
subjects{13} = 'U8509049816';
subjects{14}= 'U8920175053';
subjects{15} = 'U9647150890';


filename = strcat (path, subjects{subject},'/result_event.json');


%% Load the file
fid = fopen(filename); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 

active_data = jsondecode(str);

%% Preprocessing
% Re-order timestamps in sensor
% sensor_data = sortrows(sensor_data,'timestamp');

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


%% Display the table

fprintf('Subject %s \n', subjects{subject})

% Q indicies
for i = 1:length (q_indicies)
   Questionnaire_Answered (i) =  length (q_indicies{i});
end

% Legend
Legend  = [string(q_legend (1,2))]
for i = 2:length (q_indicies)
   Legend = [Legend;string(q_legend (i,2))]; 
end

% Summing
Legend = [Legend; "Total"];
Questionnaire_Answered(end+1) = sum(Questionnaire_Answered(1:end));

try 
    % Date time
    Time_Date = [(datetime(active_data(1).timestamp,'ConvertFrom','epochtime','TicksPerSecond',1000))];
    for i = 2:length (q_indicies)
       Time_Date = [Time_Date ; (datetime(active_data(i).timestamp,'ConvertFrom','epochtime','TicksPerSecond',1000))];
    end

    Time_Date = [Time_Date; (datetime(0,'ConvertFrom','epochtime','TicksPerSecond',1000))];
    
catch 
    Time_Date = [];
    for i = 1:length (q_indicies)+1
       Time_Date (i,1) =  0;
    end
end

% Table

table_analysis = table(Legend, transpose(Questionnaire_Answered),'VariableNames',{'Legend' 'Questionnaire'});


%% Display everything

fprintf('Subject %s \n', subjects{subject})

table_analysis


%% Beginning and End of timestamps

t1 = (datetime(active_data(1).timestamp,'ConvertFrom','epochtime','TicksPerSecond',1000));
t2 = (datetime(active_data(end).timestamp,'ConvertFrom','epochtime','TicksPerSecond',1000));

fprintf('Start \n');
t1
fprintf('End \n');
t2

