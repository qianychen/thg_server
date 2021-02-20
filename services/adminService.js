const unit = require('./unit')
const _ = require('lodash')
const fs = require("fs")


module.exports = {
    // 管理员登陆
    async adminLogin(req, res) {
        let adminInfo = req.body.adminInfo
        let admin_sql = "select * from admin_info where account = ?"
        let admin_res = await unit.getSqlData(admin_sql, adminInfo.account)
        if (admin_res.length == 0) return res.json({
            message: '管理员不存在',
            status: 400
        })
        if (admin_res[0].account == adminInfo.account && admin_res[0].password == adminInfo.password) {
            let token = 'thg' + new Date().getTime()
            res.json({
                // 去除password
                userinfo: _.omit(admin_res[0], "password"),
                token,
                status: 200,
                message: '登录成功'
            })
        } else {
            res.json({
                status: 401,
                message: '密码错误'
            })
        }
    },
    /**
     * 获取所有用户列表
     *
     * @param {*} req
     * @param {*} res
     * @returns
     */
    async getUserList(req, res) {
        let pagenum = req.body.pageNum
        let pagesize = req.body.pageSize
        if (!pagenum || pagenum <= 0) return res.json({
            message: "pagenum传参错误",
            status: 400
        })
        if (!pagesize || pagesize <= 0) return res.json({
            message: "pagesize传参错误",
            status: 400
        })
        let page_ = (pagenum - 1) * pagesize
        let userList_sql = "select *,count(1) over() as total from customer_inf limit ?, ?"
        let userList_res = await unit.getSqlData(userList_sql, [page_, pagesize])
        if (userList_res.length == 0) return res.json({
            message: '获取用户列表失败',
            status: 400
        })
        res.json({
            message: '获取用户列表成功',
            status: 200,
            result: userList_res
        })
    },
    /**
     * 通过用户id删除用户
     *
     * @param {*} req
     * @param {*} res
     */
    async delUserById(req, res) {
        let user_id = req.body.userId
        let delUser_sql = "delete from customer_inf where customer_id = ?"
        let delUser_res = await unit.getSqlData(delUser_sql, user_id)
        if (delUser_res.affectedRows == 1) {
            res.json({
                message: '删除成功',
                status: 200
            })
            return
        }
        res.json({
            message: '删除失败',
            status: 400
        })
    },
    // 通过分类id获取分类信息
    async getCateById(req, res) {
        let cate_id = req.body.cateId
        let cate_sql = "select * from product_category where category_id = ?"
        let cate_res = await unit.getSqlData(cate_sql, cate_id)
        // console.log(cate_res);
        res.json({
            message: '获取分类成功',
            status: 200,
            result: cate_res[0]
        })
    },
    // 修改分类名称
    async modifyCateName(req, res) {
        let cate = req.body
        let modify_sql = "update product_category set category_name = ? where category_id = ?"
        let modify_res = await unit.getSqlData(modify_sql, [cate.form.name, cate.form.cateId])
        res.json({
            message: ' 修改分类名称成功',
            status: 200
        })
    },
    // 获取全部评论
    async getComment(req, res) {
        let pagenum = req.body.pagenum
        let pagesize = req.body.pagesize
        if (!pagenum || pagenum <= 0) return res.json({
            message: "pagenum传参错误",
            status: 400
        })
        if (!pagesize || pagesize <= 0) return res.json({
            message: "pagesize传参错误",
            status: 400
        })
        let page_ = (pagenum - 1) * pagesize
        let comment_sql = `select com.*, cus.nick_name, pro.product_name, count(1) over() as total
        from product_comment as com join customer_inf as cus
        on com.customer_id = cus.customer_id
        join product_info as pro
        on pro.product_id = com.product_id
        limit ?, ?`
        let comment_res = await unit.getSqlData(comment_sql, [page_, pagesize])
        res.json({
            message: ' 获取所有评论成功',
            status: 200,
            data: comment_res
        })
    },
    // 修改评论状态
    async modifyCommentStatus(req, res) {
        let info = req.body
        console.log(info.status);
        let modify_sql = ''
        if (info.status == 0) {
            modify_sql = "update product_comment set audit_status = 1 where comment_id = ?"
        } else if (info.status == 1) {
            modify_sql = "update product_comment set audit_status = 0 where comment_id = ?"
        }
        console.log(modify_sql);
        let modify_res = await unit.getSqlData(modify_sql, [info.comment_id])
        res.json({
            message: '修改成功',
            status: 200
        })
    },
    // 添加分类
    async addCate(req, res) {
        let info = req.body.addForm
        console.log(info);
        let parent_id
        let cate_level
        if (info.cate_level == 0) {
            parent_id = 0
            cate_level = info.cate_level
        } else if (info.cate_level == 1) {
            parent_id = info.one
            cate_level = info.cate_level
        } else {
            parent_id = info.two
            cate_level = info.cate_level
        }
        let add_sql = `insert into product_category(category_name, parent_id, category_level) value (?)`
        let add_res = await unit.getSqlData(add_sql, [
            [info.cate_name, parent_id, cate_level]
        ])
        console.log(add_res);
        if (add_res.affectedRows == 1) {
            res.json({
                message: '添加成功',
                status: 200
            })
            return
        }
        res.json({
            message: '添加失败',
            status: 400
        })
    },
    /**
     * 商品管理-获取所有商品
     *
     * @param {*} req
     * @param {*} res
     */
    async getAllGoods(req, res) {
        let pagenum = req.body.query.pageNum
        let pagesize = req.body.query.pageSize
        let keyword = req.body.query.keyword
        if (!pagenum || pagenum <= 0) return res.json({
            message: "pagenum传参错误",
            status: 400
        })
        if (!pagesize || pagesize <= 0) return res.json({
            message: "pagesize传参错误",
            status: 400
        })
        let page_ = (pagenum - 1) * pagesize
        let keyword_ = keyword ? "%" + keyword + "%" : '%'
        // console.log(req.body);
        let allGoods_sql = `select *,count(1) over() total 
        from product_info 
        where product_name like ?
        order by indate desc
        limit ?, ?`
        let allGoods_res = await unit.getSqlData(allGoods_sql, [keyword_, page_, pagesize])
        let finGoods = await unit.getGoodsInfo(allGoods_res)
        // console.log(finGoods);
        if (allGoods_res == 'fail') {
            res.json({
                message: '获取商品失败',
                status: 400
            })
            return
        }
        res.json({
            message: '获取成功',
            status: 200,
            result: finGoods
        })
    },
    /**
     * 获取所有店铺
     *
     * @param {*} req
     * @param {*} res
     */
    async getAllsupplier(req, res) {
        let supplier_sql = 'select * from supplier_info'
        let supplier_res = await unit.getSqlData(supplier_sql)
        res.json({
            message: '获取店铺成功',
            status: 200,
            result: supplier_res
        })

    },
    /**
     * 改变商品上下架状态
     *
     * @param {*} req
     * @param {*} res
     */
    async changepublishStatus(req, res) {
        let product_id = req.body.product_id
        let publish_status = req.body.publish_status
        let goodsStatus_sql = "update product_info set publish_status = ? where product_id = ?"
        let goodsStatus_res = await unit.getSqlData(goodsStatus_sql, [publish_status, product_id])
        // console.log(goodsStatus_res);
        if (goodsStatus_res.affectedRows != 1) {
            res.json({
                message: '失败',
                status: 400
            })
            return
        }
        res.json({
            message: '成功',
            status: 200
        })
    },
    /**
     * 改变商品审核状态
     *
     * @param {*} req
     * @param {*} res
     */
    async changeAuidtStatus(req, res) {
        let product_id = req.body.product_id
        let goodsStatus_sql = "update product_info set audit_status = 1 where product_id = ?"
        let goodsStatus_res = await unit.getSqlData(goodsStatus_sql, [product_id])
        // console.log(goodsStatus_res);
        if (goodsStatus_res.affectedRows != 1) {
            res.json({
                message: '审核失败',
                status: 400
            })
            return
        }
        res.json({
            message: '审核通过',
            status: 200
        })
    },

    /**
     * 添加商品
     *
     * @param {*} req
     * @param {*} res
     */
    async addGoods(req, res) {
        let goodsInfo = JSON.parse(req.body.goodsInfo)
        let sku = JSON.parse(req.body.sku)
        let file = req.file
        // console.log(req.body);
        // console.log(goodsInfo);

        // 判断是否输入版本
        sku.forEach((item, index) => {
            if (item['sku_version' + item.sku_id] == '' || item['sku_price' + item.sku_id] == '') {
                return res.json({
                    message: '版本数据缺失',
                    status: 400
                })
            }
        })
        // 判断是否上传图片
        if (req.body.home_img == 'undefined') {
            res.json({
                message: '缺少图片',
                status: 400
            })
            return
        }
        // 判断自输入的店铺是否存在
        // console.log(typeof goodsInfo.supplier);
        if (typeof goodsInfo.supplier == 'string') {
            let supplier_res = await unit.getSqlData('select * from supplier_info where supplier_name = ? ', goodsInfo.supplier)
            if (supplier_res.length != 0) {
                goodsInfo.supplier = supplier_res[0].supplier_id
            } else {
                let addSupplier_res = await unit.getSqlData('insert into supplier_info set supplier_name = ?;select supplier_id from supplier_info where supplier_name = ?', [goodsInfo.supplier, goodsInfo.supplier])
                // console.log(addSupplier_res);
                goodsInfo.supplier = addSupplier_res[1][0].supplier_id
                console.log('sd');
            }
        }
        console.log(goodsInfo);
        // console.log(sku);
        // 添加商品部分信息
        let goodsTemp = {
            product_name: goodsInfo.product_name,
            supplier_id: goodsInfo.supplier,
            one_category_id: goodsInfo.catechosed[0],
            two_category_id: goodsInfo.catechosed[1],
            three_category_id: goodsInfo.catechosed[2],
            price: sku[0]['sku_price' + sku[0].sku_id],
            descript: goodsInfo.descript
        }
        let addGoods_sql = "insert into product_info set ?;SELECT LAST_INSERT_ID(); "
        let addGoods_res = await unit.getSqlData(addGoods_sql, goodsTemp)
        // console.log(addGoods_res);
        if (addGoods_res[0].affectedRows != 1) {
            res.json({
                message: '插入商品失败',
                status: 400
            })
            return
        }
        // console.log(addGoods_res[1][0]['LAST_INSERT_ID()']);
        let addGoods_id = addGoods_res[1][0]['LAST_INSERT_ID()']
        // 添加商品sku信息
        for (let i = 0; i < sku.length; i++) {
            let addGoodSkutemp = {
                product_id: addGoods_id,
                sku_version: sku[i]['sku_version' + sku[i].sku_id],
                sku_price: sku[i]['sku_price' + sku[i].sku_id],
            }
            let addGoodSku_res = await unit.getSqlData('insert into product_sku set ?', addGoodSkutemp)
            console.log(addGoodSku_res);
            console.log('ss');
        }
        // 移动图片至对应文件夹
        // 创建文件夹
        let path = 'public/images/goods/goods' + addGoods_id
        let mainpath = 'public/images/goods/goods' + addGoods_id + '/main'
        let bannerpath = 'public/images/goods/goods' + addGoods_id + '/banner'
        await unit.dirExists(path)
        await unit.dirExists(mainpath)
        await unit.dirExists(bannerpath)
        let newPath = path + '/' + file.filename
        fs.rename('public/images/goods/temp/' + file.filename, newPath, (err) => {
            if (err) console.log(err);
        })
        console.log(file);
        // 将文件路径保存至服务器
        let temp = newPath.split('/')
        temp.shift()
        temp.join('/', temp)
        let sqlPath = 'http://127.0.0.1:3000/' + temp.join('/', temp)
        let uploadRes = await unit.getSqlData("update product_info set main_img = ? where product_id = ?", [sqlPath, addGoods_id])
        console.log(uploadRes);
        if (uploadRes.affectedRows != 1) {
            res.json({
                message: '插入商品失败',
                status: 400
            })
            return
        }
        res.json({
            message: '插入商品成功',
            status: 200
        })
    },
    /**
     * 上传商品详情图片
     *
     * @param {*} req
     * @param {*} res
     */
    async uploadGoodsBanner(req, res) {
        let files = req.files
        let goods_id = req.body.goods_id
        let isMain = req.body.isMain
        // 判断是否主图
        var pathtype = ''
        if (!parseInt(isMain)) {
            pathtype = 'banner'
        } else {
            pathtype = 'main'
        }
        // 定义图片新路径
        let newPath = `public/images/goods/goods${goods_id}/${pathtype}/`
        var sqlPathList = []
        await files.forEach(async item => {
            // 移动文件
            fs.renameSync('public/images/goods/temp/' + item.filename, newPath + item.filename, (err) => {
                console.log(err);
            })
            // 生成图片链接
            let sqlPath = `http://127.0.0.1:3000/images/goods/goods${goods_id}/${pathtype}/${item.filename}`
            let temp = [
                goods_id,
                sqlPath,
                isMain
            ]
            sqlPathList.push(temp)
        })
        // 上传服务器
        // console.log(sqlPathList);
        // console.log(files);
        let insert_res = await unit.getSqlData("insert into product_pic_info(product_Id,pic_url,is_master) values ? ", [sqlPathList])
        // console.log(insert_res);
        if (insert_res.affectedRows == 0) {
            res.json({
                message: '上传失败',
                status: 400
            })
            return
        }
        res.json({
            message: '上传成功',
            status: 200
        })
    },
    /**
     * 删除商品图片
     *
     * @param {*} req
     * @param {*} res
     */
    async delGoodsImg(req, res) {
        let pic_id = req.body.product_pic_id
        console.log(pic_id);
        let getpic_res = await unit.getSqlData('select * from product_pic_info where product_pic_id = ?', pic_id)
        console.log(getpic_res[0]);
        let sqlPath = getpic_res[0].pic_url.substr(21)
        console.log(sqlPath);
        let filepath = 'public' + sqlPath
        console.log(filepath);
        fs.unlink(filepath, function (err) {
            if (err) {
                throw err;
            }
            console.log('文件:' + filepath + '删除成功！');
        })
        let delGoodImg_res = await unit.getSqlData('delete from product_pic_info where product_pic_id = ?', pic_id)
        console.log(delGoodImg_res);
        if (delGoodImg_res.affectedRows != 1) {
            res.json({
                message: '删除失败',
                status: 400
            })
            return
        }
        res.json({
            message: '删除成功',
            status: 200
        })
    },
    /**
     * 删除商品
     *
     * @param {*} req
     * @param {*} res
     */
    async delGoods(req, res) {
        let goods_id = req.body.goods_id
        console.log(goods_id);
        // 删除服务器上的文件
        let delPath = `public/images/goods/goods${goods_id}/test`
        await unit.deleteFolder(delPath)
        let delGoods_sql = `delete from product_sku where product_id = ?;
        delete from product_pic_info where product_id = ?;
        delete from product_info where product_id = ?`
        let delGoods_res = await unit.getSqlData(delGoods_sql, [goods_id, goods_id, goods_id])
        console.log(delGoods_res);
        if (delGoods_res == 'fail') {
            res.json({
                message: '删除商品失败',
                status: 400
            })
            return
        }
        res.json({
            message: "删除商品成功",
            status: 200
        })
    },
    /**
     * 修改商品基本信息
     *
     * @param {*} req
     * @param {*} res
     */
    async submitModify(req, res) {
        let goodsInfo = JSON.parse(req.body.goodsInfo)
        let sku = JSON.parse(req.body.sku)
        let file = req.files[0]
        console.log(req.body);
        console.log(file);
        // 判断是否输入版本
        sku.forEach((item, index) => {
            if (item['sku_version' + item.sku_id] == '' || item['sku_price' + item.sku_id] == '') {
                return res.json({
                    message: '版本数据缺失',
                    status: 400
                })
            }
        })
        var sqlPath = ''
        let newPath = `public/images/goods/goods${goodsInfo.goods_id}/`
        // 如果修改时没传新图片
        if (req.body.home_img) {
            sqlPath = req.body.home_img
        } else {
            fs.rename('public/images/goods/temp/' + file.filename, newPath + file.filename, (err) => {})
            sqlPath = `http://127.0.0.1:3000/images/goods/goods${goodsInfo.goods_id}/${file.filename}`
        }
        // 判断自输入的店铺是否存在
        // console.log(typeof goodsInfo.supplier);
        if (typeof goodsInfo.supplier == 'string') {
            let supplier_res = await unit.getSqlData('select * from supplier_info where supplier_name = ? ', goodsInfo.supplier)
            if (supplier_res.length != 0) {
                goodsInfo.supplier = supplier_res[0].supplier_id
            } else {
                let addSupplier_res = await unit.getSqlData('insert into supplier_info set supplier_name = ?;select supplier_id from supplier_info where supplier_name = ?', [goodsInfo.supplier, goodsInfo.supplier])
                // console.log(addSupplier_res);
                goodsInfo.supplier = addSupplier_res[1][0].supplier_id

            }
        }
        let temp = {
            product_name: goodsInfo.product_name,
            supplier_id: goodsInfo.supplier,
            descript: goodsInfo.descript,
            one_category_id: goodsInfo.catechosed[0],
            two_category_id: goodsInfo.catechosed[1],
            three_category_id: goodsInfo.catechosed[2],
            main_img: sqlPath
        }
        let updateGoods_res = await unit.getSqlData('update product_info set ? where product_id = ?', [temp, goodsInfo.goods_id])
        console.log(updateGoods_res);
        if (updateGoods_res.affectedRows == 0) {
            res.json({
                message: '修改失败',
                status: 400
            })
            return
        }
        // 添加商品sku信息
        let delAllSku = await unit.getSqlData("delete from product_sku where product_id = ?", goodsInfo.goods_id)
        for (let i = 0; i < sku.length; i++) {
            let addGoodSkutemp = {
                product_id: goodsInfo.goods_id,
                sku_version: sku[i]['sku_version' + sku[i].sku_id],
                sku_price: sku[i]['sku_price' + sku[i].sku_id],
            }
            let addGoodSku_res = await unit.getSqlData('insert into product_sku set ?', addGoodSkutemp)
            console.log(addGoodSku_res);
        }
        res.json({
            message: '修改成功',
            status: 200
        })

    }


}