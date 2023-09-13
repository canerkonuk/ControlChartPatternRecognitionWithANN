clc;
clear;
clear all;
close all;

dim1=input('Her oruntu icin ornek sayisini giriniz n =');
dim2=input('Her oruntu icin sinyal sayisini giriniz m =');

%NORMAL
mu=80; sigma=5;
n=dim1;
m=dim2;
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
ynormal(i,j)=mu+(R(j)*sigma);
end
end

%TEKRARLAYAN CEVRIM
mu=80; sigma=5;T=8;
n=dim1;
m=dim2;
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
a = (1.5*sigma) + ((2.5*sigma)-(1.5*sigma)) * rand(1, 1);              
ycyclic(i,j)=mu+R(j)*sigma+a*sin((2*pi*j)/T);
end
end

%SISTEMATIK
mu=80; sigma=5;
n=dim1;
m=dim2;
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
d = (1*sigma) + ((3*sigma)-(1*sigma)) * rand(1, 1); 
ysystematic(i,j)=mu+(R(j)*sigma)+d*(-1)^j;
end
end 


%ARTAN TREND
mu=80; sigma=5;
n=dim1;
m=dim2;
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
g = (0.05*sigma) + ((0.1*sigma)-(0.05*sigma)) * rand(1, 1);              
yincretrend(i,j)=mu+(R(j)*sigma)+((j)*g);
end
end

%AZALAN TREND
mu=80; sigma=5;
n=dim1;
m=dim2;
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
g = (0.05*sigma) + ((0.1*sigma)-(0.05*sigma)) * rand(1, 1);            
ydectrend(i,j)=mu+(R(j)*sigma)-((j)*g);
end
end 

%YUKARI ANI DEGISIM
mu=80; sigma=5; k1=0; k2=1;
n=dim1;
m=dim2/2;
Z1=zeros([n m]);
Z2=zeros([n m]);
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
s = (1.5*sigma) + ((2.5*sigma)-(1.5*sigma)) * rand(1, 1); 
Y1=mu+(R(j)*sigma)+(k1*s);
Y2=mu+(R(j)*sigma)+(k2*s);
X1(i)=sum(Y1);
X2(i)=sum(Y2);
Z1(i,j)=Y1;
Z2(i,j)=Y2;
end
end
Z=[Z1 Z2];

%ASAGI ANI DEGISIM
mu=80; sigma=5; k1=0; k2=1;
n=dim1;
m=dim2/2;
Z3=zeros([n m]);
Z4=zeros([n m]);
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
s = (1.5*sigma) + ((2.5*sigma)-(1.5*sigma)) * rand(1, 1); 
Y1=mu+(R(j)*sigma)-(k1*s);
Y2=mu+(R(j)*sigma)-(k2*s);
X1(i)=sum(Y1);
X2(i)=sum(Y2);
Z3(i,j)=Y1;
Z4(i,j)=Y2;
end
end
A=[Z3 Z4];

%TEKRARLAYAN CEVRIM + ARTAN TREND
mu=80; sigma=5;T=8;
n=dim1;
m=dim2;
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
a = (1.5*sigma) + ((2.5*sigma)-(1.5*sigma)) * rand(1, 1);             
g = (0.05*sigma) + ((0.1*sigma)-(0.05*sigma)) * rand(1, 1); 
ycUT(i,j)=mu+(R(j)*sigma)+a*sin((2*pi*j)/T)+((j)*g);
end
end

%TEKRARLAYAN CEVRIM + AZALAN TREND
mu=80; sigma=5;T=8;
n=dim1;
m=dim2;
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
a = (1.5*sigma) + ((2.5*sigma)-(1.5*sigma)) * rand(1, 1);            
g = (0.05*sigma) + ((0.1*sigma)-(0.05*sigma)) * rand(1, 1); 
ycDT(i,j)=mu+(R(j)*sigma)+a*sin((2*pi*j)/T)-((j)*g);
end
end

%TEKRARLAYAN CEVRIM + YUKARI ANI DEGISIM
mu=80; sigma=5;T=8; k1=0; k2=1;
n=dim1;
m=dim2/2;
Z1=zeros([n m]);Z2=zeros([n m]);
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
a = (1.5*sigma) + ((2.5*sigma)-(1.5*sigma)) * rand(1, 1);
s = (1.5*sigma) + ((2.5*sigma)-(1.5*sigma)) * rand(1, 1); 
Y1=mu+(R(j)*sigma)+a*sin((2*pi*j)/T)+(k1*s);
Y2=mu+(R(j)*sigma)+a*sin((2*pi*j)/T)+(k2*s);
X1(i)=sum(Y1);
X2(i)=sum(Y2);
Z1(i,j)=Y1;
Z2(i,j)=Y2;
end
end
ycUS=[Z1 Z2];

