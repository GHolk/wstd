const ReferenceImage = require('./reference-image').ReferenceImage
const ColinearityEquation = require('colinearityEquation')

const X = 0
const Y = 1
const Z = 2

exports.run = function (file, eop, iop, range, gsd) {

    const ce = new ColinearityEquation(eop, iop)

    function lengthToPixel(point) {
        const scale = 631.8955603017934
        const scalePoint = point.map((length) => length * scale)
        scalePoint[X] = 1995.5 - scalePoint[X]
        scalePoint[Y] = 1495.5 + scalePoint[Y]
        return scalePoint
    }

    function realToPixel(real) {
        const meanOrthoHeight = 19.7
        if (isNaN(real[Z])) real[Z] = meanOrthoHeight
        return lengthToPixel(ce.groundToPhoto(real))
    }
    
    const rip = new ReferenceImage(file, realToPixel)
    rip.then((ri) => {
        const start = range[0]
        const end = range[1]
        ri.gsd = gsd || 2
        return ri.reference(start, end)
    }).then((ni) => {
        ni.write(file.replace('.jpg', '-ortho.png'))
    })
}
