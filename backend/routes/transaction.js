const payWithPhone = require('../controllers/upiTransaction/payWithPhone');
const processTransaction = require('../controllers/upiTransaction/processTransaction');
const transactionQueue = require('../controllers/upiTransaction/TransactionQueue');
const fetchTransactionHistory = require('../controllers/upiTransaction/transactionStatemet');

const Router = require('express').Router;
const transactonRouter = Router();

transactonRouter.post('/executeTransaction', processTransaction);
transactonRouter.post('/payWithPhone', payWithPhone);
transactonRouter.post('/transactionQueue', transactionQueue);
transactonRouter.get('/transactionStatement/:token', fetchTransactionHistory);

module.exports = transactonRouter;