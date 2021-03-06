
TyrantTest := UnitTest clone do(
  setUp := method(
    Tyrant start debugOn
#    Tyrant start debugOff
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
    Tyrant put("key", "some.key")
    assertEquals("some.key", Tyrant getString("key"))
    assertTrue(Tyrant remove("key"))
    assertEquals(nil, Tyrant getString("key"))
    assertFalse(Tyrant remove("key"))
    assertFalse(Tyrant remove("invalid.key"))
    )
  testListKeys := method(
    Tyrant put("key.1","value.1")
    Tyrant put("key.2","value.2")
    Tyrant put("key.3","value.3")
    Tyrant put("key.4","value.4")
    assertEquals(list("key.1","key.2","key.3","key.4"), Tyrant listKeys)
    )
  testFetchKeys := method(
    Tyrant put("key.1","value.1")
    Tyrant put("key.2","value.2")
    Tyrant put("key.3","value.3")
    Tyrant put("key.4","value.4")
    results := Tyrant fetchKeys("key", 2)
    assertEquals(list("key.1","key.2"),results)
    results := Tyrant fetchKeys("key", 6)
    assertEquals(list("key.1","key.2","key.3","key.4"),results)
    results := Tyrant fetchKeys("no.key", 2)
    assertEquals(list(),results)


    )
  testSizeOf := method(
    Tyrant put("key", "value")
    assertEquals(5, Tyrant sizeOf("key"))
    assertEquals(0, Tyrant sizeOf("invalid.key"))
    )
  testRecordCount := method(
    Tyrant put("key.1","value.1")
    Tyrant put("key.2","value.2")
    Tyrant put("key.3","value.3")
    Tyrant put("key.4","value.4")
    assertEquals(4, Tyrant recordCount) 
    )
  testRecordCount20 := method(
    for(i, 1, 20, Tyrant put("key".. i, "value".. i))
    assertEquals(20, Tyrant recordCount)
  )
  testStats := method(
    Tyrant put("key.1","value.1")
    stats := Tyrant stats
    writeln(stats)
  )
)
