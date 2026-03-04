$PACKAGE AbcTable

SUBROUTINE ABC.IDE.SALDOS.CLIE.ID
*-----------------------------------------------------------------------------
* Validación de ID para ABC.IDE.SALDOS.CLIE
* Formato: CLIENTE.YYYYMM
* Descripción: Valida que el ID tenga formato correcto y que el cliente exista
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.DataAccess

*-----------------------------------------------------------------------------
    GOSUB PROCESS

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    
    ID.NEW = EB.SystemTables.getIdNew()
    V.ERROR = ''
    E = ''

* VALIDAR ID - Debe tener formato CLIENTE.YYYYMM
    X.TOT = DCOUNT(ID.NEW, '.')
    IF NOT(X.TOT EQ 2) THEN
        E = "ID NO VALIDO - FORMATO CORRECTO: CLIENTE.YYYYMM"
    END

* VALIDAR CLIENTE - Debe existir en CUSTOMER
    X.CLI = FIELD(ID.NEW, '.', 1)
    EB.DataAccess.CacheRead('F.CUSTOMER', X.CLI, REC.CLI, YERR)
    IF NOT(REC.CLI) THEN
        E = "CLIENTE NO EXISTENTE"
    END

* VALIDAR FECHA - Debe ser YYYYMM válido
    X.FEC = FIELD(ID.NEW, '.', 2)
    IF NOT(LEN(X.FEC) EQ 6) THEN
        E = "LONGITUD DE FECHA NO VALIDA (yyyymm)"
    END
    
* VALIDACION DE AÑO
    IF NOT(X.FEC[1,4] GT 2006 AND X.FEC[1,4] LT 2099) THEN
        E = "FECHA NO VALIDA (yyyymm)"
    END
    
* VALIDACION DE MES
    IF NOT(X.FEC[5,2] GE 1 AND X.FEC[5,2] LE 12) THEN
        E = "FECHA NO VALIDA (yyyymm)"
    END

* SI HAY ERROR, MOSTRARLO
    IF E THEN
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.Err()
    END

RETURN

END

