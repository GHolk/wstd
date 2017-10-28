

const tlib = require('./transform')
const Gcp = tlib.Gcp

const g06 = new Gcp([2544207.601, 169543.386], [1275, 1259])
const g07 = new Gcp([2544198.959, 169590.653], [2231, 1322])
const g08 = new Gcp([2544173.658, 169573.783], [1918, 1852])
const g09 = new Gcp([2544151.936, 169536.191], [1034, 2440])
const g10 = new Gcp([2544192.378, 169618.321], [2822, 1382])
const g11 = new Gcp([2544162.842, 169643.023], [3537, 1933])
const g03 = new Gcp([2544136.391, 169590.860], [2431, 2751])

const points = [g06, g07, g08, g09, g10, g11, g03]
points.forEach((p) => p.move())

const image = 'DJI_0341.jpg'

const region = [[700, 1100],
                [2600, 2700]]

const convert = require('./convert')
convert(image, points, './affine-transform', region)
convert(image, points, './affine-angle', region)
convert(image, points, './polynomial-transform', region)
convert(image, points, './polynomial-d1', region)
convert(image, points.slice(0, 4), './project-transform', region)







