%% Copyright (C) 2017 c34031328
%% 
%% This program is free software; you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 3 of the License, or
%% (at your option) any later version.
%% 
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%% 
%% You should have received a copy of the GNU General Public License
%% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%% Author: c34031328 c34031328@mail.ncku.edu.tw
%% Created: 2017-05-26


% matrix store Cnm Snm, because matlab start from 1,
% Cnm Snm start from 0, so use a function access.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 計算重力異常與大地起伏 %%

% 由於 matlab 陣列從 0 開始，
% 只能用一個函數模擬陣列。
% 例如 Cnm(0,0) 即為 C00。

mCnm = 1E-9 * [
    0 0 0 0
    0 0 0 0
    -484165.14 -0.21 2439.38 0
    957.16 2029.99 904.79 721.32
];
mSnm = 1E-9 * [
    0 0 0 0
    0 0 0 0
    0 1.38 -1400.27 0
    0 248.20 -169.01 1414.35
];

Cnm = @(n,m) mCnm(n+1,m+1);
Snm = @(n,m) mSnm(n+1,m+1);

mCNnm = [
    0 0 0 0
    0 0 0 0
    -0.484166774985E-03 0 0 0
    0 0 0 0
];
CNnm = @(n,m) mCNnm(n+1,m+1);
SNnm = @(n,m) 0;  % SNnm 皆為 0

% CTnm、STnm 即為 Cnm - CNnm
CTnm = @(n,m) Cnm(n,m) - CNnm(n,m);
STnm = @(n,m) Snm(n,m) - SNnm(n,m);

% Pnm 使用內建函數 legendre 計算
% for legendre retern value,
% legendre()(0) mean m = 1.
Pnm = @(n,m,x) legendre(n,x,'norm')(m+1);

% 計算 CTnm*cos(m*l) + STnm*cos(m*l)
CSTnm = @(n,m,l) (
    CTnm(n,m) * cos(m*l) +
    STnm(n,m) * sin(m*l)
);

% 常數設定
GM = 3986005E+8;
R = 6378137;

% Tn = Sum (m=0:n) Pnm(cos th) * CSTnm
Tn = @(n,th,l) (
    GM/R*reduce(
        @(s,m) s + Pnm(n,m,cos(th)) * CSTnm(n,m,l),
        [0:n],
        0
    )
);

% 重力異常只要計算 n = 2,3，0,1 皆為 0。
anomaly_g = @(th,l) (
    reduce(
        @(s,n) s + (n-1) * Tn(n,th,l),
        [2 3],
        0
    ) / R
);

% 大地起伏
% 和上面相同，另一種寫死的寫法。
geoid_undulation = @(th,l) (
    (Tn(2,th,l) + Tn(3,th,l)) / GM * R^2
);

% 傳入一個函數，對所有經度、緯度呼叫該函數，
% 回傳所有經緯度值組成的陣列。
% 第一個參數為 function handle，
% 第二個參數為二維陣列，分別為取樣密度，
% 第一個為緯度，第二個為經度。
function area_data = fill_earth (function_handle, part)
    area_data = zeros(part);
    th_tic = pi/part(1);
    l_tic = pi*2/part(2);
    for i = 1:part(1)
        for j = 1:part(2)
            area_data(i,j) = function_handle(i*th_tic, j*l_tic);
        end
    end
end

%% 計算重力異常並繪圖
% anomaly_g_180x360 = fill_earth(anomaly_g,[180,360]);
%% 用等高線圖，因為黑白影印用漸層看不太出來。
% contour(anomaly_g_180x360);
% <img src="gravity_anomaly.png">

%% 計算大地起伏並繪圖
% geoid_undulation_180x360 = fill_earth(geoid_undulation, [180,360]);
% contour(geoid_undulation_180x360);
%% <img src="geoid_undulation.png">

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 用 stoke formula 計算重力 %%

% 一經緯度面積
unit_square = (2*pi*R/180)^2;

% 在不同緯度的面積
unit_square_th = @(th) unit_square*cos(th);

% 兩點經緯度之間的球面角
sphere_angle = @(th, l, dth, dl) (
    acos(
        cos (th) * cos (dth) +
        sin (th) * sin (dth) * cos (l - dl)
    )
);

% S(psi) 函數，psi 為球面角。
stoke_s = @(ps) (
    1/sin(ps/2) -
    6*sin(ps/2) + 1 -
    5*cos(ps) -
    3*cos(ps) * log( sin(ps/2) + sin(ps/2)^2 )
);

% 用網格計算面積分，計算 r 點重力異常對 n 點大地起伏的貢獻。
% 但計算出來的值怪怪的，也許是 S(psi) 的計算出問題。
stoke_i = @(n_th, n_l, r_th, r_l) (
    stoke_s(sphere_angle(n_th, n_l, r_th, r_l)) *
    unit_square_th(r_th) *
    anomaly_g(pi/2-r_th, r_l)
);