%TEKRARLAYAN CEVRIM + ASAGI ANI DEGISIM
mu=80; sigma=5;T=8; k1=0; k2=1;
n=dim1;
m=dim2/2;
Z1=zeros([n m]);Z2=zeros([n m]);
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
a = (1.5*sigma) + ((2.5*sigma)-(1.5*sigma)) * rand(1, 1);
s = (1.5*sigma) + ((2.5*sigma)-(1.5*sigma)) * rand(1, 1); 
Y1=mu+(R(j)*sigma)+a*sin((2*pi*j)/T)-(k1*s);
Y2=mu+(R(j)*sigma)+a*sin((2*pi*j)/T)-(k2*s);
X1(i)=sum(Y1);
X2(i)=sum(Y2);
Z1(i,j)=Y1;
Z2(i,j)=Y2;
end
end
ycDS=[Z1 Z2];


%ARTAN TREND + SISTEMATIK
mu=80; sigma=5;
n=dim1;
m=dim2;
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
g = (0.05*sigma) + ((0.1*sigma)-(0.05*sigma)) * rand(1, 1);               
d = (1*sigma) + ((3*sigma)-(1*sigma)) * rand(1, 1);
yUTs(i,j)=mu+(R(j)*sigma)+((j)*g)+(d*(-1)^j);
end
end

%AZALAN TREND + SISTEMATIK
mu=80; sigma=5;
n=dim1;
m=dim2;
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
g = (0.05*sigma) + ((0.1*sigma)-(0.05*sigma)) * rand(1, 1);               
d = (1*sigma) + ((3*sigma)-(1*sigma)) * rand(1, 1);
yDTs(i,j)=mu+(R(j)*sigma)-((j)*g)+(d*(-1)^j);
end
end

%YUKARI ANI DEGISIM + SISTEMATIK
mu=80; sigma=5; k1=0; k2=1;
n=dim1;
m=dim2/2;
Z1=zeros([n m]);Z2=zeros([n m]);
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
s = (1.5*sigma) + ((2.5*sigma)-(1.5*sigma)) * rand(1, 1); 
d = (1*sigma) + ((3*sigma)-(1*sigma)) * rand(1, 1);
Y1=mu+(R(j)*sigma)+(k1*s)+d*(-1)^j;
Y2=mu+(R(j)*sigma)+(k2*s)+d*(-1)^j;
X1(i)=sum(Y1);
X2(i)=sum(Y2);
Z1(i,j)=Y1;
Z2(i,j)=Y2;
end
end
yUSs=[Z1 Z2];


%ASAGI ANI DEGISIM + SISTEMATIK
mu=80; sigma=5; k1=0; k2=1;
n=dim1;
m=dim2/2;
Z1=zeros([n m]);Z2=zeros([n m]);
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
s = (1.5*sigma) + ((2.5*sigma)-(1.5*sigma)) * rand(1, 1); 
d = (1*sigma) + ((3*sigma)-(1*sigma)) * rand(1, 1);
Y1=mu+(R(j)*sigma)-(k1*s)+d*(-1)^j;
Y2=mu+(R(j)*sigma)-(k2*s)+d*(-1)^j;
X1(i)=sum(Y1);
X2(i)=sum(Y2);
Z1(i,j)=Y1;
Z2(i,j)=Y2;
end
end
yDSs=[Z1 Z2];

%TEKRARLAYAN CEVRIMLER + SISTEMATIK
mu=80; sigma=5;T=8;
n=dim1;
m=dim2;
for i=1:n
for j=1:m
R(j)= random('Normal',0,1,1);
a = (1.5*sigma) + ((2.5*sigma)-(1.5*sigma)) * rand(1, 1);              
d = (1*sigma) + ((3*sigma)-(1*sigma)) * rand(1, 1); 
yCYs(i,j)=mu+R(j)*sigma+a*sin((2*pi*j)/T)+d*(-1)^j;
end
end


%Verisetinin olusturulmasý:
B=[ynormal; ycyclic; ysystematic; yincretrend; ydectrend; Z; A; ycUT; ycDT; ycUS; ycDS; yUTs; yDTs; yUSs; yDSs; yCYs];
