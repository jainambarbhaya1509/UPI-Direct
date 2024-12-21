const { GoogleGenerativeAI } = require("@google/generative-ai");

const genAI = new GoogleGenerativeAI("AIzaSyCYKpOuJ49yeZy-RR5G1lxdow9Y3iSSp_s");

async function getPortfolioAdvice(data) {
  try {
    const model = await genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
    const result = await model.generateContent(`How can I improve my finance here is the data ${JSON.stringify(data)} and currency unit is rupees (INR), also state the reason of your advice`);
    
    // Access and clean the response text
    if (result?.response?.candidates && result.response.candidates.length > 0) {
      let responseText = result.response.candidates[0].content.parts[0].text;
      
      // Use regex to remove asterisks
      responseText = responseText.replace(/\*/g, "");
      
      return responseText;
    } else {
      throw new Error("No response candidates found.");
    }
  } catch (error) {
    console.error("Error generating content:", error);
    throw error;  // Re-throw error to handle it in the calling code
  }
}

module.exports = { getPortfolioAdvice };
