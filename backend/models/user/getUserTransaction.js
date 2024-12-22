const { pool } = require('../../config/dbConfig');
const getUserid = require("../../models/user/getUserid");

const fetchTransactionHistory = async (token) => {
    try {
        if (!token) {
            return res.status(400).send({ message: "Token is required." });
        }

        // Get user vid from the token
        const { id: user_vid } = getUserid(token);

        // Query to fetch the transaction history where the user is either the sender or receiver
        const result = await pool.query(
            `SELECT 
                t.id,
                t.sender_vid,
                t.receiver_vid,
                t.amount,
                t.transaction_status,
                t.created_at,
                u1.upi_id AS sender_upi_id,
                u2.upi_id AS receiver_upi_id
             FROM transactions t
             LEFT JOIN users u1 ON t.sender_vid = u1.vid
             LEFT JOIN users u2 ON t.receiver_vid = u2.vid
             WHERE t.sender_vid = $1 OR t.receiver_vid = $1
             ORDER BY t.created_at DESC`,
            [user_vid]
        );

        if (result.rows.length === 0) {
            return ({ message: "No transactions found." });
        }

        return({
            message: "Transaction statements retrieved successfully.",
            transactions: result.rows,
        });

    } catch (error) {
        console.error("Error fetching transaction statements:", error);
        return({ message: "Could not fetch transaction statements." });
    }
};

module.exports = fetchTransactionHistory;
