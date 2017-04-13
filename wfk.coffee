
class Matrix3 extends Array
    constructor: (a) ->
        a = [1..9].map( -> a ) if typeof a == 'number'

        if a.length >= 9
            a = [
                a.slice 0,3
                a.slice 3,6
                a.slice 6,9
            ]
            a.unshift 0,1
            this.splice.apply this, a
        else if a.length >= 3
            a.unshift 0,0
            this.splice.apply this, a
        else
            throw new Error 'arguments not array!'

    size: [3,3]
    multiply: (m) ->
        product = new Matrix3 0
        for i in [0..2]
            for j in [0..2]
                for k in [0..2]
                    product[i][j] += @[i][k] * m[k][j]
        return product

    add: (m) ->
        sum = new Matrix3 0
        for i in [0..2]
            for j in [0..2]
                sum[i][j] = @[i][j] + m[i][j]
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


