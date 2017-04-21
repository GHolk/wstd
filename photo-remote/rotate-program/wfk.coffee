
class Matrix3
# Matrix3 is 2 demition array,
# access m(i,j) by m[i][j].

    constructor: (a = 0) ->
    # a = number, [1,2,3,4,5,6,7,8,9], [[1,2,3],[4,5,6],[7,8,9]].
    # if no arguments, a = 0.
        a = [1..9].map( -> a ) if typeof a == 'number'

        if a.length >= 9
            for i in [0..2]
                this[i] = a.slice i*3,(i+1)*3
        else if a.length >= 3
            for i in [0..2]
                this[i] = a[i].slice 0
        else
            throw new Error 'arguments not array!'

    size: [3,3] # Matrix3 is [3,3] matrix.

    forEach: (callback) ->
    # callback will get 3 argument v,i,m, 
    # v = current value, i = [row, col], m = matrix it self.
    # row first order.
        for i in [0..2]
            for j in [0..2]
                callback this[i][j], [i,j], this
        return undefined

    map: (callback) ->
    # map will return a new Matrix3 instance.
        m = new Matrix3()
        this.forEach (v,i,a) -> m[i[0]][i[1]] = callback v,i,a
        return m

    reduce: (callback, sum) ->
        this.forEach (v,i,a) -> sum = callback sum, v, i, a
        return sum

    ':': (n) ->
    # m[':'](n) to access nth column of m, 
    # just like syntax of matlab. 
        this.reduce(
            (s,v,i) ->
                s.push v if i[1] == n
                return s
            []
        )

    multiply: (target) ->
        if target.size.length == 2
            multiplyMatrix this, target
        else if target.size.length == 1
            multiplyVector this, target
        else
            throw new Error "not vector or matrix"

    multiplyMatrix = (m1, m2) ->
    # matrix to matrix multiply, return a new matrix.
        m1.map (v,i,a) ->
            a[i[0]].reduce(
                (s,v,j) -> s + v*m2[j][i[1]]
                0
            )

    multiplyVector = (m, v) ->
    # vector is 1 demetion array.
    # matrix to vector multiply, return n new vector.
        v.map (vi,i,v) ->
            m[i].reduce(
                (s,mi,i) -> s + mi*v[i]
                0
            )

    add: (m) -> @map (v,i) -> v + m[i[0]][i[1]]
    # add by matrix, return a new matrix.

    # convert Matrix3 into 1 demantion array, 
    # and slice.
    slice: (start, end) ->
        (this.reduce ((s,v) -> s.push v), []).slice start, end


sin = Math.sin
cos = Math.cos

# define omega, phi, kappa rotate matrix.
rotateMatrix =
    omega: (w) -> new Matrix3 [
        [1, 0, 0]
        [0, cos(w), sin(w)]
        [0, -sin(w), cos(w)]
    ]
    phi: (f) -> new Matrix3 [
        [cos(f), 0, -sin(f)]
        [0, 1, 0]
        [sin(f), 0, cos(f)]
    ]
    kappa: (k) -> new Matrix3 [
        [cos(k), sin(k), 0]
        [-sin(k), cos(k), 0]
        [0, 0, 1]
    ]

# define a function directly return 
# a matrix rotate by omega, phi, kappa. 
rotateWFKMatrix = (w, f, k) ->
    rotateMatrix.kappa k
        .multiply rotateMatrix.phi f
        .multiply rotateMatrix.omega w


# check is excute in nodejs or browser.
if  typeof exports == 'object'
    md = exports
else if typeof window == 'object'
    window.rotateWFK = {}
    md = window.rotateWFK
else
    md = {}

# export modules.
md.Matrix3 = Matrix3
md.rotateMatrix = rotateMatrix
md.rotateWFKMatrix = rotateWFKMatrix


