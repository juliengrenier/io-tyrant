
TyrantTest := UnitTest clone do(
  setUp := method(
    Tyrant start
    )
  tearDown := method(
    Tyrant clear
    Tyrant stop
    )
  testPut := method(
    Tyrant put("key","value")
    assertEquals("value",Tyrant getString("key"))
    )
  testClear := method(
    Tyrant put("key.clear","value")
    Tyrant clear
    #assertEquals(nil, Tyrant getString("key.clear"))
    )
  testPutKeep := method(
    Tyrant put("key","value.1")
    Tyrant putKeep("key", "unexepted")
    assertEquals("value.1",Tyrant getString("key"))
    )
  testGetNumber := method(
    Tyrant put("key", 123)
    assertEquals(123, Tyrant getNumber("key"))
    )
)
