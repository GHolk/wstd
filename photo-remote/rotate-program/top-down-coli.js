// 引用寫好的函式庫
var ColinearityEquation = require('colinearityEquation')

// 外方位參數
var eop = {
    // 相機在物空間座標
    xo: -60.7716,
    yo: 54.6448,
    zo: 568.3118,

    // 相機在物空間旋轉角
    omega: 0.0760,
    phi: -0.0883,
    kappa: -0.2558 
}

// 內方位參數
var iop = [
     0.041933,  // xp
     -0.016958,  // yp
     3.984584  // c
]

var ceqn = new ColinearityEquation(eop, iop)

var pixelSize = 0.0014*1000,  // 單位 um
    width = 3328,  // 單位像素
    height = 1872

// 四個角的像空間座標
var pointsInPhoto = [
    [width/2, height/2, 0],
    [-width/2, height/2, 0],
    [width/2, -height/2, 0],
    [-width/2, -height/2, 0]
]

// 把像空間座標的陣列每個元素，
// 作為函數 ceqn.photoToGround 的參數，
// 結果再放進 pointsInGround 陣列。
var pointsInGround = pointsInPhoto.map(
function photoToGround(point) {
    return ceqn.photoToGround(point)
})

// 顯示出結果
console.log(pointsInGround.join('\n'))

