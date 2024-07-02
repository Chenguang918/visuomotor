
% VWM Precision Task under TIBS
% Coded by DW. Lee @ BNU 2020-09-14
function WMprecision_version3
%% 运行前准备部分
clear; %清除所有变量，避免上次运行的残留数据影响本次运行
clc; %清空命令行文字，以便本次运行输出不会和上次的混淆
close all; %关闭所有figure，同样为避免运行结果和上次混淆
Priority(1); %提高代码的优先级，使得显示时间和反应时记录更精确(此处MacOS不同)
config_io

%% 参数设置部分
% ------submessage-------
prompt={'Subid','Name','Gender[1=man,2=woman]','Birthday','Lefteyesight','RightEyesight','BenefitedHand','Date'};
dlg_title='submessage';
num_lines=1;
defaultanswer={'1','Lee','1','19940816','5.0','5.0','right','20200221'};
subinfo=inputdlg(prompt,dlg_title,num_lines,defaultanswer);
path='F:\song\lidongwei\WMprecision\Data\';

% ------显示参数------
bSkipSyncTests =1; %是否禁用垂直同步测试，正式实验时切勿禁用
nMonitorID = max(Screen('Screens')); %屏幕编号
HideCursor(nMonitorID); %隐藏指针
distance = 80;         %distance between subject and monitor
monitorwidth = 47.4;      %The width of the monitor
clrBg = [156 156 156];  %指定背景颜色灰色

% 此处用于开启或关闭垂直同步测试
Screen('Preference','SkipSyncTests',bSkipSyncTests);

% -----初始化屏幕并得到屏幕参数-----
[wPtr , wRect]  = Screen('OpenWindow',nMonitorID, clrBg); %在指定的显示器打开刺激窗口
Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); %打开透明度混合功能(反锯齿需要)
[xCenter, yCenter] = WindowCenter(wPtr); %得到屏幕中心
%  Resolution = [1920 1080];
ppd = pi * wRect(3)/atan(monitorwidth/distance/2)/360;           %pixel per degree
slack = Screen('GetFlipInterval',wPtr)/2; %得到每一帧时间的一半

% ------注视点参数------
AngleFix = 0.5;
Fixcir_size = fix(AngleFix * ppd);      %注视点十字线的粗细
center = [xCenter-Fixcir_size, yCenter-Fixcir_size,xCenter+Fixcir_size, yCenter+Fixcir_size]';
clrCross = [0 0 0];   %指定注视点颜色为黑色

% ------记忆参数------
AngStimBar_length = 4; %刺激视角
StimBar_length = AngStimBar_length * ppd;
AngLeftStimlocation = [xCenter-7 * ppd,yCenter-StimBar_length/2,xCenter-3 * ppd,yCenter+StimBar_length/2];  % 角度
AngRightStimlocation = [xCenter+3 * ppd,yCenter-StimBar_length/2,xCenter+7 * ppd,yCenter+StimBar_length/2];  % 角度
BarOri = [-78.75, -56.25, -33.75, -11.25, 11.25, 33.75, 56.25, 78.75];
clrStim = [21 165 234 ; 234 74 21; 133, 194, 18; 197, 21, 234];
AngStimBar_width = 0.32;  %0.17
WideBar = AngStimBar_width * ppd;

% ------回溯线索参数------
clrCue = [21 165 234 ; 234 74 21 ; 125 125 125]; %蓝色 橙色

% ------再认刺激参数------
clrTest = [21 165 234 ; 234 74 21]; %蓝色 橙色

% ------时间和流程控制------
tPreFix = 1; %刺激出现前注视点呈现的时间
tITI = 0.3*rand;
tMemory = 0.2;  % 记忆呈现时间
tMemoryCueDuration = 1;  % 记忆、回溯Cue间间隔时间
tCue = 0.2;  % 线索呈现时间
tCueStimDuration = 1.3;  % 线索、刺激间间隔时间
response_interval = 4; %按键最长时间
StimTrialNum = 56; %每个block的trial数
Blocknum = 20; %总的block数
tFeedback = 0.2;
%  Esckey=KbName('ESC');
 
% ------trigger定义------
MarkerBlockBegin = 101;
MarkerBlockEnd = 102;
MarkerCorrectResponse = 100;
MarkerWrongResponse = 99;
MarkerNoResponse = 98;
MarkerNetural = 33;
MarkerFixation = 254;

