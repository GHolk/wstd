const tlib = require('./transform')

const Transform = tlib.Transform
const mj = tlib.mj
const X = tlib.X
const Y = tlib.Y
const Z = tlib.Z

function solveLeastSquare(points) {
    /*
      a + ax + ay + ax2 + ay2 + axy = X
      b + bx + by + bx2 + by2 + bxy = Y

      [1 x y x2 y2 xy ...] * [a]  = [X] + V
      [... 1 x y x2 y2 xy]   [b]    [Y]
                             [X]
                             [.]
                      
      X = (A' * A)-1 * A' * Y
    */

    let eqn = []
    let observ = []
    points.forEach((p) => {
        const rl = p.real
        const poly = [1, rl[X], rl[Y], rl[X]*rl[Y]]
        const zero4 = [0,0,0,0]
        eqn.push(poly.concat(zero4))
        eqn.push(zero4.concat(poly))

        const pixel = p.pixel
        observ.push(pixel[X])
        observ.push(pixel[Y])
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

    const a = unkown.slice(0,4)
    const b = unkown.slice(4,8)

    const V = mj.minus(
        mj.multiply(eqn, mj.stand(unkown)),
        observ
    )

    return {
        error: V,
        realToPixel: function (real) {
            const order = [
                1, real[X], real[Y], real[X]*real[Y]
            ]
            const pixel = [0, 0]
            pixel[X] = this.coef[X]
                .map((c, i) => c * order[i])
                .reduce((s, v) => s + v, 0)
            pixel[Y] = this.coef[Y]
                .map((c, i) => c * order[i])
                .reduce((s, v) => s + v, 0)
            return pixel
        },
        coef: [a, b]
    }
}

function swapRealPixel(point) {
    return {
        pixel: point.real,
        real: point.pixel
    }
}
                         
module.exports = function twoWayTransform(points) {
    const realToPixel = solveLeastSquare(points)
    const pixelToRealObject = solveLeastSquare(points.map(swapRealPixel))
    const pixelToReal = pixelToRealObject.realToPixel
    realToPixel.pixelToReal = pixelToReal.bind(pixelToRealObject)
    return realToPixel
}
