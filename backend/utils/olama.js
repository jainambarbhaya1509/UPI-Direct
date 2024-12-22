const ollama = require('ollama').default;

const chatWithOllama=async(userQuery)=> {
    try {
        const response = await ollama.chat({
            model: 'llama3.2',
            messages: [{ role: 'user', content: `${userQuery} in 20 words strict` }],
        });

        console.log(response.message.content);
    } catch (error) {
        console.error('Error during Ollama chat:', error);
    }
}

module.exports=chatWithOllama;
