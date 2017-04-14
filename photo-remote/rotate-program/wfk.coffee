
class Matrix3
    constructor: (a = 0) ->
        a = [1..9].map( -> a ) if typeof a == 'number'

        if a.length >= 9
            for i in [0..2]
                this[i] = a.slice i*3,(i+1)*3
        else if a.length >= 3
            for i in [0..2]
                this[i] = a[i].slice 0
        else
            throw new Error 'arguments not array!'

    ':': (n) -> this.reduce(
        (s,v,i) ->
            s.push v if i[1] == n
            return s
        []
    )
    size: [3,3]
    multiply: (m) ->
        @map (v,i,a) ->
            sum = 0
            sum += a[i[0]][k] * m[k][i[1]] for k in [0..2]
            return sum

    add: (m) -> @map (v,i) -> v + m[i[0]][i[1]]

    slice: (start, end) ->
        (this.reduce ((s,v) -> s.push v), []).slice start, end

    forEach: (callback) ->
        for i in [0..2]
            for j in [0..2]
                callback this[i][j], [i,j], this
        return undefined

    map: (callback) ->
        m = new Matrix3()
        this.forEach (v,i,a) -> m[i[0]][i[1]] = callback v,i,a
        return m

    reduce: (callback, sum) ->
        this.forEach (v,i,a) -> sum = callback sum, v, i, a
        return sum


sin = Math.sin
cos = Math.cos

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

rotateWFKMatrix = (w, f, k) ->
    rotateMatrix.kappa k
        .multiply rotateMatrix.phi f
        .multiply rotateMatrix.omega w

if  typeof exports == 'object'
    md = exports
else if typeof window == 'object'
    window.rotateWFK = {}
    md = window.rotateWFK
else
    md = {}

md.Matrix3 = Matrix3
md.rotateMatrix = rotateMatrix
md.rotateWFKMatrix = rotateWFKMatrix


