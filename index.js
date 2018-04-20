// index.js

var server = require('auth-static')

server({
    options: {
        cache: 3600,
        gzip: true
    },
    username: process.env.AUTH_USERNAME,
    password: process.env.AUTH_PASSWORD,
    port: process.env.PORT || 8888,
    realm: 'Private',
    root: './v1/html'
})
