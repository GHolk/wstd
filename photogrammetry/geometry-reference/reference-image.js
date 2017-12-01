
const Jimp = require('jimp')
const X = 0
const Y = 1
const Z = 2

class ReferenceImage {
    constructor(path, realToPixel) {
        this.realToPixel = realToPixel
        this.gsd = this.constructor.gsd
        return Jimp.read(path).then((image) => {
            this.image = image
            return this
        })
    }
    getColorByReal(xy) {
        const bit = this.realToPixel(xy)
        const col = bit[X]
        const row = bit[Y]
        return this.image.getPixelColor(col, row)
    }
    walkImage(start, end, fill) {
        const interval = this.gsd
        for (let x=start[X], col=0; x<end[X]; x+=interval, col++) {
            for (let y=start[Y], row=0; y<end[Y]; y+=interval, row++) {
                fill(this.getColorByReal([x,y]), [col,row])
            }
        }
    }
    reference(start, end) {
        const interval = this.gsd
        const width = Math.ceil((end[X] - start[X]) / interval)
        const height = Math.ceil((end[Y] - start[Y]) / interval)
        return new Promise((returnImage) => {
            new Jimp(width, height,
                (imageError, emptyImage) => returnImage(emptyImage)
            )
        }).then((emptyImage) => {
            this.walkImage(start, end, (color, bit) => {
                const col = bit[X]
                const row = bit[Y]
                emptyImage.setPixelColor(color, col, row)
            })
            return emptyImage
        })
    }
}
ReferenceImage.gsd = 0.05  // 5cm

exports.ReferenceImage = ReferenceImage

function run(imageId) {
    const transform = require(`./p${imageId}`)
    let img = new ReferenceImage(`./DJI_0${imageId}.jpg`, t.r2pTransform)
    return img.then((img) => img.reference(
        [2544148.08018945, 169527.63411213047],
        [2544204.357371537, 169602.84184626857]
    ))
}

exports.run = run
