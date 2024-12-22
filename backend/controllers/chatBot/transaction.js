const getFinancialAdvice = require("../../utils/openAi/chatbot/chatBot")
const getTransactionData = require('../../models/user/getUserTransaction')
const getUserid = require("../../models/user/getUserid")
const chatWithOllama = require("../../utils/olama")

const TransactionPrompt = async (req, res) => {
    try {
        const { userInput,token } = req.body

        const decodeData = getUserid(token)
        const data = await getTransactionData(decodeData.id)
        
        const botResponse = await chatWithOllama(userInput, `Here is the data of my transaction data: ${JSON.stringify(data)}`)
        res.send(botResponse)
    } catch (error) {
        console.error('Error:', error)
        res.status(500).send({ error: error.message })
    }
}

module.exports = TransactionPrompt
