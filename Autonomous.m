function [] = Autonomous(net,destination,handles)
vid1=handles.vidobj1;
vid2=handles.vidobj2;
parport=handles.portobject;
%This function is called whenever the bot is functioning in autonomous mode
%   This function calls all other function that perform the text extraction
%   and recognition and then based on it takes decsion
[img_data centroid rect]=navigation(vid1,vid2,parport);
img_data=double(img_data);
op=sim(net,img_data);
[max_rec rec_char]=max(op);
s=size(centroid);
total=sum(centroid(2,:));
avg=total/s(2);
k=1;j=1;
str1=[];str2=[];

for i=1:s(2)
    if (centroid(2,i)< avg)
        if (max_rec(i)>0.9)
            
            if (k==1)
                character=char(64+rec_char(i));
                str1=strcat(str1,character);
                
            else
                distbwcent=centroid(1,i)-centroid(1,temp1);
                sumofwidth=(rect(i,3))/2 + (rect(temp1,3))/2;
                if (distbwcent>sumofwidth+20)
                    character=char(64+rec_char(i));
                    str1=strcat(str1,',',character);
                else
                    character=char(64+rec_char(i));
                    str1=strcat(str1,character);
                end
                
            end
            temp1=i;
            k=k+1;
        end
    else
        if (max_rec(i)>0.5)
            
            if (j==1)
                character=char(64+rec_char(i));
                str2=strcat(str2,character);
                
            else
                distbwcent=centroid(1,i)-centroid(1,temp2);
                sumofwidth=(rect(i,3))/2 + (rect(temp2,3))/2;
                if (distbwcent>sumofwidth+20)
                    character=char(64+rec_char(i));
                    str2=strcat(str2,',',character);
                else
                    character=char(64+rec_char(i));
                    str2=strcat(str2,character);
                end
                
            end
            temp2=i;
            j=j+1;
        end
    end
end
str1 
str2 

if (findstr(destination,str1))
    if(~isempty(findstr('left',str1)))
        bvdata=logical([1 0 1 0 0 0 0 0]);
        putvalue(parport,bvdata);
        pause(0.5);
        bvdata=logical([0 0 0 0 0 0 0 0]);
        putvalue(parport,bvdata);
    elseif (findstr('right',str1))
        bvdata=logical([0 1 0 1 0 0 0 0]);
        putvalue(parport,bvdata);
        pause(0.5);
        bvdata=logical([0 0 0 0 0 0 0 0]);
        putvalue(parport,bvdata);
    end

elseif (findstr(destination,str2))
    if(findstr('left',str1))
        bvdata=logical([1 0 1 0 0 0 0 0]);
        putvalue(parport,bvdata);
        pause(0.5);
        bvdata=logical([0 0 0 0 0 0 0 0]);
        putvalue(parport,bvdata);
    elseif (findstr('right',str2))
        bvdata=logical([0 1 0 1 0 0 0 0]);
        putvalue(parport,bvdata);
        pause(0.5);
        bvdata=logical([0 0 0 0 0 0 0 0]);
        putvalue(parport,bvdata);
    end
else
                
end

