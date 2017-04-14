#!/usr/bin/env octave

mw = @(w) ([
    1 0 0
    0 cos(w) sin(w)
    0 -sin(w) cos(w)
]);


mf = @(f) ([
    cos(f) 0 -sin(f)
    0 1 0
    sin(f) 0 cos(f)
]);

mk = @(k) ([
    cos(k) sin(k) 0
    -sin(k) cos(k) 0
    0 0 1
]);

wfk = @(w, f, k) mk (k) * mf (f) * mw (w);

if size(argv()) == [3 1]
    degree = zeros(1,3);
    for i = 1:3
        degree(i) = str2num(argv(){i});
    end
else
    do
        degree = input("please input [omega phi kapa]: \n");
    until size(degree) == [1 3]
end

disp(mk(degree(3)) * mf(degree(2)) * mw(degree(1)));