% ------trial 顺序------
StimIDs = [1112	1113 1114 1115 1116	1117 1118 1121 1123	1124 1125 1126 1127	1128 1131 1132 1134	1135 1136 1137 1138	1141 1142 1143	1145	1146	1147	1148	1151	1152	1153	1154	1156	1157	1158	1161	1162	1163	1164	1165	1167	1168	1171	1172	1173	1174	1175	1176	1178	1181	1182	1183	1184	1185	1186	1187	1212	1213	1214	1215	1216	1217	1218	1221	1223	1224	1225	1226	1227	1228	1231	1232	1234	1235	1236	1237	1238	1241	1242	1243	1245	1246	1247	1248	1251	1252	1253	1254	1256	1257	1258	1261	1262	1263	1264	1265	1267	1268	1271	1272	1273	1274	1275	1276	1278	1281	1282	1283	1284	1285	1286	1287	2112	2113	2114	2115	2116	2117	2118	2121	2123	2124	2125	2126	2127	2128	2131	2132	2134	2135	2136	2137	2138	2141	2142	2143	2145	2146	2147	2148	2151	2152	2153	2154	2156	2157	2158	2161	2162	2163	2164	2165	2167	2168	2171	2172	2173	2174	2175	2176	2178	2181	2182	2183	2184	2185	2186	2187	2212	2213	2214	2215	2216	2217	2218	2221	2223	2224	2225	2226	2227	2228	2231	2232	2234	2235	2236	2237	2238	2241	2242	2243	2245	2246	2247	2248	2251	2252	2253	2254	2256	2257	2258	2261	2262	2263	2264	2265	2267	2268	2271 2272 2273	2274	2275	2276	2278	2281	2282	2283	2284	2285	2286	2287]; %生成多组1:StimNum的数 1 有提示 2 无提示； 1 Target左 2 Target右
StimIDs = repmat(StimIDs,1,StimTrialNum*Blocknum/length(StimIDs));
StimIDs = StimIDs(:,randperm(StimTrialNum*Blocknum));  %进行随机化
BLorBR_IDs = repmat([1,2],1,StimTrialNum*Blocknum/2); % 1 Blue left 2 Blue right
BLorBR_IDs = BLorBR_IDs(:,randperm(StimTrialNum*Blocknum));  %进行随机化

%% 刺激呈现部分

% 初始化行为结果
Correctnum = 0;
Noresponsenum = 0;
Netural_trialnum = 0;
Target_trialnum = 0;
outp(888, 0);

% Introduction
sttext = 'Welcome to our Experiment!';
resttext = 'Take a rest!';
endtext = 'Congratulations! The exp has been finished!';
tips = 'Press SPACE key to start if getting ready';
font = 'Arial';
fontsize = 30;
Screen('TextSize', wPtr ,fontsize);
Screen('TextFont', wPtr, font);
Screen('DrawText', wPtr, sttext, 2*xCenter/3, yCenter-50, [255,255,255]);
Screen('DrawText', wPtr, tips, 1.5*xCenter/3, yCenter ,  [255,255,255]);
Screen('Flip', wPtr);
WaitSecs(2);

% 等待按键开始实验
KbWait();

%┴┬┴┬／￣＼＿／￣＼
%┬┴┬┴▏    ▏▔▔▔▔＼
%┴┬┴／＼  ／            ﹨
%┬┴∕              ／      ）
%┴┬▏                ●    ▏
%┬┴▏                      ▔█
%┴◢██◣              ＼＿＿／
%┬█████◣              ／                                            MAIN PROGRAM IS COMMING !!!
%┴█████████████◣
%◢██████████████▆▄
%◢██████████████▆▄
%█◤◢██◣◥█████████◤＼
%◥◢████ ████████◤      ＼
%┴█████  ██████◤           ﹨
%┬│      │█████◤                ▏
%┴│      │                            ▏
%┬∕      ∕        ／▔▔▔＼         ∕
%*∕＿＿_／﹨      ∕           ＼    ／＼
%┬┴┬┴┬┴＼     ＼_        ﹨／        ﹨
%┴┬┴┬┴┬┴ ＼＿＿＿＼         ﹨／▔＼   ﹨／▔＼
%▲△▲▲╓╥╥╥╥╥╥╥╥＼      ∕    ／▔﹨  ／▔﹨

