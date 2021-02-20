const unit = require('./unit')
const _ = require('lodash')
const multer = require('multer')
const db = require('../db/db')
const fs = require("fs")

module.exports = {
    /**
     * 用户登录
     *
     * @param {*} req accout password type
     * @param {*} res
     */
    async login(req, res) {
        var accout = req.body
        let accoutSql
        //判断账号类型
        if (accout.type == 'phone') {
            accoutSql = "select * from customer_inf where mobile_phone = ?"
        } else if (accout.type == 'email') {
            accoutSql = "select * from customer_inf where customer_email = ?"
        }
        console.log(accoutSql);
        let isRge = await unit.getSqlData(accoutSql, accout.accout)
        // 用户不存在
        if (isRge.length == 0) return res.json({
            message: '用户名不存在',
            status: 400
        })
        // 用户账号密码核对
        if (isRge[0].mobile_phone == accout.accout && isRge[0].password == accout.password || isRge[0].customer_email == accout.accout && isRge[0].password == accout.password) {
            // 生成token
            let token = 'thg' + new Date().getTime()
            res.json({
                // 去除password
                userinfo: _.omit(isRge[0], "password"),
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
     * 查询手机号是否被注册
     *
     * @param {*} req phone
     * @param {*} res
     */
    async check_phone(req, res) {
        let phone = req.body
        console.log(phone);
        let phone_sql = 'select * from customer_inf where mobile_phone = ?'
        let phone_res = await unit.getSqlData(phone_sql, phone.phone)
        if (!phone_res.length == 0) {
            res.json({
                message: '手机号已被注册',
                status: 400
            })
        } else {
            res.json({
                message: '手机号未被注册',
                status: 200
            })
        }
    },
    /**
     * 查询邮箱是否被注册
     *
     * @param {*} req 
     * @param {*} res
     */
    async check_email(req, res) {
        let email = req.body.email
        console.log(email);
        let email_sql = 'select * from customer_inf where customer_email = ?'
        let email_res = await unit.getSqlData(email_sql, email)
        if (!email_res.length == 0) {
            res.json({
                message: '邮箱已被绑定',
                status: 400
            })
        } else {
            res.json({
                message: '邮箱未被绑定',
                status: 200
            })
        }
    },
    /**
     * 注册发送验证码
     *
     * @param {*} req 
     * @param {*} res
     */
    sendCode(req, res) {
        let randomNum = ('000000' + Math.floor(Math.random() * 999999)).slice(-6);
        res.json({
            status: 200,
            code: randomNum
        })
    },
    /**
     * 用户注册
     *
     * @param {*} req 
     * @param {*} res
     */
    async register(req, res) {
        let accout = req.body
        // console.log(accout);
        let insert_sql = "insert into customer_inf(nick_name, password, mobile_phone) value (?)"
        let randomNum = ('000000' + Math.floor(Math.random() * 999999)).slice(-6);
        let nick_name = '惠购达人' + randomNum

        let insert_res = await unit.getSqlData(insert_sql, [
            [nick_name, accout.pass, accout.phone]
        ])
        console.log(insert_res)
        if (insert_res == 'fail') {
            res.json({
                message: '注册失败',
                status: 400
            })
            return
        }
        res.json({
            message: '注册成功',
            status: 200
        })
    },
    /**
     * 通过用户id查询用户信息
     *
     * @param {*} req
     * @param {*} res
     */
    async getUserInfoById(req, res) {
        // 获取用户id
        let user_id = req.body.id
        // console.log(req.body);
        if (user_id == '') {
            res.json({
                message: '未检测到id',
                status: 400
            })
        }
        let userInfo_sql = "select * from customer_inf where customer_id = ?"
        let userInfo_res = await unit.getSqlData(userInfo_sql, user_id)
        if (userInfo_res.length == 0) {
            res.json({
                message: '用户信息查询失败',
                status: 401
            })
            return
        }
        res.json({
            message: '用户信息查询成功',
            status: 200,
            userInfo: _.omit(userInfo_res[0], "password")
        })
    },
    /**
     * 修改用户基本资料
     *
     * @param {*} req 昵称 性别 生日
     * @param {*} res
     */
    async modifyUserInfo(req, res) {
        let user = req.body
        console.log(user);
        let update_sql = "update customer_inf set nick_name = ?, gender = ?, birthday = ? where customer_id = ?"
        let update_res = await unit.getSqlData(update_sql, [user.nick_name, user.gender, user.birthday, user.customer_id])
        console.log(update_res);
        if (update_res.affectedRows == 0) {
            res.json({
                message: '更新失败',
                status: 400
            })
            return
        }
        res.json({
            message: '更新成功',
            status: 200
        })
    },
    /**
     * 修改用户头像
     *
     * @param {*} req
     * @param {*} res
     */
    async modifyUserAvatar(req, res) {
        let user_id = req.body.id
        let files = req.files;
        let file = files[0];
        console.log(file);
        // 重命名文件
        let last = file.originalname.split('.')
        let newPath = 'public/images/userAvatar/' + file.fieldname + '-' + user_id + '.' + last[last.length - 1]
        
        fs.renameSync('public/images/userAvatar/' + file.filename, newPath, (err) => {
            console.log(err);
        })
        // 将文件路径保存至服务器
        let temp = newPath.split('/')
        temp.shift()
        temp.join('/', temp)
        let sqlPath = 'http://127.0.0.1:3000/' + temp.join('/', temp)
        let uploadRes = await unit.getSqlData("update customer_inf set avatar = ? where customer_id = ?", [sqlPath, user_id])
        console.log(uploadRes);
        if (uploadRes.affectedRows != 1) {
            res.json({
                message: '上传失败',
                status: 400
            })
            return
        }
        res.json({
            message: '上传成功',
            status: 200,
            avatarUrl: sqlPath
        })
    },
    /**
     * 通过用户id获取用户地址
     *
     * @param {*} req
     * @param {*} res
     */
    async getUserAddrById(req, res) {
        let user_id = req.body.id
        // console.log(user_id);
        let userAddr_sql = "select * from customer_addr where customer_id = ? ORDER BY `customer_addr_id` DESC"
        let userAddr_res = await unit.getSqlData(userAddr_sql, user_id)
        // console.log(userAddr_res);
        if (userAddr_res.length == 0) {
            res.json({
                message: '未设置地址',
                address: [],
                status: 400
            })
        } else {
            res.json({
                message: '获取地址成功',
                address: userAddr_res,
                status: 200
            })
        }
    },
    /**
     * 通过用户地址id删除用户地址
     *
     * @param {*} req
     * @param {*} res
     */
    async delUserAddrById(req, res) {
        let addr_id = req.body.addrId
        // console.log(addr_id);
        let delAddr_sql = "delete from customer_addr where customer_addr_id = ?"
        let delAddr_res = await unit.getSqlData(delAddr_sql, addr_id)
        // 用影响的行数判断语句是否执行成功(affectedRows)
        if (delAddr_res.affectedRows != 0) {
            res.json({
                message: '删除成功',
                status: 200
            })
        } else {
            res.json({
                message: '删除失败',
                status: 400
            })
        }
    },
    /**
     * 添加用户地址
     *
     * @param {*} req
     * @param {*} res
     */
    async addUserAddr(req, res) {
        let address = req.body.address
        let userId = req.body.userId
        let is_default
        // 通过id查询用户地址是否超过20个
        let userAddr_sql = "select * from customer_addr where customer_id = ?"
        let userAddr_res = await unit.getSqlData(userAddr_sql, userId)
        if (userAddr_res.length >= 20) {
            res.json({
                message: '地址数量上限',
                status: 401
            })
            return
        }
        // console.log(address, userId);
        // 如果没设置地址 设置第一个为默认地址
        if (userAddr_res.length == 0) {
            is_default = 1
        } else {
            is_default = 0
        }
        // 添加用户地址
        let addAddr_sql = "insert into customer_addr(customer_id, consignee, mobile_phone, province, city, district, address, addr_code, is_default)value (?)"
        let addAddr_res = await unit.getSqlData(addAddr_sql, [
            [userId, address.consignee, address.mobile_phone, address.province, address.city, address.district, address.address, address.selectedAddr, is_default]
        ])
        // console.log(addAddr_res);
        if (addAddr_res.affectedRows != 0) {
            res.json({
                message: '添加地址成功',
                status: 200
            })
        } else {
            res.json({
                message: '添加地址失败',
                status: 400
            })
        }
    },
    /**
     * 通过地址的id查询地址信息（用于修改）
     *
     * @param {*} req
     * @param {*} res
     */
    async getUserAddrByAddrId(req, res) {
        let addr_id = req.body.addrId
        // console.log(addr_id);
        let selAddr_sql = "select * from customer_addr where customer_addr_id = ?"
        let selAddr_res = await unit.getSqlData(selAddr_sql, addr_id)
        // console.log(selAddr_res);
        if (selAddr_res.length == 0) {
            res.json({
                message: '查询失败',
                status: 400
            })
        } else {
            res.json({
                message: '查询成功',
                status: 200,
                addr: selAddr_res[0]
            })
        }
    },
    /**
     * 通过地址id修改用户地址
     *
     * @param {*} req
     * @param {*} res
     */
    async modifyUserAddr(req, res) {
        let editForm = req.body.editForm
        let editAddr_sql = `update customer_addr 
                            set consignee = ?, mobile_phone = ?, province = ?,city = ?, district = ?, address = ?, addr_code = ?
                            where customer_addr_id = ? `
        let addrData = [
            editForm.consignee,
            editForm.mobile_phone,
            editForm.province,
            editForm.city,
            editForm.district,
            editForm.address,
            editForm.addr_code,
            editForm.customer_addr_id
        ]
        let editAddr_res = await unit.getSqlData(editAddr_sql, addrData)
        if (editAddr_res.affectedRows == 1) {
            res.json({
                message: '修改地址成功',
                status: 200
            })
        } else {
            res.json({
                message: '修改地址失败',
                status: 400
            })
        }
        // console.log(editAddr_res);
    },
    /**
     * 设置默认收货地址
     *
     * @param {*} req
     * @param {*} res
     */
    async setDefAddr(req, res) {
        let addr_id = req.body.addrId
        let user_id = req.body.userId
        // console.log(addr_id);
        // 查询是否有默认的地址
        let checkDefAddr_sql = "select * from customer_addr where is_default = 1 and customer_id = ? "
        let checkDefAddr_res = await unit.getSqlData(checkDefAddr_sql, user_id)
        // console.log(checkDefAddr_res);
        // if有默认地址 修改为false
        if (checkDefAddr_res.length != 0) {
            let removeDefAddr_sql = "update customer_addr set is_default = 0 where customer_addr_id = ?"
            await unit.getSqlData(removeDefAddr_sql, checkDefAddr_res[0].customer_addr_id)
        }
        let modifyDefAddr_sql = "update customer_addr set is_default = 1 where customer_addr_id = ?"
        let modifyDefAddr_res = await unit.getSqlData(modifyDefAddr_sql, addr_id)
        // console.log(modifyDefAddr_res);
        if (modifyDefAddr_res.affectedRows == 1) {
            res.json({
                message: '修改默认收货地址成功',
                status: 200
            })
        } else {
            res.json({
                message: '修改默认收货地址失败',
                status: 400
            })
        }
    },
    /**
     * 实名认证
     *
     * @param {*} req
     * @param {*} res
     */
    async modifyUserIdCard(req, res) {
        let user = req.body.user
        let user_id = req.body.userId
        let modify_sql = "update customer_inf set ? where customer_id = ?"
        let modify_res = await unit.getSqlData(modify_sql, [user, user_id])
        if (modify_res.affectedRows == 1) {
            res.json({
                message: '实名认证成功',
                status: 200
            })
            return
        }
        res.json({
            message: '实名认证失败',
            status: 400
        })
    },
    /**
     * 绑定邮箱
     *
     * @param {*} req
     * @param {*} res
     */
    async modifyEmail(req, res) {
        let email = req.body.email
        let user_id = req.body.user_id
        console.log(email, user_id);
        let modifyEmail_sql = "update customer_inf set customer_email = ? where customer_id = ?"
        let modifyEmail_res = await unit.getSqlData(modifyEmail_sql, [email.email, user_id])
        console.log(modifyEmail_res);
        if (modifyEmail_res.affectedRows == 1) {
            res.json({
                message: '绑定成功',
                status: 200
            })
            return
        }
        res.json({
            message: '绑定失败',
            status: 400
        })
    },
    /**
     * 查询旧密码
     *
     * @param {*} req
     * @param {*} res
     */
    async getOldPasswordById(req, res) {
        let user_id = req.body.userId
        let selOldPsd_sql = "select password from customer_inf where customer_id = ?"
        let selOldPsd_res = await unit.getSqlData(selOldPsd_sql, user_id)
        console.log(selOldPsd_res);
        if (selOldPsd_res.length != 0) {
            res.json({
                message: '获取成功',
                status: 200,
                psd: selOldPsd_res[0].password
            })
            return
        }
        res.json({
            message: 'fail',
            status: 400
        })
    },
    /**
     * 通过用户id修改密码
     *
     * @param {*} req
     * @param {*} res
     */
    async modifyPassWord(req, res) {
        let psdInfo = req.body.psdInfo
        let user_id = req.body.userId

        if (!user_id) {
            let modifyPsd_sql = `update customer_inf 
            set password = ?
            where customer_id = (
                select customer_id
                from customer_inf
                where mobile_phone = ?
            )`
            let modifyPsd_res = await unit.getSqlData(modifyPsd_sql, [psdInfo.pass, psdInfo.phone])
            // console.log(psdInfo);
            if (modifyPsd_res.affectedRows == 1) {
                res.json({
                    message: '密码修改成功',
                    status: 200
                })
                return
            }
            res.json({
                message: '密码修改失败',
                status: 400
            })
        }
        let modifyPsd_sql = "update customer_inf set password = ? where customer_id = ?"
        let modifyPsd_res = await unit.getSqlData(modifyPsd_sql, [psdInfo.pass, user_id])
        // console.log(modifyPsd_res);
        if (modifyPsd_res.affectedRows == 1) {
            res.json({
                message: '密码修改成功',
                status: 200
            })
            return
        }
        res.json({
            message: '密码修改失败',
            status: 400
        })
    },
    /**
     * 修改绑定的手机号
     *
     * @param {*} req
     * @param {*} res
     */
    async modifyPhone(req, res) {
        let user_id = req.body.userId
        let phoneInfo = req.body.phoneInfo
        let modifyPhone_sql = "update customer_inf set mobile_phone = ? where customer_id = ?"
        let modifyPhone_res = await unit.getSqlData(modifyPhone_sql, [phoneInfo.phone, user_id])
        console.log(phoneInfo, user_id);
        if (modifyPhone_res.affectedRows == 1) {
            res.json({
                message: '手机号绑定成功',
                status: 200
            })
            return
        }
        res.json({
            message: '手机号绑定失败',
            status: 400
        })
    },
    /**
     * 用户充值余额
     *
     * @param {*} req
     * @param {*} res
     */
    async UserRecharge(req, res) {
        let reaInfo = req.body
        let newMoney = Number(reaInfo.user_money) + reaInfo.old_money
        console.log(reaInfo.old_money);
        let userRea_sql = "update customer_inf set user_money = ? where customer_id = ?"
        let userRea_res = await unit.getSqlData(userRea_sql, [newMoney, reaInfo.user_id])
        console.log(userRea_res);
        if (userRea_res.affectedRows == 0) {
            res.json({
                message: '充值失败',
                status: 400
            })
            return
        }
        res.json({
            message: '充值成功',
            status: 200
        })
    }
}