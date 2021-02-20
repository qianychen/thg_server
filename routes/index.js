var express = require('express');
var router = express.Router();

const help = require('../services/help')
const unit = require("../services/unit")

/* GET home page. */
router.get('/', function (req, res, next) {
  res.json("test")
});
/* 获取帮助中心信息*/
router.get('/help', async function (req, res, next) {
  help.getHelp(req, res)
});
/* 获取帮助中心内容*/
router.get('/getHelpById', async function (req, res, next) {
  help.getHelpById(req, res)
});
/* 获取帮助中心内容*/
router.get('/randomHelp', async function (req, res, next) {
  help.randomHelp(req, res)
});




module.exports = router;