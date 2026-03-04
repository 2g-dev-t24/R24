*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
    SUBROUTINE BA.TT.VAL.SUC.VER
****************************************************+
* Tranascion a Autorizar sea de la sucursal

********************************************************


    $USING EB.Security
    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing

    FN.TT = 'F.TELLER$NAU'
    F.TT = ''
    EB.DataAccess.Opf(FN.TT,F.TT)
    R.USER = EB.SystemTables.getRUser()
    DEP.USR = R.USER<EB.Security.User.UseDepartmentCode>
    SUC.USR = DEP.USR[1,5]

    READ REC.TT FROM F.TT, EB.SystemTables.getComi() THEN
        DEPT.CODE = REC.TT<TT.Contract.Teller.TeDeptCode>
        IF DEPT.CODE[1,5] NE SUC.USR THEN
            E = "La transacion no es de la Sucursal - ERROR 01(BA.TT.VAL.SUC.VER)"
            EB.SystemTables.setE(E)
            V$ERROR = 1
            EB.ErrorProcessing.Err()
        END
    END

    RETURN
END

