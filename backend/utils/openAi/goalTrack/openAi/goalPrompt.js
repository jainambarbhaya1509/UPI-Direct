const { GoogleGenerativeAI } = require("@google/generative-ai");

const genAI = new GoogleGenerativeAI("AIzaSyCYKpOuJ49yeZy-RR5G1lxdow9Y3iSSp_s");

async function GoalTrack(userInput) {
  try {
    const model = await genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
    
    // Define the prompt with a training example
    const prompt = `
I want you to respond in a structured JSON format without any additional text or markdown. For example:
- User: "I want to buy a new car costing 30000 in 1 year"
- Assistant: {"goal_name": "buy new car", "goal_amount": 30000, "time_frame": 365}

Now, based on the following input, provide a similar structured response:
"${userInput}"
`;

    const result = await model.generateContent(prompt);
    
    if (result?.response?.candidates && result.response.candidates.length > 0) {
      const assistantResponse = result.response.candidates[0].content.parts[0].text;

      // Attempt to parse the assistant's response as JSON
      let structuredResponse;
      try {
        structuredResponse = JSON.parse(assistantResponse);
      } catch (error) {
        throw new Error("Failed to parse response as JSON.");
      }

      return {
        role: "assistant",
        content: structuredResponse
      };
    } else {
      throw new Error("No response candidates found.");
    }
  } catch (error) {
    console.error("Error generating content:", error);
    throw error;  // Re-throw error for handling in calling code
  }
}

module.exports = GoalTrack 
