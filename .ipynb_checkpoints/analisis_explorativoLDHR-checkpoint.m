pkg load io
pkg load signal
pkg load control

disp('HEAVY WEIGHT TRUCKS SOLD')

trucks=csvread(
"./MY_DATA/trucks.csv");
trucks=trucks(303:685,2); % column 2 is monthly not seasonally adjusted data from 02-1992 to 12-2023
size(trucks) % dimension to for time vector

disp('NEW PRIVATE HOUSING UNITS STARTED')

house=csvread(
"./MY_DATA/housedata.csv");
house=house(399:781,3); % column 3 = monthly data, from 02-1992 to 12-2023
size(house)

disp('TOOLBOX CONFIGURATION')
e4init % E4 toolbox
disp('LDHR code')
PaPtrucks=12./(0:6) % vector con periodos correspondientes a la estacionalidad para datos mensuales.
TVPaPtrucks=[1 1 1 1 1 1 1;1 0 0 0 0 0 0]


disp('HEAVYWEIGHT TRUCKS DATASET')


warning('off','all');
[VARtrucks,Ptrucks,TVPtrucks,oartrucks]=autodhr(trucks,12,[],[],PaPtrucks,TVPaPtrucks,1)
NVRtrucks=VARtrucks(2:8)./VARtrucks(1) % calculation of variance ratios
filt=0;
[trendtrucks,seasontrucks,cycletrucks,irregtrucks]=dhrfilt(trucks,Ptrucks,TVPtrucks,VARtrucks,12,filt,0);
% the 4 components of time series

disp('MONTHLY DATA, TREND')
figure(1)
trendtrucks=trendtrucks(:,1); % the first column of trend is the trend vector
plot([trucks,trendtrucks],'linewidth',1.4)
grid on
title('HEAVY WEIGHT TRUCKS, MONTHLY DATA AND TREND')

disp('CREATING TIME VECTOR')
% addpath('C:\Program Files\PracticasLDHR-main')
% savepath
% addpath('C:\Program Files\PracticasLDHR-main\functions')
% savepath
time=timefmt4(12,1992,2,383); % last input = number of rows of heavy weight trucks and housing units started
time=time(3:end,:); % we start from third obs since we need the time of differenced trend (1st obs = stringname obs)
disp('FIRST DIFFERENCE OF TREND')
dtrendtrucks=diff(trendtrucks); % first difference of trend vector
size(time)
size(dtrendtrucks)

disp('CONFIRMATION OF A RECESSION')
window = 1; % window size for consecutive negative values
confirmedrectrucks = []; % array to store the indices of confirmation of a recession
% Loop through the elements of dtrend
for i = 2:(length(dtrendtrucks) - window + 1) % starts at 2'nd element to see if the first one >< 0
    if all(dtrendtrucks(i:i+window-1) < 0) && dtrendtrucks(i-1) > 0
        confirmedrectrucks=[confirmedrectrucks, i + window - 1]; % if the condition is met, store the index of the nth negative element
    end
end
disp('Indices of the nth negative element of sm_dtrend preceded by a positive value:');
confirmedrectrucks=confirmedrectrucks'; % to column vector from row vector
size(dtrendtrucks); % the vector we are using
size(time); % checking time vector size
recessiontimetrucks=time(confirmedrectrucks,:); % DATES OF CONFIRMED RECESSION
recessiontrucks=dtrendtrucks(confirmedrectrucks,:); % the values in trend that are recession points

disp('CONFIRMATION OF EXPANSION')
window = 1;  % window size for consecutive values
confirmedexptrucks = [];  % array to store the indices of confirmation of a recession or expansion
% Loop through the elements of dtrendhouse
for i = 2:(length(dtrendtrucks) - window + 1)
    if all(dtrendtrucks(i:i+window-1) > 0) && dtrendtrucks(i-1) < 0
        confirmedexptrucks = [confirmedexptrucks, i + window - 1];
    end
end

