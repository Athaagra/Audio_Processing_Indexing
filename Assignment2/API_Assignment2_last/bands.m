function bands = bands(matrix1)
c=0;
up=zeros(1,length(matrix1));
down=zeros(1,length(matrix1));
empty=zeros(1,length(matrix1));
for C=2:length(matrix1)
    c = c +1;
    if matrix1(c)>matrix1(C)
        up(c) = [matrix1(c)];
    elseif matrix1(c)<= 0
        empty(c) = [matrix1(c)];
    else
        down(c) = [matrix1(C)];
    end
end
up = nonzeros(up);
down = nonzeros(down);

empty = (length(up) + length(down)) - 8000;
name_bands = categorical({'up bands','down bands','empty bands'});
bands = [length(up),length(down),empty];
bar(name_bands,bands)
title('Piano wav bands')