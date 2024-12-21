const createUser = require('../controllers/auth/createUser')
const setPin = require('../controllers/auth/setPin')
const getUserDataAtLogin = require('../controllers/auth/getUserDataAtLogin')

const Router=require('express').Router
const authRoute=Router()

authRoute.post('/createUser',createUser)
authRoute.post('/setPin',setPin)
authRoute.get('/getUserDataAtLogin/:token',getUserDataAtLogin)

module.exports=authRoute