disp('Indices of the nth positive element of dtrendhouse preceded by a negative value:');
confirmedexptrucks = confirmedexptrucks';  % Convert to a column vector
expansiontimetrucks=time(confirmedexptrucks,:);
expansiontrucks=dtrendtrucks(confirmedexptrucks,:);

disp('PLOTTING TREND WITH RECESSION AND EXPANSION DATES')
figure(2)
plot(dtrendtrucks,'k','linewidth',1.4)
hold on
plot(confirmedrectrucks,recessiontrucks,'r*','linewidth',1.3) % red are recessions
plot(confirmedexptrucks,expansiontrucks,'b*','linewidth',1.3) % green are expansions
% plot(poslocation,picos,'m*','linewidth',1.3) % plotting local maxima, turning points
% plot(neglocation,valles,'k*','linewidth',1.4) % plotting local minima, turning points
hold off
grid on
title('Trend difference')
legend('Trend','recessions','expansions')

disp('DATES OF EXPANSIONS AND RECESSIONS')
disp('Heavy weight trucks')
expansiontimetrucks % date when trend derivative >0
recessiontimetrucks % date when trend derivative <0
disp('Heavy weight trucks show a lagging nature in some periods and a leading nature in other periods')

times=timefmt4(12,1992,2,383); % last input = number of rows of vectors of cars, houses and conworkers, can index with (obs,:)
times=times(3:end,:); % dataset starts at 01/02/1992 and ends at 01/08/2007
PaPhouse=12./(0:6) % vector con periodos correspondientes a la estacionalidad para datos mensuales.
TVPaPhouse=[1 1 1 1 1 1 1;1 0 0 0 0 0 0]


disp('NEW HOUSING UNITS DATASET')


warning('off','all');
[VARhouse,Phouse,TVPhouse,oarhouse]=autodhr(house,12,[],[],PaPhouse,TVPaPhouse,1)
% IMPORTANT TO PUT 1 AT THE END OF THE AUTODHR FUNCTION!
NVRhouse=VARhouse(2:8)./VARhouse(1) % calculation of variance ratios
filt=0;
[trendhouse,seasonhouse,cyclehouse,irreghouse]=dhrfilt(house,Phouse,TVPhouse,VARhouse,12,filt,0);

disp('HOUSING UNITS STARTED, TREND')
trendhouse=trendhouse(:,1); % the first column of trend is the trend vector
figure(3)
plot([house,trendhouse],'linewidth',1.4)
grid on
title('MONTHLY DATA ON HOUSING, TREND')
disp('FIRST DIFFERENCE OF TREND')
dtrendhouse=diff(trendhouse); % first difference of trend vector

disp('CONFIRMATION OF A RECESSION')
window = 1; % window size for consecutive negative values
confirmedrechouse = []; % array to store the indices of confirmation of a recession
% Loop through the elements of dtrend
for i = 2:(length(dtrendhouse) - window + 1) % starts at 2'nd element to see if the first one >< 0
    if all(dtrendhouse(i:i+window-1) < 0) && dtrendhouse(i-1) > 0
        confirmedrechouse=[confirmedrechouse, i + window - 1]; % if the condition is met, store the index of the nth negative element
    end
end
disp('Indices of the nth negative element of sm_dtrend preceded by a positive value:');
confirmedrechouse=confirmedrechouse'; % to column vector from row vector
size(dtrendhouse); % the vector we are using
size(times); % checking time vector size
recessiontimehouse=times(confirmedrechouse,:); % DATES OF CONFIRMED RECESSION
recessionhouse=dtrendhouse(confirmedrechouse,:); % the values in trend that are recession points
dtrendhouse;

disp('CONFIRMATION OF EXPANSION')
window = 1;  % window size for consecutive values
confirmedexphouse = [];  % array to store the indices of confirmation of a recession or expansion
% Loop through the elements of dtrendhouse
for i = 2:(length(dtrendhouse) - window + 1)
    if all(dtrendhouse(i:i+window-1) > 0) && dtrendhouse(i-1) < 0
        confirmedexphouse = [confirmedexphouse, i + window - 1];
    end
