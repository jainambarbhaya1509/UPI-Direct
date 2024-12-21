const jwt = require('jsonwebtoken');
const { pool } = require('../../config/dbConfig');
const { comparePassword } = require('../../utils/helper');
const getUserid = require('../../models/user/getUserid');
const getUserAdharDetails = require('../../models/user/getUserAdharDetails');
const getUserBankDetails = require('../../models/user/getUserBankDetails');

const tokenSecret = process.env.JWTTOKENSECRET;

const validateCredentials = async (token, pin) => {
    try {
        const decoded = jwt.verify(token, tokenSecret);
        const vid = decoded.id;

        const findUser = await pool.query("SELECT upi_pin, vid FROM users WHERE vid=$1", [vid]);

        if (findUser.rows.length === 0) {
            return { valid: false, error: "Invalid credentials" };
        }

        const userPin = findUser.rows[0].upi_pin;
        const isPasswordValid = comparePassword(`${pin}`, userPin); // pass pin as string

        if (!isPasswordValid) {
            return { valid: false, error: "Invalid credentials" };
        }

        return { valid: true, error: null };
    } catch (err) {
        console.error("Error validating credentials:", err);
        if (err.name === 'TokenExpiredError' || err.name === 'JsonWebTokenError') {
            return { valid: false, error: "Session expired" };
        }
        return { valid: false, error: "An internal error occurred" };
    }
}

const validateUser = async (req, res) => {
    try {
        //accountNumber->stores Token
        const { token, pin } = req.body;
        const { valid, error } = await validateCredentials(token, pin);

        if (!valid) {
            return res.status(200).send({ valid: false, error: error });
        }
        console.log(token)

        const { id } = getUserid(token);
        const userDetails = await getUserAdharDetails(id);
        const getUserBankDetail = await getUserBankDetails(id);

        return res.status(200).send({
            getUserBankDetail,
            ...userDetails,
            valid: true,
            name: `${userDetails.name}`
        });
    } catch (error) {
        console.error("Error validating user:", error);
        return res.status(500).send({ error: "Something went wrong" });
    }
}

module.exports = validateUser;
