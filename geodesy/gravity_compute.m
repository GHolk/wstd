## Copyright (C) 2017 c34031328
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## Author: c34031328 c34031328@mail.ncku.edu.tw
## Created: 2017-05-26


# matrix store Cnm Snm, because matlab start from 1,
# Cnm Snm start from 0, so use a function access.
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
SNnm = @(n,m) 0;

CTnm = @(n,m) Cnm(n,m) - CNnm(n,m);
STnm = @(n,m) Snm(n,m) - SNnm(n,m);

# for legendre retern value,
# legendre()(0) mean m = 1.
Pnm = @(n,m,x) legendre(n,x,'norm')(m+1);

CSTnm = @(n,m,l) (
    CTnm(n,m) * cos(m*l) +
    STnm(n,m) * sin(m*l)
);

GM = 3986005E+8;
R = 6378137;

Tn = @(n,th,l) (
    GM/R*reduce(
        @(s,m) s + Pnm(n,m,cos(th)) * CSTnm(n,m,l),
        [0:n],
        0
    )
);

anomaly_g = @(th,l) (
    reduce(
        @(s,n) s + (n-1) * Tn(n,th,l),
        [2 3],
        0
    ) / R
);

geoid_undulation = @(th,l) (
    (Tn(2,th,l) + Tn(3,th,l)) / GM * R^2
);

function area_data = fill_earth (function_handle, part)
    area_data = zeros(part);
    th_tic = pi/part(1);
    l_tic = pi*2/part(2);
    for i = 1:part(1)
        for j = 1:part(2)
            area_data(i,j) = function_handle(i*th_tic, j*l_tic);
        endfor
    endfor
endfunction

unit_square = (2*pi*R/180)^2;
unit_square_th = @(th) unit_square*cos(th);

sphere_angle = @(th, l, dth, dl) (
    acos(
        cos (th) * cos (dth) +
        sin (th) * sin (dth) * cos (l - dl)
    )
);


stoke_s = @(ps) (
    1/sin(ps/2) -
    6*sin(ps/2) + 1 -
    5*cos(ps) -
    3*cos(ps) * log( sin(ps/2) + sin(ps/2)^2 )
);

stoke_i = @(n_th, n_l, r_th, r_l) (
    stoke_s(sphere_angle(n_th, n_l, r_th, r_l)) *
    unit_square_th(r_th) *
    anomaly_g(pi/2-r_th, r_l)
);

#stoke_n = @