var express = require('express');
var router = express.Router();

var goodsService = require("../services/goodsService")

/* GET users listing. */
router.get('/', function (req, res, next) {
    res.json("test")
});
// 获取分类
router.get('/getCategory', (req, res, next) => {
    goodsService.getCategory(req, res)
})
// 获取商品信息
router.get('/getGoods', (req, res, next) => {
    goodsService.getGoods(req, res)
})
// 通过关键词搜索商品
router.post('/getGoodsByKeyword', (req, res, next) => {
    goodsService.getGoodsByKeyword(req, res)
})
// 通过商品id搜索商品详情信息
router.post('/getGoodsDetailById', (req, res, next) => {
    goodsService.getGoodsDetailById(req, res)
})
// 加入购物车
router.post('/insertShopCart', (req, res, next) => {
    goodsService.insertShopCart(req, res)
})
// 获取购物车数据
router.post('/getShopCartInfo', (req, res, next) => {
    goodsService.getShopCartInfo(req, res)
})
// 修改购物车商品数量
router.post('/modifyShopCartAmount', (req, res, next) => {
    goodsService.modifyShopCartAmount(req, res)
})
// 删除购物车商品数据
router.post('/delShopCartGoods', (req, res, next) => {
    goodsService.delShopCartGoods(req, res)
})
// 随机推荐商品
router.post('/recommendGoods', (req, res, next) => {
    goodsService.recommendGoods(req, res)
})
// 随机推荐商品
router.post('/getGoodsCommentByGoodsId', (req, res, next) => {
    goodsService.getGoodsCommentByGoodsId(req, res)
})

module.exports = router;