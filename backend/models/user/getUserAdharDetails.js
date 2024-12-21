const { pool } = require("../../config/dbConfig");
const { redis } = require("../../config/redisServer");

//vid-> adhar card number
const getUserAdharDetails = async (vid) => {
    try {
        // Fetch personal details
        const cacheData = await redis.get(`getUserAdharDetails:${vid}`)
        if (cacheData) return JSON.parse(cacheData);

        const query = `
            SELECT vid,name,email,phone_number FROM aadhar_info WHERE vid=$1 `;

        const personalDetailsResult = (await pool.query(query, [vid])).rows[0];
        
        if (!personalDetailsResult) {
            throw new Error(`Account with ID ${vid} not found`);
        }

        // Parse balance to float

        redis.set(`getUserAdharDetails:${vid}`, JSON.stringify(personalDetailsResult))

        return personalDetailsResult
    } catch (error) {
        console.error('Error executing query:', error.stack);
        throw error;
    }
};

module.exports = getUserAdharDetails;
