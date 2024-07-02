function ma=randstima(cuenum)
switch cuenum%to decide the direction of target and distrator
        case 1
            tarindex=randi([1,6],1,1);
            if tarindex==1
                connum=1;
                ma=11;
            else if tarindex==6
                    connum=3;
                    ma=13;
                else connum=2;ma=12;
                end
            end
        case 2
            tarindex=randi([1,6],1,1);
            if tarindex==1
                connum=1;ma=21;
            else if tarindex==6
                    connum=3;ma=23;
                else connum=2;ma=22;
                end
            end
        case 3
            connum=1;ma=31;
end
end