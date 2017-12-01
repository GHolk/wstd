
const ColinearityEquation = require('colinearityEquation')

const X = 0
const Y = 1
const Z = 2

const eop = {
    // xo: 169570.443932,
    xo: 570.443932,
    // yo: 2544089.886767,
    yo: 89.886767,
    zo: 116.355578,
    omega: 25.769170/180*Math.PI,
    phi: -0.478151/180*Math.PI,
    kappa:-4.904690/180*Math.PI
}

const xp = 0.00797976759482130898
const yp = -0.01632040141493363086
const c = 3.68128070687046982101
const iop = [xp, yp, -c]
iop.k = [
    -0.00261341937662040030,
    0.00015213497306022675,
    -0.00000127943044334018
]
iop.p = [0.00002392585197592054, 0.00001764654855396589]

const ce = new ColinearityEquation(eop, iop)

function lengthToPixel(point) {
    const scale = 631.8955603017934
    const scalePoint = point.map((length) => length * scale)
    scalePoint[X] = 1995.5 - scalePoint[X]
    scalePoint[Y] = 1495.5 + scalePoint[Y]
    return scalePoint
}


const ReferenceImage = require('./reference-image').ReferenceImage

function realToPixel(real) {
    const meanOrthoHeight = 19.7
    if (isNaN(real[Z])) real[Z] = meanOrthoHeight
    return lengthToPixel(ce.groundToPhoto(real))
}

const rip = new ReferenceImage('./DJI_0339.jpg', realToPixel)
rip.then((ri) => {
    const start = [450, 70]
    const end = [700, 270]
    ri.gsd = 0.1
    return ri.reference(start, end)
}).then((ni) => {
    ni.write('DJI_0339-ortho.png')
})
