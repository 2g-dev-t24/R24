*-----------------------------------------------------------------------------
$PACKAGE AbcBi
*-----------------------------------------------------------------------------
    SUBROUTINE V.FT.VALIDA.TC
*-----------------------------------------------------------------------
* Creado por  : 
* Fecha       : 
* Descripcion : Validacion de la tarjeta de credito
*------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING EB.Display
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    
*------ Main Processing Section

    GOSUB PROCESS

    RETURN
*-------
PROCESS:
*-------
    ETEXT=''
    MESSAGE = EB.SystemTables.getMessage()

    IF MESSAGE EQ 'VAL' OR EB.SystemTables.getComi() EQ '' THEN RETURN
    Y.TARJETA = EB.SystemTables.getComi()

    IF Y.TARJETA EQ '' OR (Y.TARJETA NE '' AND LEN(Y.TARJETA) NE 16) THEN
        ETEXT = 'LONGITUD DE TARJETA INVALIDA: ':LEN(Y.TARJETA)
    END ELSE
        IF NOT(ISDIGIT(Y.TARJETA)) THEN
            ETEXT = 'TARJETA INVALIDA'
        END
    END

    IF ETEXT NE '' THEN
        EB.SystemTables.setAf(FT.CREDIT.THEIR.REF)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END


    EB.Display.RebuildScreen()

    RETURN

END
