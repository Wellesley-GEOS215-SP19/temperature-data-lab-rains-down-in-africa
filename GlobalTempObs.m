%% Megan Goldsmith & Diana Hernandez

% Instructions: Follow through this code step by step, while also referring
% to the overall instructions and questions from the lab assignment sheet.
% Everywhere you see "% -->" is a place where you will need to write in
% your own line of code to accomplish the next task.

%% Read in the file for your station as a data table
filename = 'global_temp.xls'; %change this to select a different station
stationdata = readtable(filename);


 

%% Plot the data from a single month
% Make a plot for all data from a single month with year on the x-axis and
% temperature on the y-axis. You will want this plot to have individual
% point markers rather than a line connecting each data point.
year = stationdata.Year
temp = stationdata.Jan
plot(year,temp,'o')
xlabel('Year')
ylabel('Temperature (^{o}C)')
title('Global Climatological Mean for January')

% Calculate the monthly mean, minimum, maximum, and standard deviation
% note: some of these values will come out as NaN is you use the regular
% mean and std functions --> can you tell why? use the functions nanmean
% and nanstd to avoid this issue.

monthMean = nanmean(stationdata.Jan)
monthStd = nanstd(stationdata.Jan)
monthMin = min(stationdata.Jan)
monthMax = max(stationdata.Jan)

%% Calculate the annual climatology
% Extract the monthly temperature data from the table and store it in an
% array, using the function table2array
tempData = table2array(stationdata(:,2:13));

%Calculate the mean, standard deviation, minimum, and maximum temperature
%for every month. This will be similar to what you did above for a single
%month, but now applied over all months simultaneously.
tempMean = nanmean(tempData)
tempStd = nanstd(tempData)
tempMin = min(tempData)
tempMax = max(tempData)

%Use the plotting function "errorbar" to plot the monthly climatology with
%error bars representing the standard deviation. Add a title and axis
%labels. Use the commands "axis", "xlim", and/or "ylim" if you want to
%change from the automatic x or y axis limits.
    figure(1); clf
    
year = stationdata.Year;


errorbar(1:12, tempMean, tempStd)
title('Monthly Climatology With Standard Deviation')
xlabel('Months')
ylabel('Temperature (C)')

%% Fill missing values with the monthly climatological value
% Find all values of NaN in tempData and replace them with the
% corresponding climatological mean value calculated above.

% We can do this by looping over each month in the year:
for i = 1:12
    %use the find and isnan functions to find the index location in the
    %array of data points with NaN values
    indnan = find(isnan(tempData(:,i)) == 1); %check to make sure you understand what is happening in this line
    %now fill the corresponding values with the climatological mean
    tempData(indnan, i) = tempMean(i);
        
    
end

%% Calculate the annual mean temperature for each year

 amean = mean(tempData')

%% Calculate the temperature anomaly for each year, compared to the 1981-2000 mean
% The anomaly is the difference from the mean over some baseline period. In
% this case, we will pick the baseline period as 1981-2000 for consistency
% across each station (though note that this is a choice we are making, and
% that different temperature analysese often pick different baselines!)

%Calculate the annual mean temperature over the period from 1981-2000
  %Use the find function to find rows contain data where stationdata.Year is between 1981 and 2000
w1981 = find(year >= 1981)
  %Now calculate the mean over the full time period from 1981-2000
baseline= mean(amean(w1981))

%Calculate the annual mean temperature anomaly as the annual mean
%temperature for each year minus the baseline mean temperature
anomaly = amean - baseline

%% Plot the annual temperature anomaly over the full observational record
figure(2); clf
%Make a scatter plot with year on the x axis and the annual mean
%temperature anomaly on the y axis
scatter(year, anomaly)
title('Annual Temperature Anomaly Over the Full Observational Period')
xlabel('Year')
ylabel('Temperature Anomaly (^{o}C)')
hold on;

%% Smooth the data by taking a 5-year running mean of the data to plot
%This will even out some of the variability you observe in the scatter
%plot. There are many methods for filtering data, but this is one of the
%most straightforward - use the function movmean for this.

smooth = movmean(anomaly,5);

%Now add a line with this smoothed data to the scatter plot
plot(year,smooth) 
hold on;

%% Add and plot linear trends for whole time period, and for 1960 to today
%Here we will use the function polyfit to calculate a linear fit to the data
%For more information, type "help polyfit" in the command window and/or
%read the documentation at https://www.mathworks.com/help/matlab/data_analysis/linear-regression.html
    %use polyfit to calculate the slope and intercept of a best fit line
    %over the entire observational period
P = polyfit(year, anomaly', 1)
    
  
    
    %also calculate the slope and intercept of a best fit line just from
    %1960 to the end of the observational period
    % Hint: start by finding the index for where 1960 is in the list of
    % years
    
w1960 = find(year >= 1960)
P60 = polyfit(year(w1960),anomaly(w1960)', 1)

       

%Add lines for each of these linear trends on the annual temperature
%anomaly plot (you can do this either directly using the values in P_all
%and P_1960on, or using the polyval function). Plot each new line in a
%different color.
hold on;

plot(year,(P(1)*year) + (P(2)), 'g')
hold on;

plot(year(w1960),(P60(1)*year(w1960)) + (P60(2)),'m')
hold on;


%% Add a legend, axis labels, and a title to your temperature anomaly plot
legend({'Temperature Anomaly','5 Year Running Mean','Best Fit Line', 'Best Fit Line from 1960 to Present'}, 'Location','northwest')
xlabel('Years')
ylabel('Anomaly')
title('Global Temperature Anomaly from 1880-2006')