end

disp('Indices of the nth positive element of dtrendhouse preceded by a negative value:');
confirmedexphouse = confirmedexphouse';  % Convert to a column vector
expansiontimehouse=times(confirmedexphouse,:);
expansionhouse=dtrendhouse(confirmedexphouse,:);

disp('PLOTTING TREND WITH RECESSION AND EXPANSION DATES')
figure(4)
plot(dtrendhouse,'k','linewidth',1.4)
hold on
plot(confirmedrechouse,recessionhouse,'r*','linewidth',1.3) % red are recessions
plot(confirmedexphouse,expansionhouse,'b*','linewidth',1.3) % green are expansions
hold off
grid on
title('Trend difference')
legend('Trend','recessions','expansions')

disp('DATES OF EXPANSIONS AND RECESSIONS')
disp('New housing units started')
expansiontimehouse % date when trend derivative >0
recessiontimehouse % date when trend derivative <0
disp('New housing units started show a coincident nature')

disp('NON DEFENSE CAPITAL GOODS DATASET')

steel=csvread(
"./MY_DATA/capital.csv");
steel=steel(2:384,2); % column 2 is monthly not seasonally adjusted data from 02-1992 to 12-2023
size(steel) % dimension to for time vector
steel;

timesteel=timefmt4(12,1992,2,383);
timesteel=timesteel(3:end,:); % getting rid of first obs to match differenced trend

PaPsteel=12./(0:6) % vector con periodos correspondientes a la estacionalidad para datos mensuales.
TVPaPsteel=[1 1 1 1 1 1 1;1 0 0 0 0 0 0]
warning('off','all');

[VARsteel,Psteel,TVPsteel,oarsteel]=autodhr(steel,12,[],[],PaPsteel,TVPaPsteel,1)
NVRsteel=VARsteel(2:8)./VARsteel(1) % calculation of variance ratios
filt=0;
[trendsteel,seasonsteel,cyclesteel,irregsteel]=dhrfilt(steel,Psteel,TVPsteel,VARsteel,12,filt,0);

disp('NEW DATA, TREND')
trendsteel=trendsteel(:,1); % the first column of trend is the trend vector
figure(5)
plot([steel,trendsteel],'linewidth',1.4)
grid on
title('MONTHLY DATA, TREND')
disp('FIRST DIFFERENCE OF TREND')
dtrendsteel=diff(trendsteel); % first difference of trend vector

disp('CONFIRMATION OF A RECESSION')
window = 1; % window size for consecutive negative values
confirmedrecsteel = []; % array to store the indices of confirmation of a recession
% Loop through the elements of dtrend
for i = 2:(length(dtrendsteel) - window + 1) % starts at 2'nd element to see if the first one >< 0
    if all(dtrendsteel(i:i+window-1) < 0) && dtrendsteel(i-1) > 0
        confirmedrecsteel=[confirmedrecsteel, i + window - 1]; % if the condition is met, store the index of the nth negative element
    end
end
disp('Indices of the nth negative element of sm_dtrend preceded by a positive value:');
confirmedrecsteel=confirmedrecsteel'; % to column vector from row vector
size(dtrendsteel) % the vector we are using
size(timesteel) % checking time vector size
recessiontimesteel=timesteel(confirmedrecsteel,:); % DATES OF CONFIRMED RECESSION
recessionsteel=dtrendsteel(confirmedrecsteel,:); % the values in trend that are recession points
dtrendsteel;
timesteel; % no first date because the first obs is gone with dtrend

disp('CONFIRMATION OF EXPANSION')
window = 1;  % window size for consecutive values
confirmedexpsteel = [];  % array to store the indices of confirmation of a recession or expansion
% Loop through the elements of dtrendhouse
for i = 2:(length(dtrendsteel) - window + 1)
    if all(dtrendsteel(i:i+window-1) > 0) && dtrendsteel(i-1) < 0
        confirmedexpsteel = [confirmedexpsteel, i + window - 1];
    end
end

