
const tlib = require('./transform')
const Gcp = tlib.Gcp

const g06 = new Gcp([2544207.601, 169543.386], [1452, 502])
const g07 = new Gcp([2544198.959, 169590.653], [2253, 534])
const g08 = new Gcp([2544173.658, 169573.783], [1992, 880])
const g09 = new Gcp([2544151.936, 169536.191], [1270, 1290])
const g10 = new Gcp([2544192.378, 169618.321], [2730, 568])
const g11 = new Gcp([2544162.842, 169643.023], [3314, 937])
const g03 = new Gcp([2544136.391, 169590.860], [2420, 1483])
const points = [g06, g07, g08, g09, g10, g11, g03]
points.forEach((p) => p.move())

const image = 'DJI_0339.jpg'

const region = [[1050,  350],
                [2750, 1500]]

const convert = require('./convert')
convert(image, points, './affine-transform', region)
convert(image, points, './affine-angle', region)
convert(image, points, './polynomial-transform', region)
convert(image, points, './polynomial-d1', region)
convert(image, points.slice(0, 6), './project-transform', region)
