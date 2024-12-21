const executeTransaction = require('../controllers/upiTransaction/executeTransaction');

const Router = require('express').Router;
const transactonRouter = Router();

transactonRouter.post('/executeTransaction', executeTransaction);

module.exports = transactonRouter;