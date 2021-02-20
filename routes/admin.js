var express = require('express');
var router = express.Router();

var adminService = require("../services/adminService")
var uploadFile = require("../services/uploadFile")

/* GET users listing. */
router.get('/', function (req, res, next) {
    res.json("test")
});
// 管理员登录
router.post('/login', function (req, res, next) {
    adminService.adminLogin(req, res)
});
// 获取所有用户列表
router.post('/getUserList', function (req, res, next) {
    adminService.getUserList(req, res)
});
// 通过用户id删除用户
router.post('/delUserById', function (req, res, next) {
    adminService.delUserById(req, res)
});
// 通过分类id获取分类信息
router.post('/getCateById', function (req, res, next) {
    adminService.getCateById(req, res)
});
// 通过分类id修改分类名称
router.post('/modifyCateName', function (req, res, next) {
    adminService.modifyCateName(req, res)
});
// 获取所有评论
router.post('/getComment', function (req, res, next) {
    adminService.getComment(req, res)
});
// 修改评论状态
router.post('/modifyCommentStatus', function (req, res, next) {
    adminService.modifyCommentStatus(req, res)
});
// 添加分类
router.post('/addCate', function (req, res, next) {
    adminService.addCate(req, res)
});
// 商品管理-获取所有店铺
router.post('/getAllsupplier', function (req, res, next) {
    adminService.getAllsupplier(req, res)
});
// 商品管理-获取所有商品
router.post('/getAllGoods', function (req, res, next) {
    adminService.getAllGoods(req, res)
});
// 商品管理-改变商品上下架状态
router.post('/changepublishStatus', function (req, res, next) {
    adminService.changepublishStatus(req, res)
});
// 商品管理-改变商品审核状态
router.post('/changeAuidtStatus', function (req, res, next) {
    adminService.changeAuidtStatus(req, res)
});
// 商品管理-添加商品
router.post('/addGoods', uploadFile.upGoodsMain, function (req, res, next) {
    adminService.addGoods(req, res)
});
// 商品管理-上传商品详情banner
router.post('/uploadGoodsBanner', uploadFile.goodsBnnaer, function (req, res, next) {
    adminService.uploadGoodsBanner(req, res)
});
// 商品管理-删除图片
router.post('/delGoodsImg', uploadFile.goodsBnnaer, function (req, res, next) {
    adminService.delGoodsImg(req, res)
});
// 商品管理-删除商品
router.post('/delGoods', uploadFile.goodsBnnaer, function (req, res, next) {
    adminService.delGoods(req, res)
});
// 商品管理-修改商品基本信息
router.post('/submitModify', uploadFile.modifyGoods, function (req, res, next) {
    adminService.submitModify(req, res)
});




module.exports = router;