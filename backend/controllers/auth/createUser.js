const jwt = require('jsonwebtoken');
const { pool } = require('../../config/dbConfig');
const { comparePassword } = require('../../utils/helper');
const getUserAdharDetails = require('../../models/user/getUserAdharDetails');

const tokenSecret = process.env.JWTTOKENSECRET;
const tokenOptions = {
    expiresIn: '720h', // Changed '720hr' to '720h' for standard format
};

const validateCredentials = async (vid) => {
    try {
        const query = `
            SELECT vid,name,email,phone_number FROM aadhar_info WHERE vid=$1 `;
        const result = await pool.query(query, [vid]);

        if (result.rows.length === 0) {
            return { valid: false, error: "Invalid credentials" };
        }
        console.log(result.rows[0]);
        
        const user = result.rows[0];


        return { valid: true, userId: user.vid, userName: user.name, error: null };
    } catch (error) {
        console.error("Error validating credentials:", error);
        return { valid: false, error: "An internal error occurred" };
    }
}

const generateToken = (userId) => {
    const tokenPayload = { id: userId };
    return jwt.sign(tokenPayload, tokenSecret, tokenOptions);
}

const createUser = async (req, res) => {
    try {
        const { vid } = req.body;
        const findUser=await pool.query('SELECT upi_pin,upi_id FROM users WHERE vid=$1',[vid])
        if (findUser.rows.length!==0) {
        const userDetails = await getUserAdharDetails(vid);
        const token = generateToken(vid);

            return res.send({
                message:"user exist",
                ...userDetails,
                upi_id:findUser.rows[0].upi_id,
                pin:findUser.rows[0].upi_pin,
                token
            })
        }

        const { valid, userId, userName, error } = await validateCredentials(Number(vid));
        if (!valid) {
            return res.status(200).json({ valid: false, error: error });
        }

        const token = generateToken(userId);
        
        const userDetails = await getUserAdharDetails(userId);
        
        return res.status(200).json({ ...userDetails, valid: true, token: token, name: userName });
    } catch (error) {
        console.error("Error creating user:", error);
        return res.status(500).json({ error: "Something went wrong" });
    }
}

module.exports = createUser;
