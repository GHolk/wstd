
const ortho = require('./ortho')

const file = './DJI_0341.jpg'
const eop = {
    xo: 577.939116,
    yo: 142.543224,
    zo: 117.162758,
    omega: degreeToRadian(25.999485),
    phi: degreeToRadian(-0.506618),
    kappa: degreeToRadian(-5.012149)
}

function degreeToRadian(degree) {
    return degree / 180 * Math.PI
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

const start = [450, 120]
const end = [700, 320]
const region = [start, end]
const gsd = 0.1

ortho.run(file, eop, iop, region, gsd)
