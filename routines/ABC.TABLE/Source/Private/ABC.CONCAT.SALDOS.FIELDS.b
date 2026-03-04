* @ValidationCode : MjotMTQyMzExNTM6Q3AxMjUyOjE3NTk3Nzk2NDgxNDk6THVpcyBDYXByYTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Oct 2025 16:40:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

$PACKAGE AbcTable

SUBROUTINE ABC.CONCAT.SALDOS.FIELDS
*-----------------------------------------------------------------------------
* Nombre de Programa:   ABC.CONCAT.SALDOS.FIELDS
* Objetivo:             Tabla concat para almacenar datos de
*                       cliente y el resultado de su saldo precompensado
* Desarrollador:        Luis Cruz - FYG Solutions
* Compania:             ABC CAPITAL
* Fecha Creacion:       04-05-2022
* Modificaciones:
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------


    fieldName = 'RESULT'
    fieldLength = '20'
    fieldType = 'A'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    
    fieldName = 'FECHA'
    fieldLength = '20'
    fieldType = 'D'
    neighbour = ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)
    
RETURN

END
