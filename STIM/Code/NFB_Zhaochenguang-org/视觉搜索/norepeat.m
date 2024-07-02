function index1=norepeat(a,b,blockindex,ntrial,A)
index1=randi([a,b],1,1);
if ntrial>=3
    while index1==A(blockindex,ntrial-1)&&A(blockindex,ntrial-1)==A(blockindex,ntrial-2)
        index1=randi([a,b],1,1);
    end   
end
end
