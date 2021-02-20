// 数据库连接
const conn = require('../db/db')
const fs = require('fs')
const path = require('path')

module.exports = {
    /**
     * 获取mysql数据
     *
     * @param {*} sql
     * @param {boolean} [sqldata=false]
     * @returns
     */
    getSqlData(sql, sqldata = false) {
        return new Promise((resolve, reject) => {
                conn.query(sql, sqldata, (err, result) => {
                    // console.log(sql, sqldata);
                    if (err) {
                        console.log(err);
                        reject('fail')
                        return
                    }
                    resolve(result)
                })
            })
            .catch(err => {
                return err
            })
    },
    /**
     * 通过商品id获取商品信息
     *
     * @param {*} goods_id
     * @returns
     */
    async getGoodsInfoById(goods_id) {
        let goodsDeatil_sql = "select *from product_info where product_id = ?"
        let goodsDeatil_res = await this.getSqlData(goodsDeatil_sql, goods_id)
        if (goodsDeatil_res == 'fail') {
            return 'fail'
        }
        return goodsDeatil_res
    },
    /**
     * 补全商品信息
     *
     * @param {*} goodsList
     * @returns
     */
    async getGoodsInfo(goodsList) {
        let result = []
        let temp = JSON.parse(JSON.stringify(goodsList))
        for (let i = 0; i < temp.length; i++) {
            let sku = await this.getGoodsSku(temp[i].product_id);
            let image = await this.getGoodsImage(temp[i].product_id);
            let supplier = await this.getGoodsSupplier(temp[i].supplier_id);
            temp[i].sku = sku
            temp[i].image = image
            temp[i].supplier = supplier[0]
            result.push(temp[i])
        }
        return result
    },
    /**
     * 获取商品的sku信息
     *
     * @param {*} goods_id
     * @returns
     */
    async getGoodsSku(goods_id) {
        let sku_sql = "select * from product_sku where product_id = ?"
        let sku_res = await this.getSqlData(sku_sql, goods_id)
        if (sku_res == 'fail') {
            return
        }
        return sku_res
    },
    /**
     * 通过sku_id获取sku信息
     *
     * @param {*} sku_id
     * @returns
     */
    async getGoodsSkuById(sku_id) {
        let skuOne_sql = "select * from product_sku where sku_id = ?"
        let skuOne_res = await this.getSqlData(skuOne_sql, sku_id)
        if (skuOne_res == 'fail') {
            return
        }
        console.log(skuOne_res);
        return skuOne_res
    },
    /**
     * 获取商品的图片信息
     *
     * @param {*} goods_id
     * @returns
     */
    async getGoodsImage(goods_id) {
        let img_sql = "select * from product_pic_info where product_id = ?"
        let img_res = await this.getSqlData(img_sql, goods_id)
        if (img_res == 'fail') {
            return
        }
        let images = {
            goodsBanner: [],
            goodsMain: []
        }
        for (let i = 0; i < img_res.length; i++) {
            if (img_res[i].is_master == 0) {
                images.goodsBanner.push(img_res[i])
            } else if (img_res[i].is_master == 1) {
                images.goodsMain.push(img_res[i])
            }
        }
        return images
    },
    /**
     * 获取供应商信息
     *
     * @param {*} supplier_id
     * @returns
     */
    async getGoodsSupplier(supplier_id) {
        let supplier_sql = "select * from supplier_info where supplier_id = ?"
        let supplier_res = await this.getSqlData(supplier_sql, supplier_id)
        if (supplier_res == 'fail') {
            return
        }
        return supplier_res
    },
    /**
     * 生成订单主表
     *
     * @param {*} user_id
     * @param {*} addr_info
     */
    async autoOrderMaster(user_id, addr_info, order_money, mobile_phone) {
        // 订单编号
        let date = new Date()
        let year = date.getFullYear()
        let month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : '0' + (date.getMonth() + 1)
        let day = date.getDate()
        let order_sn = '' + year + month + day + user_id + date.getTime()
        // console.log(order_sn);
        let order_temp = {
            order_sn: order_sn,
            customer_id: addr_info.customer_id,
            shipping_user: addr_info.consignee,
            province: addr_info.province,
            city: addr_info.city,
            district: addr_info.district,
            address: addr_info.address,
            addr_code: addr_info.addr_code,
            order_money: order_money,
            mobile_phone: mobile_phone
        }
        let insert_order_sql = "insert into order_master set ?"
        let insert_order_res = await this.getSqlData(insert_order_sql, order_temp)
        // console.log(insert_order_res);
        if (insert_order_res.affectedRows == 1) {
            let sel_sql = "select order_id from order_master where order_sn = ?"
            let order_id = await this.getSqlData(sel_sql, order_sn)
            return order_id[0].order_id
        }
    },
    /**
     * 生成订单商品详情表
     *
     * @param {*} order_id
     * @param {*} goods
     */
    async autoOrderDetail(order_id, goods) {
        // console.log('goods_data');
        // console.log(goods);
        let goodsList = []
        for (let i = 0; i < goods.length; i++) {
            let temp_list = [
                order_id,
                goods[i].goods.product_id,
                goods[i].goods.product_name,
                goods[i].goods.main_img,
                goods[i].amount,
                goods[i].sku.sku_price,
                goods[i].sku.sku_version
            ]
            goodsList.push(temp_list)
        }
        // console.log(goodsList);
        let insert_order_detail_sql = "insert into order_detail(`order_id`,`product_id`,`product_name`, product_pic,`product_cnt`,`product_price`, product_version) values ?"
        let insert_order_detail_res = await this.getSqlData(insert_order_detail_sql, [goodsList])
        // console.log(insert_order_detail_res);
        if (insert_order_detail_res != 0) {
            return true
        }
        return false
    },
    /**
     * 随机抽取物流公司
     *
     * @returns
     */
    async randomShip() {
        let selShip_sql = "SELECT * FROM `shipping_info` ORDER BY rand() LIMIT 1"
        let selShip_res = await this.getSqlData(selShip_sql)
        // console.log(selSip_res);
        let shipping_sn = selShip_res[0].sn_start + (new Date().getTime())
        selShip_res[0].shipping_sn = shipping_sn
        return selShip_res[0]
    },
    /**
     * 通过订单id获取订单详情
     *
     * @param {*} order_id
     * @returns
     */
    async getOrderDetail(order_id) {
        let selGood_sql = "select * from order_detail where order_id = ?"
        let selGood_res = await this.getSqlData(selGood_sql, order_id)
        // console.log(order_id);
        if (selGood_res.length == 0) {
            return false
        }
        return selGood_res
    },
    /**
     * 路径是否存在，不存在则创建
     * @param {string} dir 路径
     */
    async dirExists(dir) {
        let isExists = await this.getStat(dir)
        // 如果该路径存在且不是文件，返回 true
        // console.log('res');
        if (isExists && isExists.isDirectory()) {
            return true
        } else if (isExists) { // 这个路径对应一个文件夹，无法再创建文件了
            return false
        }
        // 如果该路径不存在
        let tempDir = path.parse(dir).dir //拿到上级路径
        // 递归判断，如果上级路径也不存在，则继续循环执行，直到存在
        let status = await this.dirExists(tempDir)
        let mkdirStatus
        if (status) {
            mkdirStatus = await this.mkdir(dir)
        }
        return mkdirStatus
    },
    /**
     * 读取路径信息
     * @param {string} filepath 路径
     */
    getStat(filePath) {
        return new Promise((resolve, reject) => {
            fs.stat(filePath, (err, stats) => {
                if (err) {
                    reject(false)
                } else {
                    resolve(stats);
                }
            })
        }).catch(err => {
            return err
        })
    },
    /**
     * 创建路径
     * @param {string} dir 路径
     */
    mkdir(dir) {
        return new Promise((resolve, reject) => {
            fs.mkdir(dir, (err) => {
                if (err) {
                    reject(false)
                } else {
                    resolve(true)
                }
            })
        }).catch(err => {
            return err
        })
    },
    // 删除商品文件夹
    deleteFolder(path) {
        var files = [];
        var that = this
        if (fs.existsSync(path)) {
            files = fs.readdirSync(path);
            // console.log(files);
            files.forEach(function (file, index) {
                var curPath = path + "/" + file;
                // console.log(index);
                if (fs.statSync(curPath).isDirectory()) { // recurse
                    that.deleteFolder(curPath);
                } else { // delete file
                    fs.unlinkSync(curPath);
                }
            });
            fs.rmdirSync(path);
        }
    }
}