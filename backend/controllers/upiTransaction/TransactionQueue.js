const executeTransaction = require("./executeTransaction");

const transactionQueue = async (req, res) => {
    try {
        const { queue, token } = req.body;

        queue.forEach(transaction => {
            executeTransaction(token, transaction.receiver_upi_id, transaction.amount, transaction.pin);
        });

        res.send("Succesful")
    } catch (error) {
        res.status(500).send("Transaction Queue failed ");
    }
}
module.exports=transactionQueue;