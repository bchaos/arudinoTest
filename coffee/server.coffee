app =require('express')();
server = require('http').createServer(app)
io = require('socket.io')(server)
fs= require('fs')
__dirname=''
server.listen 8000, -> 
    console.log 'listening'

app.get '/', (req, res)->
    console.log 'recieved request'
    fs.readFile __dirname + '../index.html', (err,data)->
        if err
            console.log 'error'
            res.writeHead 500
            res.end 'error loading index.html'
        else
            console.log 'success'
            res.writeHead 200
            res.end data
            
rollDice = -> 
    return Math.floor( Math.random() * ( 0 + 200 - 1 ) ) + 1;
            
generateChartData = ->
     barChartData = [
        {label: 'total1', value: rollDice()},
        {label: 'total2', value: rollDice()},
        {label: 'total3', value: rollDice()},
        {label: 'total4', value: rollDice()},
        {label: 'total5', value: rollDice()}
      ]
io.on 'connection', (socket) ->
    ### this is just for testing it needs to be compiled with actual state of each pin  this could be done via a local database###
    socket.emit 'init', generateChartData()
    console.log 'connected'
    int= setInterval ->
            socket.emit 'update', generateChartData()
            console.log 'update Sent'
        ,10000;
    socket.on 'updateComponent', (data)->
    socket.on 'disconnect', ->
        clearInterval int
        ### here is where you pu in all the magic to update the network device###