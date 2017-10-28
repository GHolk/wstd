const tlib = require('./transform')

const Transform = tlib.Transform
const mj = tlib.mj
const X = tlib.X
const Y = tlib.Y
const Z = tlib.Z

function solveLeastSquare(points) {
    /*
      a0 + a1 x + a2 y 
      ---------------- = X
      1  + c1 x + c2 y
      
      b0 + b1 x + b2 y 
      ---------------- = Y
      1  + c1 x + c2 y
      
      a0 + a1 x + a2 y - X - c1 x X - c2 y X = 0
      b0 + b1 x + b2 y - Y - c1 x Y - c2 y Y = 0
      
      [1 x y 0 0 0 -xX -yX] * [a]  = [X] + V
      [0 0 0 1 x y -xY -yY]   [b]    [Y]
                              [c]
                      
      X = (A' * A)-1 * A' * Y
    */

    let eqn = []
    let observ = []
    points.forEach((p) => {
        const px = p.pixel
        const rl = p.real
        eqn.push([1, px[X], px[Y], 0, 0, 0, -px[X]*rl[X], -px[Y]*rl[X]])
        eqn.push([0, 0, 0, 1, px[X], px[Y], -px[X]*rl[Y], -px[Y]*rl[Y]])

        observ.push(rl[X])
        observ.push(rl[Y])
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

    const V = mj.minus(
        mj.multiply(eqn, mj.stand(unkown)),
        observ
    )

    return {
        error: V,
        eqn: eqn,
        a: unkown.slice(0, 3),
        b: unkown.slice(3, 6),
        c: unkown.slice(6, 8),
        pixelToReal: function (pixel) {
            const px = pixel[X]
            const py = pixel[Y]
            const rx =
                  (this.a[0] + this.a[1]*px + this.a[2]*py) /
                  (1 + this.c[0]*px + this.c[1]*py)
            const ry =
                  (this.b[0] + this.b[1]*px + this.b[2]*py) /
                  (1 + this.c[0]*px + this.c[1]*py)
            return [rx, ry]
        }
    }
}

function swapRealPixel(point) {
    return {
        pixel: point.real,
        real: point.pixel
    }
}

module.exports = function twoWayTransform(points) {
    const pixelToReal = solveLeastSquare(points)
    const realToPixelObject = solveLeastSquare(points.map(swapRealPixel))
    const realToPixel = realToPixelObject.pixelToReal
    pixelToReal.realToPixel = realToPixel.bind(realToPixelObject)
    return pixelToReal
}
