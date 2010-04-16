
Tyrant := Object clone do(
    socket := Socket clone

    cmdCharacter := 0xC8 asCharacter
    putCharacter := 0x10 asCharacter
    getCharacter := 0x30 asCharacter
    vanishCharacter := 0x72 asCharacter

    start := method(
            startWithHost("localhost")
            )
    startWithHost := method(host,
            startWithHostAndPort(host, 1978)
            )    

    startWithHostAndPort := method(host,port,
            socket setHost(host) setPort(port)
            writeln("client connecting to ", socket host, " on port ", socket port)
            socket connect
            if (socket isOpen, writeln("client connected"), writeln("connection failed"))
            self
            )

    stop := method(
            writeln("client disconnecting");
            socket close;
            self
            )
    put := method(key, value,
            if(socket isOpen == false, writeln("Must start first"); return) 
            writeln("put a new value ", key, " := ", value)
            socket write(cmdCharacter)  
            socket write(putCharacter)
            socket write(sizeInBytes(key size))
            socket write(sizeInBytes(value asString size))
            socket write(key)
            socket write(value)

            readStatus
            )
    get := method(key,
            writeln("get value for key ", key)
            socket write(cmdCharacter)  
            socket write(getCharacter)
            socket write(sizeInBytes(key size))
            socket write(key)

            readStatus
            valueLength := socket readBytes(4) asHex asNumber
            writeln("value length : ", valueLength)
            value := socket readBytes(valueLength) 
            )

    getString := method(key, get(key) asString)
    getNumber := method(key, getString(key) asNumber)

    clear := method(
            writeln("clear the database")
            socket write(cmdCharacter)
            socket write(vanishCharacter)

            readStatus
            )

    readStatus := method(
            status := socket readBytes(1)
            writeln("status : ", status asHex)
            status
            )

    sizeInBytes := method(aSize,
            sizeBytesLength := aSize toBaseWholeBytes(16) size /2
            sizeBytes := Sequence clone setSize(4 - sizeBytesLength)
            sizeBytes append(aSize)
            )
    )

