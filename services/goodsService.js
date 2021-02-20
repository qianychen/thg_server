const unit = require('./unit')
const _ = require('lodash')


module.exports = {
    /**
     * 获取分类信息
     *
     * @param {*} req
     * @param {*} res
     */
    async getCategory(req, res) {
        let sql = "select * from product_category "
        const categories = await unit.getSqlData(sql)
        let keyCategories = _.keyBy(categories, 'category_id');
        let result = [];
        for (idx in categories) {
            let cat = categories[idx];
            if (cat.parent_id == 0) {
                result.push(cat);
            } else {
                let parantCat = keyCategories[cat.parent_id];
                if (!parantCat) continue;
                if (!parantCat.children) {
                    parantCat["children"] = [];
                }
                parantCat.children.push(cat);
            }
        }
        res.json({
            message: '获取商品分类成功',
            status: 200,
            result: result
        })
    },
    /**
     * 获取所有商品信息
     *
     * @param {*} req
     * @param {*} res
     */
    async getGoods(req, res) {
        let goods_sql = "select * from product_info where audit_status = 1 and publish_status = 1"
        let goods_res = await unit.getSqlData(goods_sql)
        if (goods_res == 'fail') {
            res.json({
                message: '获取商品失败',
                status: 400
            })
            return
        }
        res.json({
            message: "获取商品成功",
            status: 200,
            result: goods_res
        })
    },

    /**
     * 通过关键词搜索商品
     *
     * @param {*} req
     * @param {*} res
     */
    async getGoodsByKeyword(req, res) {
        let keyword = req.body.keyword
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
        let keyword_ = keyword ? "%" + keyword + "%" : '%'
        let query_temp = [
            keyword_,
            parseInt(page_),
            parseInt(pagesize)
        ]
        let goodsKeyword_sql = `select *,COUNT(1) OVER() AS total from product_info where audit_status = 1 and publish_status = 1 and product_name like ? limit ?,?`
        let goodsKeyword_res = await unit.getSqlData(goodsKeyword_sql, query_temp)
        if (goodsKeyword_res == 'fail') {
            res.json({
                message: 'ByKeyword获取商品失败',
                status: 400
            })
            return
        }
        let result = await unit.getGoodsInfo(goodsKeyword_res)
        res.json({
            message: "ByKeyword获取商品成功",
            status: 200,
            result: result
        })
    },
    /**
     * 通过商品id获取商品详情信息
     *
     * @param {*} req
     * @param {*} res
     */
    async getGoodsDetailById(req, res) {
        let goods_id = req.body.goods_id
        let goodsDeatil_res = await unit.getGoodsInfoById(goods_id)
        // console.log(goodsDeatil_res);
        if (goodsDeatil_res == "fail") {
            res.json({
                message: "获取商品详情失败",
                status: 400
            })
        }
        let result = await unit.getGoodsInfo(goodsDeatil_res)
        res.json({
            message: '获取商品详情成功',
            status: 200,
            result: result
        })
    },
    // 加入购物车
    async insertShopCart(req, res) {
        let shopInfo = req.body.shopInfo
        // console.log(shopInfo);
        // 查询购物车是否有该商品
        let selGoods_sql = "select * from shop_cart where customer_id = ? and product_id = ? and sku_id = ?"
        let selGoods_res = await unit.getSqlData(selGoods_sql, [shopInfo.customer_id, shopInfo.product_id, shopInfo.sku_id])
        // console.log(selGoods_res);
        // if 没有则添加
        if (selGoods_res.length == 0) {
            let insertShopCart_sql = "insert into shop_cart set ?"
            let insertShopCart_res = await unit.getSqlData(insertShopCart_sql, shopInfo)
            // console.log(insertShopCart_res);
            if (insertShopCart_res.affectedRows == 1) {
                res.json({
                    message: '加入购物车成功',
                    status: 200
                })
                return
            }
        } else {
            // if 有 只增加数量
            let newAmount = selGoods_res[0].amount + shopInfo.amount
            let modifyShopCart_sql = "update shop_cart set amount = ? where cart_id = ?"
            let modifyShopCart_res = await unit.getSqlData(modifyShopCart_sql, [newAmount, selGoods_res[0].cart_id])
            // console.log(modifyShopCart_res);
            if (modifyShopCart_res.affectedRows == 1) {
                res.json({
                    message: '加入购物车成功',
                    status: 200
                })
                return
            }
        }
        res.json({
            messgae: '加入购物车失败',
            status: 400
        })
    },
    // 获取购物车数据
    async getShopCartInfo(req, res) {
        let userId = req.body.userId
        let shopCart_sql = "select * from shop_cart where customer_id = ?"
        let shopCart_res = await unit.getSqlData(shopCart_sql, userId)
        if (shopCart_res.legnth == 0) {
            res.json({
                message: '购物车为空',
                status: 401
            })
            return
        }
        // console.log(shopCart_res);
        let shopCart_temp = []
        for (let i = 0; i < shopCart_res.length; i++) {
            let goods = await unit.getGoodsInfoById(shopCart_res[i].product_id)
            console.log(shopCart_res[i].sku_id);
            let sku = await unit.getGoodsSkuById(shopCart_res[i].sku_id)
            console.log(sku);
            shopCart_res[i].sku = sku[0]
            shopCart_res[i].goods = goods[0]
            shopCart_temp.push(shopCart_res[i])
        }
        // console.log(shopCart_temp);
        if (shopCart_res.legnth != 0) {
            res.json({
                message: '获取购物车数据成功',
                status: 200,
                result: shopCart_temp
            })
            return
        }
        res.json({
            messgae: "获取购物车数据失败",
            status: 400
        })
    },

    /**
     * 修改购物车商品数量
     *
     * @param {*} req
     * @param {*} res
     */
    async modifyShopCartAmount(req, res) {
        let cartInfo = req.body
        console.log(cartInfo);
        let modify_sql = "update shop_cart set amount = ? where cart_id = ?"
        let modify_res = await unit.getSqlData(modify_sql, [cartInfo.amount, cartInfo.cartId])
        console.log(modify_res);
        if (modify_res.affectedRows == 1) {
            res.json({
                message: '修改购物车商品数量成功',
                status: 200
            })
            return
        }
        res.json({
            message: '修改购物车商品数量失败',
            status: 400
        })
    },
    /**
     * 删除购物车商品
     *
     * @param {*} req
     * @param {*} res
     */
    async delShopCartGoods(req, res) {
        let cart_id = req.body.cartId
        console.log(cart_id);
        let del_sql = "delete from shop_cart where cart_id = ?"
        let del_res = await unit.getSqlData(del_sql, cart_id)
        console.log(del_res);
        if (del_res.affectedRows == 1) {
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
    /**
     * 随机推荐商品
     *
     * @param {*} req
     * @param {*} res
     */
    async recommendGoods(req, res) {
        let num = req.body.num
        let recommend_sql = "SELECT * FROM `product_info` where  audit_status = 1 and publish_status = 1 ORDER BY rand() LIMIT ?"
        let recommend_res = await unit.getSqlData(recommend_sql, num)
        console.log(recommend_res);
        if (recommend_res.length == 0) {
            res.json({
                message: "随机商品失败",
                status: 400
            })
            return
        }
        res.json({
            message: '随机商品成功',
            status: 200,
            result: recommend_res
        })
    },
    /**
     * 通过商品id获取商品评价
     *
     * @param {*} req
     * @param {*} res
     */
    async getGoodsCommentByGoodsId(req, res) {
        let product_id = req.body.product_id
        let pageSize = req.body.pageSize
        let pageNum = req.body.pageNum
        let newPageNum = (pageNum - 1) * pageSize
        // console.log(product_id);
        let goodsComment_sql = `
            SELECT a.*, c.nick_name, o.product_version, COUNT(1) OVER() AS total 
            FROM product_comment AS a JOIN customer_inf AS c 
            ON a.customer_id = c.customer_id
            JOIN order_detail AS o
            ON o.order_id = a.order_id
            WHERE a.product_id = ?
            limit ?,?`
        let goodsComment_res = await unit.getSqlData(goodsComment_sql, [product_id, newPageNum, pageSize])
        // console.log(goodsComment_res);
        res.json({
            message: 'success',
            status: 200,
            result: goodsComment_res
        })
    }

}