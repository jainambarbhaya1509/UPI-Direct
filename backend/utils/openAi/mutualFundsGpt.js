const axios = require('axios')
const { GoogleGenerativeAI } = require("@google/generative-ai");

const genAI = new GoogleGenerativeAI("AIzaSyCYKpOuJ49yeZy-RR5G1lxdow9Y3iSSp_s");  // Replace with your actual API key
const base_url=process.env.STOCK_APP_BASE_URL

async function mutualFundsGpt(userQuery) {
  try {
    const mutualFundAiText = await axios.post(`${base_url}/mutual_fund_ai`,{query:userQuery})
    console.log(mutualFundAiText.data);
    
    return mutualFundAiText.data
  } catch (error) {
    console.error("Error generating content:", error);
    return null
  }
}

module.exports = mutualFundsGpt;
