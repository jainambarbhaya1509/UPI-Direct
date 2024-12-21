const createUser = require('../controllers/auth/createUser')
const setPin = require('../controllers/auth/setPin')
const validateUser = require('../controllers/auth/validateUser')

const Router=require('express').Router
const authRoute=Router()

authRoute.post('/createUser',createUser)
authRoute.post('/setPin',setPin)
authRoute.post('/validateUser',validateUser)

module.exports=authRoute