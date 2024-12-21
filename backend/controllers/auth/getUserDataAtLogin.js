const jwt = require('jsonwebtoken');
const { pool } = require('../../config/dbConfig');
const { comparePassword } = require('../../utils/helper');
const getUserid = require('../../models/user/getUserid');
const getUserAdharDetails = require('../../models/user/getUserAdharDetails');
const getUserBankDetails = require('../../models/user/getUserBankDetails');


const getUserDataAtLogin = async (req, res) => {
    try {
        //accountNumber->stores Token
        const { token} = req.params;
        
        const { id } = getUserid(token);
        const userDetails = await getUserAdharDetails(id);
        const getUserBankDetail = await getUserBankDetails(id);

        return res.status(200).send({
            getUserBankDetail,
            ...userDetails,
            name: `${userDetails.name}`
        });
    } catch (error) {
        console.error("Error validating user:", error);
        return res.status(500).send({ error: "Something went wrong" });
    }
}

module.exports = getUserDataAtLogin;