disp('Indices of the nth positive element of dtrendhouse preceded by a negative value:');
confirmedexpsteel = confirmedexpsteel';  % Convert to a column vector
expansiontimesteel=timesteel(confirmedexpsteel,:);
expansionsteel=dtrendsteel(confirmedexpsteel,:);

disp('PLOTTING TREND WITH RECESSION AND EXPANSION DATES')
figure(6)
plot(dtrendsteel,'k','linewidth',1.4)
hold on
plot(confirmedrecsteel,recessionsteel,'r*','linewidth',1.3) % red are recessions
plot(confirmedexpsteel,expansionsteel,'b*','linewidth',1.3) % green are expansions
grid on
title('Trend difference')
legend('Trend','recessions','expansions')

disp('DATES OF EXPANSIONS AND RECESSIONS')
disp('Steel manufacturing New Orders')
expansiontimesteel % date when trend derivative >0
recessiontimesteel % date when trend derivative <0
disp('Steel dataset simillar to coincident indicator')

disp('GDP TREND')


% NOT SEASONALLY ADJUSTED QUARTERLY REAL GDP
yt=csvread(
"C:/Users/dishi/TFG-LDHR/MY_DATA/gdp.csv");
yt=yt(2:213,2); % column 2 and from row 2 to to 213 (01-1970 start and 12-2023 end)
yt=log(yt);
size(yt) % dimension of gdp vector
timeyt=timefmt4(4,1970,1,212); % quarterly dates
timeyt=timeyt(3:end,:); % from 2'nd date since we need it to match the differenced vector
size(timeyt)

PaPyt=4./[0,1,2] % vector con periodos correspondientes a la estacionalidad para datos trimestrales.
TVPaPyt=[1 1 1;1 0 0]
warning('off','all');
[VARyt,Pyt,TVPyt,oaryt]=autodhr(yt,4,[],[],PaPyt,TVPaPyt,1)
NVRyt=VARyt(2:4)./VARyt(1) % calculation of variance ratios
filt=0;
[trendyt,seasonyt,cycleyt,irregyt]=dhrfilt(yt,Pyt,TVPyt,VARyt,4,filt,0);

disp('GDP PC AND ITS TREND')
trendyt=trendyt(:,1); % the first column of trend is the trend vector
plot([yt,trendyt],'linewidth',1.4)
grid on
title('MONTHLY DATA, TREND')
disp('FIRST DIFFERENCE OF TREND')
dtrendyt=diff(trendyt); % first difference of trend vector
size(dtrendyt)
mean(dtrendyt)

disp('CONFIRMATION OF A RECESSION')
window = 1; % window size for consecutive negative values
confirmedrecyt = []; % array to store the indices of confirmation of a recession
% Loop through the elements of dtrend
for i = 2:(length(dtrendyt) - window + 1) % starts at 2'nd element to see if the first one >< 0
    if all(dtrendyt(i:i+window-1) < 0.015) && dtrendyt(i-1) > 0.015
        confirmedrecyt=[confirmedrecyt, i + window - 1]; % if the condition is met, store the index of the nth negative element
    end
end
disp('Indices of the nth negative element of sm_dtrend preceded by a positive value:');
confirmedrecyt=confirmedrecyt'; % to column vector from row vector
size(dtrendyt) % the vector we are using
size(timeyt) % checking time vector size
recessiontimeyt=timeyt(confirmedrecyt,:); % DATES OF CONFIRMED RECESSION
recessionyt=dtrendyt(confirmedrecyt,:); % the values in trend that are recession points

disp('CONFIRMATION OF EXPANSION')
window = 1;  % window size for consecutive values
confirmedexpyt = [];  % array to store the indices of confirmation of a recession or expansion
% Loop through the elements of dtrend
for i = 2:(length(dtrendyt) - window + 1)
    if all(dtrendyt(i:i+window-1) > 0.015) && dtrendyt(i-1) < 0.015
        confirmedexpyt = [confirmedexpyt, i + window - 1];
    end
end

