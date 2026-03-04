*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
    SUBROUTINE ABC.TPV.AJUSTE.CIERRE
*----------------------------------------------------------------
*----------------------------------------------------------------

    $USING EB.LocalReferences
    $USING EB.SystemTables

    EB.LocalReferences.GetLocRef('AC.LOCKED.EVENTS',"AJUSTE.CIERRE",YPOS)
    
    Y.LOCAL.REF = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckLocalRef)
    Y.LOCAL.REF<1,YPOS> = TIMEDATE()
    EB.SystemTables.setRNew(AC.AccountOpening.LockedEvents.LckLocalRef, Y.LOCAL.REF)

    RETURN


END
