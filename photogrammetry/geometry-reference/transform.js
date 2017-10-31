
const X = 0
const Y = 1
const Z = 2
exports.X = X
exports.Y = Y
exports.Z = Z

const mj = require('mathjs')
mj.minus = function (a, b) {
    return this.add(
        a,
        this.multiply(-1, b)
    )
}
mj.stand = function (array) {
    return mj.reshape(array, [array.length, 1])
}
mj.lie = function (array) {
    return mj.reshape(array, [array.length])
}
exports.mj = mj

class Gcp {
    constructor(real, pixel) {
        this.real = real
        this.pixel = pixel
    }
    move() {
        const moveValue = this.constructor.moveValue
        this.real = mj.minus(this.real, moveValue)
    }
    unmove() {
        const moveValue = this.constructor.moveValue
        this.real = mj.add(this.real, moveValue)
    }
    static unmove(real) {
        const moveValue = this.moveValue
        return mj.add(real, moveValue)
    }
    static move(real) {
        return mj.minus(real, this.moveValue)
    }
}
Gcp.moveValue = [2544000, 169000]
exports.Gcp = Gcp

class Transform {
    constructor(matrix, move, error) {
        this.pixelToRealMatrix = matrix
        this.realToPixelMatrix = mj.inv(matrix)
        this.moveVector = move
        this.error = error
    }
    realToPixel(real) {
        const stand = mj.stand(real)
        let pixel
        pixel = mj.minus(stand, this.moveVector)
        pixel = mj.multiply(this.realToPixelMatrix, pixel)
        return mj.lie(pixel)
    }
    pixelToReal(pixel) {
        const stand = mj.stand(pixel)
        let real
        real = mj.multiply(this.pixelToRealMatrix, stand)
        real = mj.add(real, this.moveVector)
        return mj.lie(real)
    }
}
exports.Transform = Transform
