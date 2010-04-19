
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
  testPutTwice := method(
    Tyrant put("key","value")
    Tyrant put("key","value.new")
    assertEquals("value.new",Tyrant getString("key"))
    )
  testClear := method(
    Tyrant put("key.clear","value")
    Tyrant clear
    assertEquals(nil, Tyrant getString("key.clear"))
    )
  testPutKeep := method(
    Tyrant put("key","value.1")
    Tyrant putKeep("key", "unexepted")
    assertEquals("value.1",Tyrant getString("key"))
    )
  testAppend := method(
    Tyrant put("key","value.1")
    Tyrant append("key", "value.2")
    assertEquals("value.1value.2",Tyrant getString("key"))
    )
  testGetNumber := method(
    Tyrant put("key", 123)
    assertEquals(123, Tyrant getNumber("key"))
    )
  testRemove := method(
    Tyrant put("key", 123)
    assertTrue(Tyrant remove("key"))
    assertFalse(Tyrant remove("key"))
    assertFalse(Tyrant remove("invalid.key"))
    )
  testSizeOf := method(
    Tyrant put("key", "value")
    assertEquals(5, Tyrant sizeOf("key"))
    assertEquals(0, Tyrant sizeOf("invalid.key"))
    )
)
