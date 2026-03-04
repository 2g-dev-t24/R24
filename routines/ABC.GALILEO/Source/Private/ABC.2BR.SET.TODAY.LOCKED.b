*-----------------------------------------------------------------------------
* <Rating>100</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
SUBROUTINE ABC.2BR.SET.TODAY.LOCKED
$USING EB.SystemTables

TODAY = EB.SystemTables.getToday()
IF EB.SystemTables.getVFunction() EQ 'R' THEN RETURN

EB.SystemTables.setAf(TODAY) 
RETURN
END
