
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
            debugWriteln("client connecting to ", socket host, " on port ", socket port)
            socket connect
            if (socket isOpen, writeln("client connected"), writeln("connection failed"))
            self
            )

    stop := method(
            debugWriteln("client disconnecting");
            socket close;
            self
            )
    put := method(key, value,
            _genericPut(key,value,0x10 asCharacter)
            )
    putKeep := method(key, value,
            _genericPut(key,value,0x11 asCharacter)
            )

    append := method(key, value,
            _genericPut(key,value,0x12 asCharacter)
            )
    remove := method(key,
            debugWriteln("out value for key ", key)
            _writeKey(key,0x20 asCharacter) == 0
            )
    sizeOf := method(key,
            debugWriteln("size Off ", key)
            if(_writeKey(key, 0x38 asCharacter) == 1, return 0)
            valueLength := socket readBytes(4) asHex fromBase(16)
            )
           
    get := method(key,
            debugWriteln("get value for key ", key)
            if(_writeKey(key,0x30 asCharacter) == 1, return nil)

            valueLength := socket readBytes(4) asHex fromBase(16)
            debugWriteln("value length : ", valueLength)
            value := socket readBytes(valueLength) 
            )

    getString := method(key, 
           value := get(key)
           if(value != nil, value asString, nil)
           )
    getNumber := method(key, getString(key) asNumber)

    clear := method(
            debugWriteln("clear the database")
            _writeCmd(0x72 asCharacter)

            _readStatus
            )

    fetchKeys := method(prefix, max,
           _writeCmd(0x58 asCharacter)
           socket write(_sizeInBytes(prefix size))
           socket write(_sizeInBytes(max))
           socket write(prefix)
           _readStatus  
           numOfKeys := socket readBytes(4) asHex fromBase(16)
           l := List clone
           for(i,0, numOfKeys-1, 
                   valueLength := socket readBytes(4) asHex fromBase(16)
                   value := socket readBytes(valueLength) 
                   l append(value)
              )
           l
           )
    listKeys := method(
           _writeCmd(0x50 asCharacter)
           if(_readStatus != 0, return nil)
           aList := List clone

           _writeCmd(0x51 asCharacter) 
           while(_readStatus == 0,

                   _writeCmd(0x51 asCharacter) 
                   valueLength := socket readBytes(4) asHex fromBase(16)
                   value := socket readBytes(valueLength) 
                   aList append(value)

                )
           aList
           )
    recordCount := method(
            _writeCmd(0x80 asCharacter)
            _readStatus
            hex := socket readBytes(8) asHex
            hex fromBase(16)

            )

    sync := method(
            _writeCmd(0x70 asCharacter)
            _readStatus
            )
    stats := method(
           _writeCmd(0x88 asCharacter)
           _readStatus
           valueLength := socket readBytes(4) asHex fromBase(16)
           value := socket readBytes(valueLength) asJson
           )
    _writeKey := method(key,getCmd,
            _writeCmd(getCmd)
            socket write(_sizeInBytes(key size))
            socket write(key)
            _readStatus
            )
    _readStatus := method(
            status := socket readBytes(1) asHex fromBase(16)
            debugWriteln("status : ", status)
            status
            )

    _sizeInBytes := method(aSize,
            sizeBytesLength := aSize toBaseWholeBytes(16) size /2
            sizeBytes := Sequence clone setSize(4 - sizeBytesLength)
            sizeBytes append(aSize)
            )
    
    _genericPut := method(key, value, putCharacter,
            if(socket isOpen == false, debugWriteln("Must start first"); return) 
            debugWriteln("put a new value ", key, " := ", value)
            _writeCmd(putCharacter)
            socket write(_sizeInBytes(key size))
            socket write(_sizeInBytes(value asString size))
            socket write(key)
            socket write(value)
            _readStatus
            )
    _writeCmd := method(cmdCharacter,
            socket write(0xC8 asCharacter)  
            socket write(cmdCharacter)
            )
           
    )

