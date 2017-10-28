
const tlib = require('./transform')

const Transform = tlib.Transform
const mj = tlib.mj
const X = tlib.X
const Y = tlib.Y
const Z = tlib.Z

function solveLeastSquare(points) {
    /*
      [a b] * [x] + [Tx] = [X]
      [c d]   [y]   [Ty]   [Y]
      
      ax + by + Tx = X
      cx + dy + Ty = Y

      ax + by +  0 +  0 + Tx +  0 = X
       0 +  0 + cx + dy +  0 + Ty = Y

      [x y 0 0 1 0] * [a]  = [X] + V
      [0 0 x y 0 1]   [b]    [Y]
      [x y 0 0 1 0]   [c]    [X]
      [  ...  ]       [d]    [.]
                      [Tx]
                      [Ty]

      X = (A' * A)-1 * A' * Y
    */

    let eqn = []
    let observ = []
    points.forEach((p) => {
        const pixel = p.pixel
        const real = p.real
        eqn.push([pixel[X], pixel[Y],        0,        0, 1, 0])
        eqn.push([       0,        0, pixel[X], pixel[Y], 0, 1])

        observ.push(real[X])
        observ.push(real[Y])
    })
    observ = mj.stand(observ)
    let unkown
    unkown = mj.multiply(
        mj.transpose(eqn),
        eqn
    )
    unkown = mj.inv(unkown)
    unkown = mj.multiply(
        unkown,
        mj.transpose(eqn)
    )
    unkown = mj.multiply(unkown, observ)
    unkown = mj.lie(unkown)

    const a = unkown[0]
    const b = unkown[1]
    const c = unkown[2]
    const d = unkown[3]
    const tx = unkown[4]
    const ty = unkown[5]

    const pixelToRealMatrix = [[a, b],
                               [c, d]]
    const moveVector = mj.stand([tx, ty])
    mj.multiply(eqn, unkown)
    const V = mj.minus(mj.multiply(eqn, unkown), mj.lie(observ))

    return new Transform(pixelToRealMatrix, moveVector, V)
}
                         
module.exports = solveLeastSquare
