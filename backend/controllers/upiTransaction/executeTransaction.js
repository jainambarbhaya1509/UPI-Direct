const bcrypt = require('bcrypt');
const { pool } = require('../../config/dbConfig');
const getUserid = require("../../models/user/getUserid");
const CreditedMail = require('../../utils/Creditedmailer');
const DebitedMail = require('../../utils/Debitedmailer copy');

const executeTransaction = async (token, receiver_upi_id, amount, pin) => {
    try {
        if (!token || !receiver_upi_id || !amount || !pin) {
            console.log(token);
            
            throw new Error("Invalid input data.");
        }
        console.log(token);
                
        console.log(amount);
        console.log(pin);
        console.log(receiver_upi_id)
        const sender_vid = getUserid(token).id;
        console.log(sender_vid)

        const reciever_vid = (
            await pool.query(`SELECT vid FROM users WHERE upi_id=$1`, [receiver_upi_id])
        ).rows[0]?.vid;

        const { name: receiver_name, email: receiver_email, phone_number:receiver_phone } = (
            await pool.query(`SELECT vid, name, email,phone_number FROM aadhar_info WHERE vid=$1`, [reciever_vid])
        ).rows[0] || {}; // Ensure fallback in case rows[0] is undefined

        if (!reciever_vid) {
            throw new Error("Receiver not found.");
        }

        const sender = (
            await pool.query(`SELECT * FROM users WHERE vid = $1`, [sender_vid])
        ).rows[0];

        if (!sender) {
            throw new Error("Sender not found.");
        }

        const isPinValid = await bcrypt.compare(`${pin}`, sender.upi_pin);
        if (!isPinValid) {
            throw new Error("Invalid UPI PIN.");
        }

        if (sender.balance < amount) {
            throw new Error("Insufficient balance.");
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
                [amount, reciever_vid]
            );

            // Log the transaction
            await pool.query(
                `INSERT INTO transactions (sender_vid, receiver_vid, amount, transaction_status) 
                 VALUES ($1, $2, $3, $4)`,
                [sender_vid, reciever_vid, amount, Boolean(true)]
            );

            await pool.query('COMMIT');
            CreditedMail(receiver_email, receiver_name, receiver_upi_id, receiver_phone,amount)
            DebitedMail(receiver_email, receiver_name, receiver_upi_id, receiver_phone,amount)
            return {
                message: "Transaction successful.",
                transaction: {
                    sender_vid,
                    reciever_vid,
                    amount,
                },
            };
        } catch (err) {
            await pool.query('ROLLBACK');
            console.error("Transaction failed:", err);
            throw new Error("Transaction failed.");
        }
    } catch (error) {
        console.error("Error processing transaction:", error);
        throw error;
    }
};

module.exports = executeTransaction;
