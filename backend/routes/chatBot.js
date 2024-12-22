const chatPrompt = require('../controllers/chatBot/chat');
const TransactionPrompt = require('../controllers/chatBot/transaction');

const Router = require('express').Router;
const chatBotRouter = Router();

chatBotRouter.post('/transaction',TransactionPrompt);
chatBotRouter.get('/chatPrompt',chatPrompt);

module.exports=chatBotRouter
