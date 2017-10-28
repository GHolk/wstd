
const rimg = require('./reference-image')
const tlib = require('./transform')
const Gcp = tlib.Gcp
const X = tlib.X
const Y = tlib.Y
const Z = tlib.Z

const START = 0
const END = 1

function convert(path, points, transformLib, region) {

    const solveLeastSquare = require(transformLib)
    const transform = solveLeastSquare(points)
    console.log('error: %s', transform.error)

    const imageP = new rimg.ReferenceImage(
        path,
        transform.realToPixel.bind(transform)
    )
    imageP.then((img) => {
        const p1 = transform.pixelToReal(region[START])
        const p2 = transform.pixelToReal(region[END])
        const start = [
            Math.min(p1[X], p2[X]),
            Math.min(p1[Y], p2[Y])
        ]
        const end = [
            Math.max(p1[X], p2[X]),
            Math.max(p1[Y], p2[Y])
        ]

        img.reference(start, end).then((twd97Image) => {
            twd97Image.write(
                path.replace(/\..*/, '') + '-' +
                    transformLib.replace('./', '') + '.png'
            )
        })
    })    
}

module.exports = convert
