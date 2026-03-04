*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.E.SEL.DEP(ENQ.PARAM)


    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Security

    FN.USER      = 'F.USER'
    F.USER       = ''
    EB.DataAccess.Opf(FN.USER, F.USER)

    R.USER = EB.SystemTables.getRUser()

    Y.DEPT = R.USER<EB.Security.User.UseDepartmentCode>
    *Y.DEPT = Y.DEPT[1,9]
    IF LEN(Y.DEPT) EQ 12 THEN
        Y.DEPT = Y.DEPT : '0'
    END ELSE
        IF LEN(Y.DEPT) EQ 15 THEN
            Y.DEPT = Y.DEPT[1,13]
        END
    END

    ENQ.PARAM<2,1> = 'DEPT.ACCT.OFF.CODE'
    ENQ.PARAM<3,1> = 'LK'
    ENQ.PARAM<4,1,1> = Y.DEPT:'...'
    
    RETURN
END