%% Body Program
    for iBlock = 1:Blocknum
         outp(888, MarkerBlockBegin);
        WaitSecs(0.002);
          outp(888, 0);
        for iTrial = 1:StimTrialNum
            %颜色初始化
            clrStim = clrStim(randperm(4),:);
            clrCue([1,2],:) = clrStim([1,2],:);
            clrTest = clrStim([1,2],:);
            % 计数器
            totaltrialnum = iTrial+(iBlock-1)*StimTrialNum;
             Data(totaltrialnum).CurrentTrialColors = clrStim;
            
            % 绘制并呈现记忆刺激前的注视点
            DrawStimDisplay(wPtr, clrCross, center);
            tFixOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻
            outp(888, MarkerFixation);
            WaitSecs(0.002);
            outp(888, 0);
            
            % 绘制记忆刺激
            LocBG = [AngLeftStimlocation;AngRightStimlocation]';
            if BLorBR_IDs(totaltrialnum) == 1  % Blue Left
                StimColor = [clrStim(1,:);clrStim(2,:)]';
                DrawStimDisplay(wPtr, clrCross, center);
                Screen('FrameOval',wPtr,StimColor,LocBG,WideBar/2);
                
                BlueOri = fix(mod(StimIDs(totaltrialnum),100)/10);
                OrangeOri = mod(StimIDs(totaltrialnum),10);

                BarXY = ppd*[-5+AngStimBar_length/2*sind(BarOri(BlueOri)) -5-AngStimBar_length/2*sind(BarOri(BlueOri))...
                         5+AngStimBar_length/2*sind(BarOri(OrangeOri)) 5-AngStimBar_length/2*sind(BarOri(OrangeOri));...
                         -AngStimBar_length/2*cosd(BarOri(BlueOri)) AngStimBar_length/2*cosd(BarOri(BlueOri))...
                         -AngStimBar_length/2*cosd(BarOri(OrangeOri)) AngStimBar_length/2*cosd(BarOri(OrangeOri))];
                  Screen('DrawLines',wPtr,BarXY,WideBar,[StimColor(:,1),StimColor(:,1),StimColor(:,2),StimColor(:,2)],[xCenter,yCenter],1);
                
                Data(totaltrialnum).LeftOri = BarOri(BlueOri);
                Data(totaltrialnum).RightOri = BarOri(OrangeOri);
                Data(totaltrialnum).Leftcolor = StimColor(:,1);
                Data(totaltrialnum).Rightcolor = StimColor(:,2);
            else
                StimColor = [clrStim(2,:);clrStim(1,:)]';
                DrawStimDisplay(wPtr, clrCross, center);
                Screen('FrameOval',wPtr,StimColor,LocBG,WideBar/2)
                
                BlueOri = mod(StimIDs(totaltrialnum),10);
                OrangeOri = fix(mod(StimIDs(totaltrialnum),100)/10);

                BarXY = ppd*[-5+AngStimBar_length/2*sind(BarOri(OrangeOri)) -5-AngStimBar_length/2*sind(BarOri(OrangeOri))...
                         5+AngStimBar_length/2*sind(BarOri(BlueOri)) 5-AngStimBar_length/2*sind(BarOri(BlueOri));...
                         -AngStimBar_length/2*cosd(BarOri(OrangeOri)) AngStimBar_length/2*cosd(BarOri(OrangeOri))...
                         -AngStimBar_length/2*cosd(BarOri(BlueOri)) AngStimBar_length/2*cosd(BarOri(BlueOri))];
                Screen('DrawLines',wPtr,BarXY,WideBar,[StimColor(:,1),StimColor(:,1),StimColor(:,2),StimColor(:,2)],[xCenter,yCenter],1);
                
                Data(totaltrialnum).RightOri = BarOri(BlueOri);
                Data(totaltrialnum).LeftOri = BarOri(OrangeOri);
                Data(totaltrialnum).Leftcolor = StimColor(:,1);
                Data(totaltrialnum).Rightcolor = StimColor(:,2);
            end
                tMemoryOnset = Screen('Flip', wPtr, tFixOnset + tPreFix - slack);
            
                outp(888, fix(StimIDs(1,totaltrialnum)/100));
                WaitSecs(0.002);
                 outp(888, 0);

            % 绘制并呈现 memory 和 retro-cue 间的注视点
            DrawStimDisplay(wPtr, clrCross, center);
            tMemoryCueOnset = Screen('Flip', wPtr, tMemoryOnset + tMemory - slack); %呈现注视点，记录呈现时刻
            outp(888, MarkerFixation);
            WaitSecs(0.002);
            outp(888, 0);
            
            % 绘制并呈现 retro-cue
            if (fix(StimIDs(1,totaltrialnum)/1000) == 1 && fix(mod(StimIDs(1,totaltrialnum),1000)/100) == 1)% target-cue tl
                if BLorBR_IDs(totaltrialnum) == 1  % Blue Left
                   RetroCueClr = 1;
                else
                    RetroCueClr = 2;
                end
            elseif (fix(StimIDs(1,totaltrialnum)/1000) == 1 && fix(mod(StimIDs(1,totaltrialnum),1000)/100) == 2)% target-cue tr
                if BLorBR_IDs(totaltrialnum) == 1  % Blue Left
                    RetroCueClr = 2;
                else
                    RetroCueClr = 1;
                end
            else
                RetroCueClr = 3;
            end
                    MarkerRetrocue = fix(StimIDs(1,totaltrialnum)/100)*10+RetroCueClr; %  
                    DrawStimDisplay(wPtr, clrCue(RetroCueClr,:), center);
       %             Screen('FrameOval',wPtr,StimColor,LocBG,WideBar/4);
                   Data(totaltrialnum).RetroCueClr = clrCue(RetroCueClr,:);
              
            tRetroCueOnset = Screen('Flip', wPtr, tMemoryCueOnset + tMemoryCueDuration - slack); %呈现注视点，记录呈现时刻
            outp(888, MarkerRetrocue);
            WaitSecs(0.002);
            outp(888, 0);
            
            
            % 绘制并呈现 retro-cue 和 test 间的注视点
            DrawStimDisplay(wPtr, clrCross, center);
            tCueTestOnset = Screen('Flip', wPtr, tRetroCueOnset + tCue - slack); %呈现注视点，记录呈现时刻
            outp(888, MarkerFixation);
            WaitSecs(0.002);
            outp(888, 0);
            
            
            % 绘制并呈现Test刺激
            TestOriginOri = fix(180*rand+1);
            if TestOriginOri > 90
               Data(totaltrialnum).TestOriginOri = TestOriginOri-180;
            else
               Data(totaltrialnum).TestOriginOri = TestOriginOri;
            end
            TestRect = [xCenter-StimBar_length/2,yCenter-StimBar_length/2,xCenter+StimBar_length/2,yCenter+StimBar_length/2;...
                        xCenter-StimBar_length/2*sind(TestOriginOri)-0.3*ppd,yCenter+StimBar_length/2*cosd(TestOriginOri)-0.3*ppd,xCenter-StimBar_length/2*sind(TestOriginOri)+0.3*ppd,yCenter+StimBar_length/2*cosd(TestOriginOri)+0.3*ppd;...
                        xCenter+StimBar_length/2*sind(TestOriginOri)-0.3*ppd,yCenter-StimBar_length/2*cosd(TestOriginOri)-0.3*ppd,xCenter+StimBar_length/2*sind(TestOriginOri)+0.3*ppd,yCenter-StimBar_length/2*cosd(TestOriginOri)+0.3*ppd]';
                    
            if fix(mod(StimIDs(1,totaltrialnum),1000)/100) == 1  
                    answerangle = Data(totaltrialnum).LeftOri;
                    testClr = StimColor(:,1)';
                else
                    answerangle = Data(totaltrialnum).RightOri;
                    testClr = StimColor(:,2)';
            end
                
            Data(totaltrialnum).AnswerAng = answerangle;

            DrawStimDisplay(wPtr, testClr, center);
            Data(totaltrialnum).TestClr = testClr;
            Screen('FrameOval',wPtr,[testClr;clrCross;clrCross]',TestRect,WideBar/2);
                   
            tTestOnset = Screen('Flip', wPtr, tCueTestOnset + tCueStimDuration - slack); %呈现注视点，记录呈现时刻
            outp(888, testClr);
            WaitSecs(0.002);
            outp(888, 0);
            
            
%             WaitSetMouse(xCenter,yCenter,1);
            
            %等待按键响应并记录数据
            while GetSecs - tTestOnset <= response_interval
                [keyisdown,secs, keyCode, deltaSecs] = KbCheck;
                ShowCursor('Hand',wPtr);
                [x, y, buttons] = GetMouse(wPtr);
                theta = -atand((x - xCenter)/(y - yCenter));
                TestRect = [xCenter-StimBar_length/2,yCenter-StimBar_length/2,xCenter+StimBar_length/2,yCenter+StimBar_length/2;...
                        xCenter+StimBar_length/2*sind(theta)-0.3*ppd,yCenter-StimBar_length/2*cosd(theta)-0.3*ppd,xCenter+StimBar_length/2*sind(theta)+0.3*ppd,yCenter-StimBar_length/2*cosd(theta)+0.3*ppd;...
                        xCenter-StimBar_length/2*sind(theta)-0.3*ppd,yCenter+StimBar_length/2*cosd(theta)-0.3*ppd,xCenter-StimBar_length/2*sind(theta)+0.3*ppd,yCenter+StimBar_length/2*cosd(theta)+0.3*ppd]';
                
                DrawStimDisplay(wPtr, testClr, center);
                Screen('FrameOval',wPtr,[testClr;clrCross;clrCross]',TestRect,WideBar/2);
                Screen('Flip', wPtr); %
                              
              if (buttons(1))
                    rt = GetSecs - tTestOnset;
                    Data(totaltrialnum).ResponseAng = -atand((x - xCenter)/(y - yCenter));
                    responseangle = Data(totaltrialnum).ResponseAng;
                    difangle = responseangle - answerangle;
                    if difangle > 90
                       difangle = difangle - 180;
                    end
                    if difangle < -90
                       difangle = difangle + 180;
                    end
                    if fix(StimIDs(1,totaltrialnum)/1000) == 1
                        fprintf('\n\nBlockNum=%f\nCondition=TargetCue\nTrialnum=%f\nRt=%f\nPrecision=%f%',iBlock,iTrial,rt,difangle)
                    else
                        fprintf('\n\nBlockNum=%f\nCondition=NeturalCue\nTrialnum=%f\nRt=%f\nPrecision=%f%',iBlock,iTrial,rt,difangle)
                    end
                    break;
%                 elseif find(keyCode)== Esckey % 退出
%                  Screen('CloseAll');
%                  break
                elseif GetSecs - tTestOnset >= response_interval
                    Data(totaltrialnum).ResponseAng = 999;
                    rt = 999;
                    responseangle = 999;
                    difangle = 999;
                    fprintf('\n\nBlockNum=%f\nTrialnum=%f\nRt=%f\nPrecision=%f%',iBlock,iTrial,rt,difangle)
               end

            end
            
              
            if ( difangle <= 10 && difangle >= -10)
                outp(888, MarkerCorrectResponse);
                WaitSecs(0.002);
                outp(888, 0);
                Correctnum = Correctnum +1;
                Data(totaltrialnum).Feedback = 1;
            elseif difangle == 999
                outp(888, MarkerNoResponse);
                WaitSecs(0.002);
                outp(888, 0);
                Noresponsenum = Noresponsenum +1;
                 Data(totaltrialnum).Feedback = 0;
           else
                outp(888, MarkerWrongResponse);
                WaitSecs(0.002);
                outp(888, 0);
                Data(totaltrialnum).Feedback = 0;
            end  
            
            %
            
            clear barXY LocBG
            HideCursor(nMonitorID); %隐藏指针
 
            % 绘制并呈现按键反应后的注视点
%              if (difangle > -20 && difangle < 20)
%                  ClrFeedback = [0,255,0];
%              else
%                  ClrFeedback = [255,0,0];
%              end
%             DrawStimDisplay(wPtr, ClrFeedback, center);
%             tFeedbackonset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻
%             WaitSecs(tFeedback);
%             DrawStimDisplay(wPtr, ClrFeedback, center);
%             tAfteresponse = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻
                AnswerRect = [xCenter-StimBar_length/2,yCenter-StimBar_length/2,xCenter+StimBar_length/2,yCenter+StimBar_length/2;...
                        xCenter+StimBar_length/2*sind(answerangle)-0.3*ppd,yCenter-StimBar_length/2*cosd(answerangle)-0.3*ppd,xCenter+StimBar_length/2*sind(answerangle)+0.3*ppd,yCenter-StimBar_length/2*cosd(answerangle)+0.3*ppd;...
                        xCenter-StimBar_length/2*sind(answerangle)-0.3*ppd,yCenter+StimBar_length/2*cosd(answerangle)-0.3*ppd,xCenter-StimBar_length/2*sind(answerangle)+0.3*ppd,yCenter+StimBar_length/2*cosd(answerangle)+0.3*ppd]';
                
                DrawStimDisplay(wPtr, testClr, center);
                Screen('FrameOval',wPtr,[testClr;testClr;testClr]',AnswerRect,WideBar/2);
                tFeedbackOnset = Screen('Flip', wPtr); %
                WaitSecs(tFeedback);
                
             % 绘制并呈现注视点
            DrawStimDisplay(wPtr, clrCross, center);
            tFixOnset = Screen('Flip', wPtr); %呈现注视点，记录呈现时刻
            WaitSecs(tITI);

            
            %% 记录数据
            Data(totaltrialnum).BlockNum = iBlock;
            Data(totaltrialnum).TrialNum = iTrial;
            Data(totaltrialnum).itrials = totaltrialnum;
            Data(totaltrialnum).DifAngle = difangle;
            Data(totaltrialnum).RTs = rt;
           
            % calculate behavioral results
            if fix(StimIDs(1,totaltrialnum)/1000) == 1
                Data(totaltrialnum).Condition = 1;
                Target_trialnum = Target_trialnum +1;
                Targettrials_DifAngle(Target_trialnum) = difangle;
                Targettrials_Sd(Target_trialnum) = difangle*difangle;
                Targettrials_Rts(Target_trialnum) = rt;                
            else
                Data(totaltrialnum).Condition = 0;
                Netural_trialnum = Netural_trialnum +1;
                Neturaltrials_DifAngle(Netural_trialnum) = difangle;
                Neturaltrials_Sd(Netural_trialnum) = difangle*difangle;
                Neturaltrials_Rts(Netural_trialnum) = rt;                
            end
                        
        end
            Neturaldif = mean(abs(Neturaltrials_DifAngle(Neturaltrials_DifAngle~=999)));
            Targetdif = mean(abs(Targettrials_DifAngle(Targettrials_DifAngle~=999)));
            RtNetural = mean(Neturaltrials_Rts(Neturaltrials_Rts~=999));
            RtTarget = mean(Targettrials_Rts(Targettrials_Rts~=999));             
            TargetSd = mean(Targettrials_Sd(Targettrials_Sd~=999))*length(Targettrials_Sd(Targettrials_Sd~=999))/(length(Targettrials_Sd(Targettrials_Sd~=999))-1);
            NeturalSd = mean(Neturaltrials_Sd(Neturaltrials_Sd~=999))*length(Neturaltrials_Sd(Neturaltrials_Sd~=999))/(length(Neturaltrials_Sd(Neturaltrials_Sd~=999))-1);
%             
        fprintf('\n\nBlockNum=%f\nDifAngle_Netural=%f\nRts_Netural=%f%',iBlock,Neturaldif,RtNetural)
        fprintf('\n\nBlockNum=%f\nDifAngle_Target=%f\nRts_Target=%f%',iBlock,Targetdif,RtTarget)
        fprintf('\n\nNoresponsenum=%f%',Noresponsenum)
       
        Screen('TextSize', wPtr ,fontsize);
        Screen('TextFont', wPtr, font);
        Screen('DrawText', wPtr, resttext, xCenter-10, yCenter-10,  [255,255,255]);
        Screen('Flip', wPtr);
         outp(888, MarkerBlockEnd);
        WaitSecs(0.002);
         outp(888, 0);
        WaitSecs(30);
        behaviordataname=strcat('sub',subinfo{1},'_',subinfo{2},'_',subinfo{8},'_',num2str(GetSecs),'.mat');
       save([path,behaviordataname],'Data','NeturalSd','TargetSd','RtNetural','RtTarget','Neturaldif','Targetdif');
       
        Screen('DrawText', wPtr, tips, 1.5*xCenter/3, yCenter-10,  [255,255,255]);
        Screen('Flip', wPtr);
        
        % 等待按键开始实验
        KbWait();
  
    end

    %% 保存数据
    behaviordataname=strcat('sub',subinfo{1},'_Precision.mat');
    save([path,behaviordataname],'Data','NeturalSd','TargetSd','RtNetural','RtTarget','Neturaldif','Targetdif');
    
    Screen('TextSize', wPtr ,fontsize);
    Screen('TextFont', wPtr, font);
    Screen('DrawText', wPtr, endtext, xCenter-30, yCenter-10,  [255,255,255]);
    Screen('Flip', wPtr);
    
    % 等待按键结束实验
    KbWait();
    
    %% 关闭窗口
    Screen('CloseAll');
    end
%    


