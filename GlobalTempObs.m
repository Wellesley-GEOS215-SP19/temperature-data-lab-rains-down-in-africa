%Megan Goldsmith and Diana Hernandez
%Global Data Analyzation

%% 
%%Reading in the "global_temp.xls"
filename = 'global_temp.xls'
globaldata = readtable(filename)


%% 
%%Plotting data from single month
%year on x-axis and temp on y-axis
%month of January used
year = globaldata.Year
temp = globaldata.Jan
plot(year,temp,'o') %shows steady incline like "stationdata"


%% 
%%Calculationg January mean, SD(standard deviation), min, and max
monthMean = nanmean(globaldata.Jan)
monthStd = nanstd(globaldata.Jan)
montMin = min(globaldata.Jan)
monthMax = max(globaldata.Jan)


%% 
%%Calculating annual climatology
% Extract the monthly temperature data from the table and store it in an
% array, using the function table2array. (Named gtdata)
gtData = table2array(globaldata(:,2:13));


%% 
%%Calculating mean, SD, min, and max temperature of annual
%climatology(named tempData)
tempMean = nanmean(gtData)
tempStd = nanstd(gtData)
tempMin = min(gtData)
tempMax = max(gtData)


%% 
%%Plotting monthly climatology error bars representating the SD.
%Adding title & axis labels.
figure(1); clf
    
year = gtData.Year; %getting an error here

errorbar(2:13, tempMean, tempStd)
title('Global Monthly Climatology With Standard Deviation')
xlabel('Months')
ylabel('Temperature (C)')



%% 
%%Finding all NaN values and replace with climatological mean
%calculated above.
for i = 2:13
    indnan = find(isnan(gtData(:,i)) == 1);
    
    gtData(indnan, i) = tempMean(i);
end


%% 
%%Calculating annual mean temp for each year
amean = mean(gtData) %we may need an ' here...not sure?


%Calculating temp anomaly for each year, compared to 1981-2000 mean.
%This is the baseline

%Annual mean temp over 1981-2000
w1981 = find(year >= 1981) %finding rows

baseline = mean(amean(w1981))%baseline calculation

%Annual mean temp anomaly as annual mean temp for each year 
%minus baseline
anomaly = amean-baseline


%% 
%%Plotting annual temp over full observation record
figure(2); clf
%Scatter plot with year on x-axis and annual mean temp
%anomaly on y-axis
scatter(year, anomaly)
hold on;

%Smoothing data by taking 5-year running mean of data. 
%Use movemean function.
smooth = movemean(anomaly,5);

%Adding line with smoothed data to scatter plot above.
plot(year,smooth)
hold on;


%% 
%%Adding and plotting linear trend from 1960-today.
%Use ployfit function

P = polyfit(year, anomaly', 1) %Need an '?

%slope = 
%intercept = 

%Calculating slope and intercept of a best fit line just from
%1960 to the end of the observational period
% Find the index for where 1960 is in the list of years

w1960 = find(year >= 1960)
P60 = polyfit(year(w1960),anomaly(w1960)', 1)

%slope = 
%intercept = 

%Adding lines for each of these linear trends on the annual temp
%anomaly plot
hold on;

plot(year,(P(1)*year) + (P(2)), 'g')
hold on;

plot(year(w1960),(P60(1)*year(w1960)) + (P60(2)),'m')
hold on;


%% Adding a legend, axis labels, and a title to temp anomaly plot
legend({}, 'Location','northeast')
xlabel('Years')
ylabel('Anomaly')
title('Global Temperature Anomaly)')










