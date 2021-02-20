const multer = require("multer");
const path = require("path");

module.exports.upGoodsMain = (req, res, next) => {
    let fullPath = 'public/images/goods/temp'
    let filename = "";
    let storage = multer.diskStorage({
        //设置文件存储路径
        destination: (req, file, cb) => {
            cb(null, fullPath);
        },
        //设置文件存储名称
        filename: (req, file, cb) => {
            let extname = path.extname(file.originalname);
            filename = file.fieldname + "-" + Date.now() + extname;
            cb(null, filename);
        }
    })
    //上传单张图片
    let upload = multer({
        storage
    }).single("home_img");
    upload(req, res, (err) => {
        if (err instanceof multer.MulterError) {
            res.send("multererr:" + err);
        } else if (err) {
            res.send("err:" + err);
        } else {
            //上传成功后，将图片写在req.body.photo中，继续住下执行
            // req.body.photo = filename;
            next();
        }
    })
}
module.exports.goodsBnnaer = (req, res, next) => {
    let fullPath = 'public/images/goods/temp'
    let filename = "";
    let storage = multer.diskStorage({
        //设置文件存储路径
        destination: (req, file, cb) => {
            cb(null, fullPath);
        },
        //设置文件存储名称
        filename: (req, file, cb) => {
            let extname = path.extname(file.originalname);
            filename = file.fieldname + "-" + file.originalname + Date.now() + extname;
            cb(null, filename);
        }
    })
    //上传单张图片
    let upload = multer({
        storage
    }).array("goodsImg");
    upload(req, res, (err) => {
        if (err instanceof multer.MulterError) {
            res.send("multererr:" + err);
        } else if (err) {
            res.send("err:" + err);
        } else {
            //上传成功后，将图片写在req.body.photo中，继续住下执行
            // req.body.photo = filename;
            next();
        }
    })
}
module.exports.modifyGoods = (req, res, next) => {
    let fullPath = 'public/images/goods/temp'
    let filename = "";
    let storage = multer.diskStorage({
        //设置文件存储路径
        destination: (req, file, cb) => {
            cb(null, fullPath);
        },
        //设置文件存储名称
        filename: (req, file, cb) => {
            let extname = path.extname(file.originalname);
            filename = file.fieldname + "-" + Date.now() + extname;
            cb(null, filename);
        }
    })
    //上传单张图片
    let upload = multer({
        storage
    }).array("uphome_img");
    upload(req, res, (err) => {
        if (err instanceof multer.MulterError) {
            res.send("multererr:" + err);
        } else if (err) {
            res.send("err:" + err);
        } else {
            //上传成功后，将图片写在req.body.photo中，继续住下执行
            // req.body.photo = filename;
            next();
        }
    })
}