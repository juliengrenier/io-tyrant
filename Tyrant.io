
Tyrant := Object clone do(
    socket := Socket clone setHost("192.168.1.102") setPort(1978)
    start := method(
            writeln("client connecting to ", socket host, " on port ", socket port)
            socket connect
            if (socket isOpen, writeln("client connected"), writeln("connection failed"))
            self
            )
    stop := method(
            writeln("client disconnecting");
            socket close;
            )
    put := method(key, value,
            if(socket isOpen == false, writeln("Must start first"); return) 
            writeln("put a new value ", key, " := ", value)
            socket write(0xc8 asCharacter)  
            socket write(0x10 asCharacter)
            socket write(sizeInBytes(key size))
            socket write(sizeInBytes(value asString size))
            socket write(key)
            socket write(value)

            status := socket readBytes(1)
            writeln("status ", status asHex)
            status
            )
    get := method(key,
            writeln("get value for key ", key)
            socket write(0xc8 asCharacter)
            socket write(0x30 asCharacter)
            socket write(sizeInBytes(key size))
            socket write(key)

            status := socket readBytes(1)
            writeln("status ", status asHex)

            valueLength := socket readBytes(4) asHex asNumber
            writeln("value length : ", valueLength)
            value := socket readBytes(valueLength) 
            )
    getString := method(key, get(key) asString)
    getNumber := method(key, getString(key) asNumber)

    sizeInBytes := method(aSize,
            sizeBytesLength := aSize toBaseWholeBytes(16) size /2
            sizeBytes := Sequence clone setSize(4 - sizeBytesLength)
            sizeBytes append(aSize)
            )
    )

