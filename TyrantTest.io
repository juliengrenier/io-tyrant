
TyrantTest := Object clone do(
                writeln("validation test")
                Tyrant start
                Tyrant put("key","value")
                actualValue := Tyrant getString("key")
                writeln(actualValue)
                Tyrant put("key2", 123)
                writeln(Tyrant getNumber("key2"))
                Tyrant clear
                Tyrant stop
                writeln("Everyting is fine")
                )