disp('Indices of the nth positive element of dtrendhouse preceded by a negative value:');
confirmedexpyt = confirmedexpyt';  % Convert to a column vector
expansiontimeyt=timeyt(confirmedexpyt,:);
expansionyt=dtrendyt(confirmedexpyt,:);

disp('PLOTTING TREND WITH RECESSION AND EXPANSION DATES')
figure(7)
plot(dtrendyt,'k','linewidth',1.4)
hold on
plot(confirmedrecyt,recessionyt,'r*','linewidth',1.3) % red are recessions
plot(confirmedexpyt,expansionyt,'b*','linewidth',1.3) % blue are expansions
grid on
title('Trend difference')
legend('Trend','recessions','expansions')

disp('DATES OF EXPANSIONS AND RECESSIONS')
disp('GDP')
expansiontimeyt % date when trend derivative > growth rate
recessiontimeyt % date when trend derivative < growth rate

disp('RETAIL SALES TRADE, MIL OF DOLLARS, MONTHLY, NOT SEASONALLY ADJUSTED')

retail=csvread(
"./MY_DATA/retail.csv");
retail=retail(2:188,2); % from row 2 to row 188 (02-1992 to 08-2007) and 2nd row because 1st row are dates

size(retail) % should have 187 entries
timeretail=timefmt4(12,1992,2,187); % time vector for retail sales trade dataset
timeretail=timeretail(3:end,:); % from 2'nd date since we need it to match the differenced vector, while 1st entry is a string
size(timeretail) % 186 dates

PaPret=12./(0:6) % divide by the half of the observations per year, due to harmonics
TVPaPret=[1 1 1 1 1 1 1;1 0 0 0 0 0 0]

[VARret,Pret,TVPret,oarret]=autodhr(retail,12,[],[],PaPret,TVPaPret,1)
NVRret=VARret(2:8)./VARret(1) % calculation of variance ratios
filt=0;
[trendretail,seasonret,cycleret,irregret]=dhrfilt(retail,Pret,TVPret,VARret,12,filt,0);

disp('RETAIL SALES TRADE AND ITS TREND')
trendretail=trendretail(:,1); % the first column of trend is the trend vector
figure(8)
plot([retail,trendretail],'linewidth',1.4)
grid on
title('RETAIL SALES, TREND')
disp('FIRST DIFFERENCE OF TREND')
dtrendretail=diff(trendretail); % first difference of trend vector
size(dtrendretail) % now the same size as the time vector

disp('CONFIRMATION OF A RECESSION')
window = 1; % window size for consecutive negative values
confirmedrecretail = []; % array to store the indices of confirmation of a recession
% Loop through the elements of dtrend
for i = 2:(length(dtrendretail) - window + 1) % starts at 2'nd element to see if the first one >< 0
    if all(dtrendretail(i:i+window-1) < 997.39) && dtrendretail(i-1) > 997.39
        confirmedrecretail=[confirmedrecretail, i + window - 1]; % if the condition is met, store the index of the nth negative element
    end
end
disp('Indices of the nth negative element of sm_dtrend preceded by a positive value:');
confirmedrecretail=confirmedrecretail'; % to column vector from row vector
recessiontimeretail=timeretail(confirmedrecretail,:); % DATES OF CONFIRMED RECESSION
recessionretail=dtrendretail(confirmedrecretail,:); % the values in trend that are recession points

disp('CONFIRMATION OF EXPANSION')
window = 1;  % window size for consecutive values
confirmedexpretail = [];  % array to store the indices of confirmation of a recession or expansion
% Loop through the elements of dtrend
for i = 2:(length(dtrendretail) - window + 1)
    if all(dtrendretail(i:i+window-1) > 997.39) && dtrendretail(i-1) < 997.39
        confirmedexpretail = [confirmedexpretail, i + window - 1];
    end
end
disp('Indices of the nth positive element of dtrendhouse preceded by a negative value:');
confirmedexpretail = confirmedexpretail';  % Convert to a column vector
expansiontimeretail=timeretail(confirmedexpretail,:);
expansionretail=dtrendretail(confirmedexpretail,:);

