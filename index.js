import express from 'express'
import os from 'os'

const app = express()
const port = 3000

app.get('/', (req, res) => {
    res.json({
        msg: 'API 1.0.0',
        hora: new Date().toLocaleTimeString(),
        hostname: os.hostname()
    })
})

app.listen(port, () => console.log(`SERVER ONLINE - ${port}`))
