const file = 'DJI_0339.jpg'

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

const start = [450, 70]
const end = [700, 270]
const range = [start, end]
const gsd = 0.1

const ortho = require('./ortho.js')
ortho.run(file, eop, iop, range, gsd)
