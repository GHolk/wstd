
const ortho = require('./ortho')

const file = './DJI_0340.jpg'
const eop = {
    xo: 574.133147,
    yo: 115.860686,
    zo: 116.446508,
    omega: degreeToRadian(25.849102),
    phi: degreeToRadian(-0.457140),
    kappa: degreeToRadian(-4.874469)
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

const start = [450, 100]
const end = [700, 300]
const region = [start, end]
const gsd = 0.1


ortho.run(file, eop, iop, region, gsd)
