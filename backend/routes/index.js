const express = require('express')
const indexRoute = express.Router()

// Internal Imports
const authRoute = require('./userAuth')
const validateUserMiddleware = require('../middleware/auth')
const transactonRouter = require('./transaction')

// Mount authRoute without middleware
indexRoute.use('/auth', authRoute)

// Mount middleware to apply to routes after 
// indexRoute.use(validateUserMiddleware)

// Mount routes that require authentication
indexRoute.use('/transaction',transactonRouter)

module.exports = indexRoute
