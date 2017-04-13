
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
    omega: (o) -> new Matrix3 [
        [1, 0, 0]
        [0, cos(o), sin(o)]
        [0, -sin(o), cos(o)]
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

rotateOFK = (o, f, k) ->
    rotateMatrix.kappa k
        .multiply rotateMatrix.phi f
        .multiply rotateMatrix.omega o

if exports?
    exports.Matrix3 = Matrix3
    exports.rotateMatrix = rotateMatrix
    exports.rotateOFK = rotateOFK


