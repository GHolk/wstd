
const tlib = require('./transform')

const Transform = tlib.Transform
const mj = tlib.mj
const X = tlib.X
const Y = tlib.Y
const Z = tlib.Z

function solveLeastSquare(points) {
    /*
    M * [x] + T = [X]
        [y]       [Y]

    M = [a -b]
        [b  a]

    T = [Tx]
        [Ty]

    ax - by + Tx = X
    bx + ay + Ty = Y

    ax - by + Tx +  0 = X
    ay + bx +  0 + Ty= Y

    [x -y 1 0] * [a] = [X] + V
    [y  x 0 1]   [b]   [Y]
    [x -y 1 0]   [Tx]  [X]
    [   ...  ]   [Ty]  [.]

    [x -y 1 0] = A
    [y  x 0 1]
    [x -y 1 0]
    [   ...  ]

    X = (A' * A)-1 * A' * Y
    */

    let A = []
    let Ym = []
    points.forEach((p) => {
        A.push([p.pixel[X], -p.pixel[Y], 1, 0])
        A.push([p.pixel[Y],  p.pixel[X], 0, 1])

        Ym.push(p.real[X])
        Ym.push(p.real[Y])
    })

    Ym = mj.stand(Ym)

    let Xm
    Xm = mj.multiply(mj.transpose(A), A)
    Xm = mj.inv(Xm)
    Xm = mj.multiply(Xm, mj.transpose(A))
    Xm = mj.multiply(Xm, Ym)

    const lieXm = mj.lie(Xm)
    const a = lieXm[0]
    const b = lieXm[1]
    const Tx = lieXm[2]
    const Ty = lieXm[3]

    const pixelToRealMatrix = [[a, -b],
                               [b,  a]]
    const moveVector = [[Tx],
                        [Ty]]
    const V = mj.minus(mj.multiply(A, Xm), Ym)
    return new Transform(pixelToRealMatrix, moveVector, V)
}

module.exports = solveLeastSquare
