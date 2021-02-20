const unit = require('./unit')
const _ = require('lodash')

module.exports = {
    /**
     * 生成订单
     *
     * @param {*} req
     * @param {*} res
     */
    async generateOrder(req, res) {
        let addr_info = req.body.addrInfo
        let user_id = req.body.userId
        let order_money = req.body.order_money
        let goods_info = req.body.goods
        let mobile_phone = req.body.mobile_phone
        // 生成订单主表
        let order_id = await unit.autoOrderMaster(user_id, addr_info, order_money, mobile_phone)
        // 生成订单商品详情表
        let result = await unit.autoOrderDetail(order_id, goods_info)
        // 生成订单后删除购物车占位
        // 判断是否存在cart_id 若不存在(undefined) 是从商品详情来的 不需要删
        if (Boolean(goods_info[0].cart_id)) {
            let glist_temp = []
            for (let i = 0; i < goods_info.length; i++) {
                glist_temp.push(goods_info[i].cart_id)
            }
            // console.log(glist_temp);
            let delCart_sql = "delete from shop_cart where cart_id in ?"
            let delCart_res = await unit.getSqlData(delCart_sql, [
                [glist_temp]
            ])
            // console.log(delCart_res);
        }
        // console.log(result);

        if (result) {
            res.json({
                message: '订单生成成功',
                status: 200,
                orderId: order_id
            })
        } else {
            res.json({
                message: '订单生成失败',
                status: 400
            })
        }
    },
    /**
     *  通过订单id获取订单信息
     *
     * @param {*} req
     * @param {*} res
     */
    async getOrderInfoByOrderId(req, res) {
        let order_id = req.body.orderId
        // let selOrder_sql = "select * from order_master where order_id = ?"
        let selOrder_sql = `select * 
        from order_master m JOIN order_detail d 
        on m.order_id = d.order_id 
        where m.order_id = ?
        `
        let selOrder_res = await unit.getSqlData(selOrder_sql, order_id)
        if (selOrder_res.length == 0) {
            res.json({
                message: '未查询到订单',
                status: 400
            })
            return
        }
        // console.log(order_id);
        // let selGood_res = await unit.getOrderDetail(order_id)
        // if (!selGood_res) {
        //     res.json({
        //         message: '未查询到订单商品',
        //         status: 400
        //     })
        //     return
        // }
        // console.log(selGood_res);
        // selOrder_res[0].goods = selGood_res
        // console.log(selGood_res);
        // console.log(selOrder_res[0]);
        res.json({
            message: '订单查询成功',
            status: 200,
            orderInfo: selOrder_res[0]
        })
    },
    /**
     * 支付成功后改变订单状态
     *
     * @param {*} req
     * @param {*} res
     */
    async modifyOrderState(req, res) {
        let order_id = req.body.orderId
        let user_id = req.body.userId
        let pay_way = req.body.payWay
        let pay_money = req.body.payMoney
        let status = await unit.getSqlData("select order_status from order_master where order_id = ?", order_id)
        // console.log(status);
        // console.log(order_id);
        if (status[0].order_status == 1) {
            res.json({
                message: '订单已支付',
                status: 304
            })
            return
        }
        // 随机快递 随机快递单号
        let ship = await unit.randomShip()
        let temp = {
            payment_method: pay_way,
            payment_money: pay_money,
            shipping_comp_name: ship.ship_name,
            shipping_sn: ship.shipping_sn,
            order_status: 1,
            pay_time: new Date()
        }
        // 1、将订单状态改变为已支付
        let modify_sql = "update order_master set ? where order_id = ?"
        let modify_res = await unit.getSqlData(modify_sql, [temp, order_id])
        // console.log(modify_res);
        if (modify_res.affectedRows == 0) {
            res.json({
                message: '支付失败',
                status: 400
            })
            return
        }
        // 2、扣钱
        let user_money = await unit.getSqlData("select user_money from customer_inf where customer_id = ?", user_id)
        // console.log(user_money[0].user_money);
        let new_money = user_money[0].user_money - pay_money
        // console.log(new_money);
        let money_res = await unit.getSqlData("update customer_inf set user_money = ? where customer_id = ?", [new_money, user_id])
        console.log(money_res);
        if (money_res.affectedRows == 1) {
            res.json({
                message: '支付成功',
                status: 200
            })
        }
    },
    /**
     * 通过用户id获取订单列表
     *
     * @param {*} req
     * @param {*} res
     */
    async getOrderListById(req, res) {
        let user_id = req.body.userId
        let status = req.body.orderStatus
        let pagenum = req.body.pageNum
        let pagesize = req.body.pageSize
        let page_ = (pagenum - 1) * pagesize
        let order_list_sql = ''
        let order_list_res = []
        // console.log(req.body);
        if (status == 'all') {
            order_list_sql = `select *,COUNT(1) OVER() AS total 
            from order_master m JOIN order_detail d 
            on m.order_id = d.order_id
            where m.customer_id = ? 
            ORDER BY create_time DESC
            limit ?,?`
            order_list_res = await unit.getSqlData(order_list_sql, [user_id, page_, pagesize])
        } else {
            order_list_sql = `select *,COUNT(1) OVER() AS total 
            from order_master m JOIN order_detail d 
            on m.order_id = d.order_id 
            where customer_id = ?  and order_status = ?
            ORDER BY create_time DESC
            limit ?,?`
            order_list_res = await unit.getSqlData(order_list_sql, [user_id, status, page_, pagesize])
        }
        if (order_list_res == 'fail') {
            res.json({
                message: '获取订单列表失败',
                status: 400
            })
            return
        }
        res.json({
            message: '获取订单列表成功',
            status: 200,
            result: order_list_res
        })
    },

    /**
     * 发货
     *
     * @param {*} req
     * @param {*} res
     */
    async shipping(req, res) {
        let order_id = req.body.orderId
        let temp = {
            order_status: 2,
            shipping_time: new Date()
        }
        let confirm_sql = "update order_master set ? where order_id = ? "
        let confirm_res = await unit.getSqlData(confirm_sql, [temp, order_id])
        if (confirm_res.affectedRows == 1) {
            res.json({
                message: '发货成功',
                status: 200
            })
            return
        }
        res.json({
            message: '发货失败',
            status: 400
        })
    },
    /**
     * 确认收货
     *
     * @param {*} req
     * @param {*} res
     */
    async confirmReceipt(req, res) {
        let order_id = req.body.orderId
        let temp = {
            order_status: 3,
            receive_time: new Date()
        }
        let confirm_sql = "update order_master set ? where order_id = ? "
        let confirm_res = await unit.getSqlData(confirm_sql, [temp, order_id])
        if (confirm_res.affectedRows == 1) {
            res.json({
                message: '收货成功',
                status: 200
            })
            return
        }
        res.json({
            message: '收货失败',
            status: 400
        })
    },
    // 查询评价用订单详情
    async commentSelOrder(req, res) {
        let order_id = req.body.orderId
        let goods_id = req.body.goodsId
        let comment_sql = `SELECT * FROM order_master m JOIN order_detail d 
        ON m.order_id = d.order_id WHERE m.order_id = ? AND product_id = ?`
        let comment_res = await unit.getSqlData(comment_sql, [order_id, goods_id])
        if (comment_res.length == 0) {
            res.json({
                message: '查询失败',
                status: 400
            })
            return
        }
        res.json({
            message: '查询成功',
            status: 200,
            result: comment_res[0]
        })
    },
    /**
     * 发布评论，将数据插入评论表
     *
     * @param {*} req
     * @param {*} res
     */
    async makeComment(req, res) {
        let commentInfo = req.body.orderInfo
        // 查询是否评价过
        let checkComment_sql = "select * from product_comment where order_id = ? and product_id = ?"
        let checkComment_res = await unit.getSqlData(checkComment_sql, [commentInfo.order_id, commentInfo.product_id])
        // console.log(checkComment_res);
        // 如果有评价,返回错误
        if (checkComment_res.length != 0) {
            res.json({
                message: '发布失败',
                status: 400
            })
            return
        }
        let makeComment_sql = "insert into product_comment set ?"
        let makeComment_res = await unit.getSqlData(makeComment_sql, commentInfo)
        // console.log(makeComment_res);
        if (makeComment_res.affectedRows == 1) {
            // 修改订单状态至 完成
            let orderStatusChange_sql = "update order_master set order_status = 4 where order_id = ?"
            let orderStatusChange_res = await unit.getSqlData(orderStatusChange_sql, commentInfo.order_id)
            //    console.log(orderStatusChange_res);
            res.json({
                message: '发布成功',
                status: 200
            })
            return
        }
        res.json({
            message: '发布失败',
            status: 400
        })
    },
    
}