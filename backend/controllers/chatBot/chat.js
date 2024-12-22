const chatWithOllama = require('../../utils/olama');

const chatPrompt = async (req, res) => {
    try {
        const { userInput } = req.params;
        const responseAdvice = await chatWithOllama(userInput, "");
        return res.send(responseAdvice);
    } catch (error) {
        console.log(error);
        return res.status(500).send("Something went wrong");
    }
};

module.exports = chatPrompt;