disp('PLOTTING TREND WITH RECESSION AND EXPANSION DATES')
figure(10)
plot(dtrendretail,'k','linewidth',1.4)
hold on
plot(confirmedrecretail,recessionretail,'r*','linewidth',1.3) % red are recessions
plot(confirmedexpretail,expansionretail,'b*','linewidth',1.3) % blue are expansions
grid on
title('RETAIL SALES TRADE, DIFF TREND')
legend('Trend','recessions','expansions')

disp('DATES OF EXPANSIONS AND RECESSIONS OF RETAIL SALES TRADE')
expansiontimeretail % date when trend derivative > growth rate
recessiontimeretail % date when trend derivative < growth rate
disp('Dates do not really coincide with NBER dating')

disp('AVERAGE WEEKLY HOURS WORKED IN MANUFACTURING, MONTHLY, NOT ADJUSTED')
% IT IS A PROXY FOR THE IDLENESS OF THE ECONOMY
idle=csvread(
"./MY_DATA/idle.csv");
idle=idle(639:1021,2); % column 2 and from 02-1992 to 12-2023
size(idle) % dimension
timeidle=timefmt4(12,1992,2,383); % monthly dates vector
timeidle=timeidle(3:end,:); % from 2'nd date since we need it to match the differenced vector
size(timeidle)

PaPidle=12./(0:6) % divide by the half of the observations per year, due to harmonics
TVPaPidle=[1 1 1 1 1 1 1;1 0 0 0 0 0 0]

[VARidle,Pidle,TVPidle,oaridle]=autodhr(idle,12,[],[],PaPidle,TVPaPidle,1)
NVRidle=VARidle(2:8)./VARidle(1) % calculation of variance ratios
filt=0;
[trendidle,seasonidle,cycleidle,irregidle]=dhrfilt(idle,Pidle,TVPidle,VARidle,12,filt,0);

disp('HOURS WORKED IN MANUF AND ITS TREND')
trendidle=trendidle(:,1); % the first column of trend is the trend vector
plot([idle,trendidle],'linewidth',1.4)
grid on
title('HOURS WORKED IN MANUF, TREND')
dtrendidle=diff(trendidle); % first difference of trend vector

disp('CONFIRMATION OF A RECESSION')
window = 1; % window size for consecutive negative values
confirmedrecidle = []; % array to store the indices of confirmation of a recession
% Loop through the elements of dtrend
for i = 2:(length(dtrendidle) - window + 1) % starts at 2'nd element to see if the first one >< 0
    if all(dtrendidle(i:i+window-1) < 0) && dtrendidle(i-1) > 0
        confirmedrecidle=[confirmedrecidle, i + window - 1]; % if the condition is met, store the index of the nth negative element
    end
end
disp('Indices of the nth negative element of sm_dtrend preceded by a positive value:');
confirmedrecidle=confirmedrecidle'; % to column vector from row vector
recessiontimeidle=timeidle(confirmedrecidle,:); % DATES OF CONFIRMED RECESSION
recessionidle=dtrendidle(confirmedrecidle,:); % the values in trend that are recession points

disp('CONFIRMATION OF EXPANSION')
window = 1;  % window size for consecutive values
confirmedexpidle = [];  % array to store the indices of confirmation of a recession or expansion
% Loop through the elements of dtrend
for i = 2:(length(dtrendidle) - window + 1)
    if all(dtrendidle(i:i+window-1) > 0) && dtrendidle(i-1) < 0
        confirmedexpidle = [confirmedexpidle, i + window - 1];
    end
end
disp('Indices of the nth positive element of dtrendhouse preceded by a negative value:');
confirmedexpidle = confirmedexpidle';  % Convert to a column vector
expansiontimeidle=timeidle(confirmedexpidle,:);
expansionidle=dtrendidle(confirmedexpidle,:);

