const unit = require('./unit')
const _ = require('lodash')


module.exports = {
    async getHelp(req, res) {
        let help_sql = "select * from help"
        let help_res = await unit.getSqlData(help_sql)
        res.json({
            message: '获取帮助成功',
            status: 200,
            result: help_res
        })
    },
    async getHelpById(req, res) {
        let help_id = req.query.help_id
        // console.log(help_id);
        let help_sql = "select * from help where help_id = ?"
        let help_res = await unit.getSqlData(help_sql, [help_id])
        res.json({
            message: '获取帮助成功',
            status: 200,
            result: help_res[0]
        })
    },
    async randomHelp(req, res) {
        let help_sql = "select * from help ORDER BY rand() LIMIT 6"
        let help_res = await unit.getSqlData(help_sql)
        res.json({
            message: '获取帮助成功',
            status: 200,
            result: help_res
        })
        
    }
}