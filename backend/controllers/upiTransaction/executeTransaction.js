const bcrypt = require('bcrypt');
const { pool } = require('../../config/dbConfig');
const getUserid = require("../../models/user/getUserid");

const executeTransaction = async (req, res) => {
    try {
        const { token, receiver_upi_id, amount, pin } = req.body;

        if (!token || !receiver_upi_id || !amount || !pin) {
            return res.status(400).send({ message: "Invalid input data." });
        }

        const { id: sender_vid } = getUserid(token);
        
        const reciever_vid = (
            await pool.query(`SELECT vid FROM users WHERE upi_id=$1`, [receiver_upi_id])
        ).rows[0]?.vid;
        
        const sender = (
            await pool.query(`SELECT * FROM users WHERE vid = $1`, [sender_vid])
        ).rows[0];

        const receiver = (
            await pool.query(`SELECT * FROM users WHERE upi_id = $1`, [receiver_upi_id])
        ).rows[0];

        if (!sender) {
            return res.status(404).send({ message: "Sender not found." });
        }

        if (!receiver) {
            return res.status(404).send({ message: "Receiver not found." });
        }

        const isPinValid = await bcrypt.compare(`${pin}`, sender.upi_pin);
        if (!isPinValid) {
            return res.status(403).send({ message: "Invalid UPI PIN." });
        }

        if (sender.balance < amount) {
            return res.status(400).send({ message: "Insufficient balance." });
        }

        try {

            await pool.query(
                `UPDATE  bank_accounts SET balance = balance - $1 WHERE vid = $2`,
                [amount, sender_vid]
            );

            await pool.query(
                `UPDATE bank_accounts SET balance = balance + $1 WHERE vid = $2`,
                [amount, reciever_vid]
            );

            // Log the transaction
            await pool.query(
                `INSERT INTO transactions (sender_vid, receiver_vid, amount, transaction_status) 
                 VALUES ($1, $2, $3, $4)`,
                [sender_vid, receiver_upi_id, amount, Boolean(true)]
            );

            res.status(200).send({
                message: "Transaction successful.",
                transaction: {
                    sender_vid,
                    reciever_vid,
                    amount,
                },
            });
        } catch (err) {
            pool.query('ROLLBACK');
            console.error("Transaction failed:", err);
            res.status(500).send({ message: "Transaction failed." });
        }
    } catch (error) {
        console.error("Error processing transaction:", error);
        res.status(500).send({ message: "Internal server error." });
    }
};

module.exports = executeTransaction;
