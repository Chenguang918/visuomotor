function cuenum=randcuenum(cueindex)
% 确定刺激类型
 if cueindex==1||cueindex==2||cueindex==3
        cuenum=1;
 else if cueindex==4||cueindex==5||cueindex==6
         cuenum=2;
     else if cueindex==7||cueindex==8
             cuenum=3;
         end
     end
 end