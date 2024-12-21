const bcrypt = require('bcrypt');
const { pool } = require('../../config/dbConfig');
const getUserid = require("../../models/user/getUserid");
const CreditedMail = require('../../utils/Creditedmailer');
const DebitedMail = require('../../utils/Debitedmailer copy');

const payWithPhone = async (req, res) => {
    try {
        const { token, receiver_phone, amount, pin } = req.body;

        // Validate inputs
        if (!token || !receiver_phone || !amount || !pin) {
            return res.status(400).send({ message: "Invalid input data." });
        }s

        // Get sender ID from token
        const { id: sender_vid } = getUserid(token);

        // Fetch receiver details using phone number
        const receiver = (
            await pool.query(`SELECT * FROM aadhar_info WHERE phone_number = $1`, [receiver_phone])
        ).rows[0];

        if (!receiver) {
            return res.status(404).send({ message: "Receiver not found." });
        }

        // Fetch sender details
        const sender = (
            await pool.query(`SELECT * FROM users WHERE vid = $1`, [sender_vid])
        ).rows[0];

        if (!sender) {
            return res.status(404).send({ message: "Sender not found." });
        }

        // Validate UPI PIN
        const isPinValid = await bcrypt.compare(`${pin}`, sender.upi_pin);
        if (!isPinValid) {
            return res.status(403).send({ message: "Invalid UPI PIN." });
        }

        // Check sender's balance
        if (sender.balance < amount) {
            return res.status(400).send({ message: "Insufficient balance." });
        }

        // Begin the transaction
        try {
            await pool.query('BEGIN');

            // Deduct amount from sender
            await pool.query(
                `UPDATE bank_accounts SET balance = balance - $1 WHERE vid = $2`,
                [amount, sender_vid]
            );

            // Add amount to receiver
            await pool.query(
                `UPDATE bank_accounts SET balance = balance + $1 WHERE vid = $2`,
                [amount, receiver.vid]
            );

            // Log the transaction
            await pool.query(
                `INSERT INTO transactions (sender_vid, receiver_vid, amount, transaction_status) 
                 VALUES ($1, $2, $3, $4)`,
                [sender_vid, receiver.vid, amount, true]
            );

            await pool.query('COMMIT');

            // Respond with success
            CreditedMail(receiver_email, receiver_name, receiver_upi_id, receiver_phone)
            DebitedMail(receiver_email, receiver_name, receiver_upi_id, receiver_phone)
            
            return res.status(200).send({
                message: "Transaction successful.",
                transaction: {
                    sender_vid,
                    receiver_vid: receiver.vid,
                    amount,
                },
            });
        } catch (err) {
            await pool.query('ROLLBACK');
            console.error("Transaction failed:", err);
            return res.status(500).send({ message: "Transaction failed." });
        }
    } catch (error) {
        console.error("Error processing transaction:", error);
        return res.status(500).send({ message: "Internal server error." });
    }
};

module.exports = payWithPhone;
