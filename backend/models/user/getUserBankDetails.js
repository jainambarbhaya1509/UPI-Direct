const { pool } = require("../../config/dbConfig")
const { redis } = require("../../config/redisServer")

const getUserBankDetails = async (userId) => {
    try {
        const { rows } = await pool.query(
            'SELECT bank_name,account_number,ifsc_code,balance FROM bank_accounts WHERE vid = $1',
            [userId]
        )
        console.log(rows);
        
        return rows[0].balance
    } catch (error) {
        console.error("Error fetching balance data:", error)
        throw error
    }
}
module.exports=getUserBankDetails