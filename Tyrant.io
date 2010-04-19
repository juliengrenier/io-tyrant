
Tyrant := Object clone do(

    socket := Socket clone

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
            genericPut(key,value,0x10 asCharacter)
            )
    putKeep := method(key, value,
            genericPut(key,value,0x11 asCharacter)
            )

    append := method(key, value,
            genericPut(key,value,0x12 asCharacter)
            )
    remove := method(key,
            writeln("out value for key ", key)
            genericGet(key,0x20 asCharacter) == 0
            )
    genericGet := method(key,getCmd,
            writeCmd(getCmd)
            socket write(sizeInBytes(key size))
            socket write(key)
            readStatus
            )
    sizeOf := method(key,
            writeln("size Off ", key)
            if(genericGet(key, 0x38 asCharacter) == 1, return 0)
            valueLength := socket readBytes(4) asHex asNumber
            )
           
    get := method(key,
            writeln("get value for key ", key)
            if(genericGet(key,0x30 asCharacter) == 1, return nil)

            valueLength := socket readBytes(4) asHex asNumber
            writeln("value length : ", valueLength)
            value := socket readBytes(valueLength) 
            )

    getString := method(key, 
           value := get(key)
           if(value != nil, value asString, nil)
           )
    getNumber := method(key, getString(key) asNumber)

    clear := method(
            writeln("clear the database")
            writeCmd(0x72 asCharacter)

            readStatus
            )

    readStatus := method(
            status := socket readBytes(1) asHex asNumber
            writeln("status : ", status)
            status
            )

    sizeInBytes := method(aSize,
            sizeBytesLength := aSize toBaseWholeBytes(16) size /2
            sizeBytes := Sequence clone setSize(4 - sizeBytesLength)
            sizeBytes append(aSize)
            )
    
    genericPut := method(key, value, putCharacter,
            if(socket isOpen == false, writeln("Must start first"); return) 
            writeln("put a new value ", key, " := ", value)
            writeCmd(putCharacter)
            socket write(sizeInBytes(key size))
            socket write(sizeInBytes(value asString size))
            socket write(key)
            socket write(value)
            readStatus
            )
    writeCmd := method(cmdCharacter,
            socket write(0xC8 asCharacter)  
            socket write(cmdCharacter)
            )
           
    )

