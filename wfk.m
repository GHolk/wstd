# Created by Octave 4.0.3, Wed Apr 12 21:55:24 2017 CST <c34031328@hmjs>
# name: mw
# type: function handle
@<anonymous>
@(w) [1, 0, 0; 0, cos(w), sin(w); 0, -sin(w), cos(w)]


# name: mf
# type: function handle
@<anonymous>
@(f) [cos(f), 0, -sin(f); 0, 1, 0; sin(f), 0, cos(f)]


# name: mk
# type: function handle
@<anonymous>
@(k) [cos(k), sin(k), 0; -sin(k), cos(k), 0; 0, 0, 1]


# name: wfk
# type: function handle
@<anonymous>
@(w, f, k) mk (k) * mf (f) * mw (w)
# length: 3
# name: mf
# type: function handle
@<anonymous>
@(f) [cos(f), 0, -sin(f); 0, 1, 0; sin(f), 0, cos(f)]


# name: mk
# type: function handle
@<anonymous>
@(k) [cos(k), sin(k), 0; -sin(k), cos(k), 0; 0, 0, 1]


# name: mw
# type: function handle
@<anonymous>
@(w) [1, 0, 0; 0, cos(w), sin(w); 0, -sin(w), cos(w)]