disp('PLOTTING TREND WITH RECESSION AND EXPANSION DATES')
figure(11)
plot(dtrendidle,'k','linewidth',1.4)
hold on
plot(confirmedrecidle,recessionidle,'r*','linewidth',1.3) % red are recessions
plot(confirmedexpidle,expansionidle,'b*','linewidth',1.3) % blue are expansions
grid on
title('AVERAGE WEEKLY HOURS IN MANUF, DIFF TREND')
legend('Trend','recessions','expansions')

disp('DATES OF EXPANSIONS AND RECESSIONS OF AVERAGE WEEKLY HOURS WORKED IN MANUFACTURING')
expansiontimeidle % date when trend derivative > growth rate
recessiontimeidle % date when trend derivative < growth rate
disp('Data presents leading and coincident nature')

figure(12)
plot(trendtrucks)
hold on
plot(trendsteel)
plot(trendhouse)
plot(trendidle)
hold off

disp('Checking correct indexing')
idle(5)
timeidle(4,:)

disp('INDICADOR COMPUESTO')
k=1; # retardo
% b=[trendtrucks,trendhouse,trendsteel,trendidle]';
b=[trendtrucks,trendhouse,trendidle]';
#b = b(:,1:300);
B=b*(eye(length(b))-ones(length(b))/length(b));
[V,LAMBDA] = eig(B(:,1:length(b)-k)*B(:,k+1:length(b))'/(length(b)^(1)))

[m,ix]=max(diag(LAMBDA))
Weights=V(:,ix)./sum(V(:,ix)) %  NEGATIVE WEIGHT, COUNTERCYCLICAL NATURE OR MULTICOLLINEARITY PROBLEMS


disp('PLOTTING THE COMPOSITE INDICATOR')
cli=b'*Weights;
plot(cli,'linewidth',1.6,'k')
grid on
title('Composite indicator')
dcli=diff(cli);
size(dcli)
size(timeidle)

disp('CONFIRMATION OF A RECESSION')
window=6; % window size for consecutive negative values
confirmedreccli=[]; % array to store the indices of confirmation of a recession
for i = 2:(length(dcli) - window + 1) % starts at 2'nd element to see if the first one >< 0
    if all(dcli(i:i+window-1) < 0) && dcli(i-1) > 0
        confirmedreccli=[confirmedreccli, i + window - 1]; % if the condition is met, store the index of the nth negative element
    end
end
disp('Indices of the nth negative element of sm_dtrend preceded by a positive value:');
confirmedreccli=confirmedreccli';
recessiontimecli=timeidle(confirmedreccli,:); % DATES OF CONFIRMED RECESSION
recessioncli=dcli(confirmedreccli,:); % the values in trend that are recession points

disp('CONFIRMATION OF EXPANSION')
window = 6;  % window size for consecutive values
confirmedexpcli = [];  % array to store the indices of confirmation of a recession or expansion
for i = 2:(length(dcli) - window + 1)
    if all(dcli(i:i+window-1) > 0) && dcli(i-1) < 0
        confirmedexpcli=[confirmedexpcli, i + window - 1];
    end
end
disp('Indices of the nth positive element of dtrendhouse preceded by a negative value:');
confirmedexpcli = confirmedexpcli';
expansiontimecli=timeidle(confirmedexpcli,:);
expansioncli=dcli(confirmedexpcli,:);

disp('PLOTTING CLI WITH RECESSION AND EXPANSION DATES')
plot(dcli,'k','linewidth',1.4)
hold on
plot(confirmedreccli,recessioncli,'r*','linewidth',1.3) % red are recessions
plot(confirmedexpcli,expansioncli,'b*','linewidth',1.3) % blue are expansions
grid on
title('CLI, DIFF TREND')
legend('Trend','recessions','expansions')

disp('DATES OF EXPANSIONS AND RECESSIONS PREDICTED BY THE INDICATOR')
expansiontimecli % date when trend derivative > growth rate
recessiontimecli % date when trend derivative < growth rate
disp('Shows lagging nature and does not really coincide with NBER dating..')

clf
hold off
plot(trendtrucks)
hold on
plot(trendhouse)
hold on
plot(trendsteel)
plot(trendidle)
