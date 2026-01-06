Feature: API Validaciones TID y Merchant ID
  Como Aseguradora
  Quiero capturar TID (Terminal ID) y Merchant ID (MID) en las solicitudes del API
  Para auditar, aplicar reglas por cadena, mejorar trazabilidad y cumplir con regulaciones Federales

  Background:
    Given el sistema API está disponible
    And la tabla DB-MCS-Report-Transaccional-Items-Tbl es accesible

  @positive @api_v2
  Scenario Outline: Captura exitosa de TID y MID en API V2 con diferentes longitudes
    Given el API está configurado en versión V2
    And el header de versión está presente en la solicitud
    When se envía una solicitud con tid="<tid_value>" and mid="<mid_value>"
    Then el API procesa la validación exitosamente debe responder con status 200
    And los campos TID y MID quedan disponibles en logs
    And los campos TID y MID quedan disponibles en registro de auditoría
    And los datos se almacenan en DB-MCS-Report-Transaccional-Items-Tbl
    And se pueden consultar

    Examples:
      | tid_value        | mid_value                 |
      | POS123456789     | 4549123456789             |
      | 1234567890123456 | 1234567890123456789012345 |
      | A                | B                         |

  @positive @api_v1
  Scenario: Procesamiento en API V1 con datos de B24/Datalake
    Given el merchant está usando API V1
    And no se envía header de versión en la solicitud
    When el API recibe la solicitud
    Then se infiere que es versión 1
    And se guardan en la transacción los datos MID y TID que llegan de B24/Datalake
    And la validación se procesa como está en PROD actualmente

  @positive @api_v2
  Scenario Outline: Validación de longitud de campos en API V2
    Given el API está configurado en versión V2
    And el header de versión está presente en la solicitud
    When se envía una solicitud con <campo> que excede <longitud_maxima> caracteres
    Then el API responde con Error 400
    And el mensaje indica error de validación de longitud para <campo>

    Examples:
      | campo | longitud_maxima |
      | tid   | 16              |
      | mid   | 25              |

  @negative @api_v2
  Scenario: Procesamiento en API V2 con datos de API V1
    Given el merchant está usando API V2
    And no se envía header token de versión en la solicitud
    When el API recibe la solicitud
    Then respnde con error 400 en el procesamiento

  @negative @api_v2
  Scenario: Procesamiento en API V2 con datos de API V1 sin tid ni mid
    Given el merchant está usando API V2
    And no se envía tid ni mid
    When el API recibe la solicitud
    Then respnde con error 400 en el procesamiento
    And con el mensaje "faltan tid y mid en la solicitud"

  @negative @api_v2 @missing_fields
  Scenario Outline: Error por campos faltantes requeridos en API V2
    Given el API está configurado en versión V2
    And el header de versión está presente en la solicitud
    When se envía una solicitud sin el campo <campo_faltante>
    Then el API responde con Error 400
    And el mensaje indica que los campos son requeridos en V2 //(fijarnos el mensaje)

    Examples:
      | campo_faltante |
      | TID            |
      | MID            |

  @negative @api_v2 @field_validation
  Scenario Outline: Error por validación de longitud de campos en API V2
    Given el API está configurado en versión V2
    And el header de versión está presente en la solicitud
    When se envía una solicitud con <campo> que excede <longitud_maxima> caracteres
    Then el API responde con Error 400
    And el mensaje indica error de validación de longitud para <campo>

    Examples:
      | campo | longitud_maxima                        |
      | tid   | POS1234567890123456789                 |
      | mid   | MERCHANT123456789012345678901234567890 |

  @negative @extra_data
  Scenario: Error por datos adicionales no permitidos
    Given el API está configurado en cualquier versión
    When se envía una solicitud con campos adicionales no permitidos
    Then el API responde con Error 400
    And se mantiene el comportamiento actual de PROD

  @critico @almacenamiento
  Scenario: Almacenamiento exitoso de nuevos campos
    Given tengo una transacción validada con:
      | campo               | valor        |
      | terminalIDoriginal  | POS123456789 |
      | retailedIDoriginal  | MERCHANT001  |
      | parent_company_code | CHAIN001     |
      | transaction_id      | TXN_001      |
      | amount              | 100.50       |
    When proceso la transacción
    Then los datos deben almacenarse en DynamoDB
    And deben estar presentes en validated_data, sold_data, refund_data y response
    And la estructura existente debe mantenerse intacta

  Scenario: Almacenamiento exitoso de nuevos campos modificación B24/Datalake
    Given tengo una transacción validada con:
      | campo | valor        |
      | tid   | POS123456789 |
      | mid   | MERCHANT001  |
    When proceso la transacción
    Then los datos deben almacenarse en DynamoDB con:
      | campo              | valor        |
      | terminalIDoriginal | POS123456789 |
      | retailedIDoriginal | MERCHANT001  |
    When modifico los datos por B24/Datalake
    And me dirijo a DynamoDB nuevamente
    And los campos terminalIDoriginal y retailedIDoriginal deben haberse modificado
    And en los datos de DynamoDB debe visualizarse:
      | campo                      | valor        |
      | terminalKinesisOIDoriginal | POS123456789 |
      | retailerIdKinesisOriginal  | MERCHANT001  |
