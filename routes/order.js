var express = require('express');
var router = express.Router();

const orderService = require("../services/orderService")

router.get("/", (req, res) => {
    res.json('test')
})
// 生成订单
router.post("/generateOrder", (req, res) => {
    orderService.generateOrder(req, res)
})
// 通过用户id获取订单
router.post("/getOrderInfoByOrderId", (req, res) => {
    orderService.getOrderInfoByOrderId(req, res)
})
// 用户支付后改变订单
router.post("/modifyOrderState", (req, res) => {
    orderService.modifyOrderState(req, res)
})
// 通过用户id获取订单列表
router.post("/getOrderListById", (req, res) => {
    orderService.getOrderListById(req, res)
})
// 通过订单id确认收货
router.post("/confirmReceipt", (req, res) => {
    orderService.confirmReceipt(req, res)
})
// 发货
router.post("/shipping", (req, res) => {
    orderService.shipping(req, res)
})
// 获取评价用订单详情
router.post("/commentSelOrder", (req, res) => {
    orderService.commentSelOrder(req, res)
})
// 插入评价内容
router.post("/makeComment", (req, res) => {
    orderService.makeComment(req, res)
})


module.exports = router