const executeTransaction = require('./executeTransaction');

const processTransaction = async (req, res) => {
    try {
        const { token, receiver_upi_id, amount, pin } = req.body;
        const result = await executeTransaction(token, receiver_upi_id, amount, pin);
        res.status(200).send(result);
    } catch (error) {
        res.status(400).send({ message: error.message });
    }
};
module.exports=processTransaction