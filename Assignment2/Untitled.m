clc,clear;
A = fix(10*rand(3,3));
b = fix(10*rand(3,1));
c = A*b;
determinant = det(A);
%%b=b';
x = A\b;
lambda = eig(A);

%%create a random 512x1 matrix
A = fix(10*rand(512,1));

%% calculate the Fourier Transform of E
E = fft(A);
E = abs(E);
plot(E)