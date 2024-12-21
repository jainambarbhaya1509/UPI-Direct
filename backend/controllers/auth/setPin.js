const bcrypt = require('bcrypt');
const getUserid = require("../../models/user/getUserid");
const { hashPassword } = require('../../utils/helper');
const { pool } = require('../../config/dbConfig');
const getUserAdharDetails = require('../../models/user/getUserAdharDetails');
const getUserBankDetails = require('../../models/user/getUserBankDetails');

const setPin = async (req, res) => {
    try {
        const { token, pin } = req.body;

        // Get the user ID from the token
        const { id } = getUserid(token);

        // Fetch the user's Aadhaar details
        const userData = await getUserAdharDetails(id);

        if (!userData) {
            return res.status(404).send({ message: "User Aadhaar details not found." });
        }
        
        const findUser = await pool.query("SELECT vid FROM users WHERE vid=$1", [id]);

        if (findUser.rows.length != 0) {
            return res.status(200).send({ valid: false, error: "User ALready exist" });
        }

        // Hash the PIN securely
        const hashPin = await hashPassword(pin);

        // Insert user into the database
        const result = await pool.query(
            `INSERT INTO users (vid, upi_id, upi_pin) 
             VALUES ($1, $2, $3) 
             RETURNING *`,
            [
                id,
                `${userData.name}@upi`.toLowerCase(),
                hashPin
            ]
        );

        // Return success response
        const userBankDetails = getUserBankDetails(id)
        res.status(201).send({
            message: "UPI PIN set successfully.",
            user: result.rows[0],
            bank: userBankDetails
        });
    } catch (error) {
        console.error("Error while creating user:", error);
        res.status(500).send({ message: "Internal server error." });
    }
};

module.exports = setPin;
