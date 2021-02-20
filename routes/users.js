var express = require('express');
var router = express.Router();

var userService = require("../services/userService")
const multer = require('multer')

var avaUpload = multer({
  storage: multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, 'public/images/userAvatar')
    },
    // filename: function (req, file, cb) {
    //   let last = file.originalname.split('.')
    //   cb(null, file.fieldname + '-' + Date.now() + '.' + last[last.length - 1])
    // }
  })
})
// 修改用户头像
router.post('/modifyUserAvatar', avaUpload.array('userAvatar', 1), function (req, res, next) {
  userService.modifyUserAvatar(req, res)
});

/* GET users listing. */
router.get('/', function (req, res, next) {
  res.send('respond with a resource');
});

// 用户登录
router.post('/login', function (req, res, next) {
  userService.login(req, res)
});
// 查询手机号是否被注册
router.post('/checkPhone', function (req, res, next) {
  userService.check_phone(req, res)
});
// 查询邮箱是否被注册
router.post('/checkEmail', function (req, res, next) {
  userService.check_email(req, res)
});
// 用户注册
router.post('/register', function (req, res, next) {
  userService.register(req, res)
});
// 注册发送随机验证码
router.post('/sendCode', function (req, res, next) {
  userService.sendCode(req, res)
});
// 通过用户id查询用户信息
router.post('/getUserInfoById', function (req, res, next) {
  userService.getUserInfoById(req, res)
});
// 修改用户基本资料
router.post('/modifyUserInfo', function (req, res, next) {
  userService.modifyUserInfo(req, res)
});
// // 修改用户头像
// router.post('/modifyUserAvatar', avaUpload.array('userAvatar', 1), function (req, res, next) {
//   userService.modifyUserAvatar(req, res)
// });
// 通过用户id查询用户地址
router.post('/getUserAddrById', function (req, res, next) {
  userService.getUserAddrById(req, res)
});
// 通过用户id删除用户地址
router.post('/delUserAddrById', function (req, res, next) {
  userService.delUserAddrById(req, res)
});
// 通过用户id添加用户地址
router.post('/addUserAddr', function (req, res, next) {
  userService.addUserAddr(req, res)
});
// 通过地址id查询地址信息
router.post('/getUserAddrByAddrId', function (req, res, next) {
  userService.getUserAddrByAddrId(req, res)
});
// 通过地址id修改地址信息
router.post('/modifyUserAddr', function (req, res, next) {
  userService.modifyUserAddr(req, res)
});
// 设置默认收货地址
router.post('/setDefAddr', function (req, res, next) {
  userService.setDefAddr(req, res)
});
// 设置实名信息
router.post('/modifyUserIdCard', function (req, res, next) {
  userService.modifyUserIdCard(req, res)
});
// 绑定邮箱
router.post('/modifyEmail', function (req, res, next) {
  userService.modifyEmail(req, res)
});
// 通过用户id查询旧密码
router.post('/getOldPasswordById', function (req, res, next) {
  userService.getOldPasswordById(req, res)
});
// 通过用户id修改密码
router.post('/modifyPassWord', function (req, res, next) {
  userService.modifyPassWord(req, res)
});
// 通过用户id换绑手机号
router.post('/modifyPhone', function (req, res, next) {
  userService.modifyPhone(req, res)
});
// 通过用户id充值用户余额
router.post('/UserRecharge', function (req, res, next) {
  userService.UserRecharge(req, res)
});

module.exports = router;