server = require('http').createServer(handler)
io = require('socket.io')(server)
fs= require('fs')
__dirname=''
server.listen 8000, -> 
    console.log 'listening'

handler = (req,res) ->
    fs.readFile __dirname + '../index.html', (err,data)->
        if err
            console.log 'error'
            res.writeHead 500
            res.end 'error loading index.html'
        else
            console.log 'success'
            res.writeHead 200
            res.end data

io.on 'connection', (socket) ->
    ### this is just for testing it needs to be compiled with actual state of each pin  this could be done via a local database###
    fs.readFile __dirname + '../js/deviceInfo.js' , (err,data)->
        if err 
            console.log 'error getting device info'
            socket.emit 'error', {errorCode : '500' , errorMessage:'Failed to open Device info'}
        else 
            console.log 'sent device info'
            ### one  option is that since we have the device info we could make a looping request to the ddevice to get its current status ###
            socket.emit 'init', data
        
        socket.on 'updateComponent', (data)->
            ### here is where you pu in all the magic to update the network device###