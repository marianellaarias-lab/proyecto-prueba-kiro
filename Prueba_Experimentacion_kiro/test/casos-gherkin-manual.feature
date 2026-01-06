# Casos de Prueba Manual - Validaciones TID/MID
# Formato Gherkin para pruebas manuales críticas

Feature: Validación de campos TID y MID
  Como aseguradora
  Quiero que el sistema valide correctamente TID y MID
  Para cumplir con regulaciones y trazabilidad

  Background:
    Given el sistema está configurado para API v2
    And el endpoint de validación está disponible

  @critico @validacion
  Scenario: Validación exitosa de TID y MID válidos
    Given tengo una solicitud con TID "POS123456789" y MID "MERCHANT001"
    When envío la solicitud al endpoint de validación
    Then el sistema debe responder con status 200
    And la validación debe ser exitosa
    And el flujo debe continuar al siguiente paso

  @critico @validacion
  Scenario: Rechazo de TID con longitud excesiva
    Given tengo una solicitud con TID "POS1234567890123456789" (21 caracteres)
    And MID "MERCHANT001"
    When envío la solicitud al endpoint de validación
    Then el sistema debe responder con status 400
    And el mensaje debe ser "TID excede longitud máxima (16 caracteres)"

  @critico @validacion
  Scenario: Rechazo de MID con longitud excesiva
    Given tengo una solicitud con TID "POS123"
    And MID "MERCHANT123456789012345678901234567890" (35 caracteres)
    When envío la solicitud al endpoint de validación
    Then el sistema debe responder con status 400
    And el mensaje debe ser "MID excede longitud máxima (25 caracteres)"

  @critico @compatibilidad
  Scenario: Campos requeridos en API v2
    Given tengo una solicitud sin TID ni MID
    And el header de versión es "v2"
    When envío la solicitud al endpoint
    Then el sistema debe responder con status 400
    And el mensaje debe ser "TID y MID son requeridos en API v2"

  @critico @compatibilidad
  Scenario: Campos opcionales en API v1 (sin header de versión)
    Given tengo una solicitud sin TID ni MID
    And no incluyo header de versión (inferir v1)
    When envío la solicitud al endpoint
    Then el sistema debe responder con status 200
    And la validación debe ser exitosa
    And no debe haber errores por campos faltantes

Feature: Almacenamiento en DynamoDB
  Como sistema de procesamiento
  Quiero almacenar TID, MID y parent_company_code correctamente
  Para permitir consultas y trazabilidad

  @critico @almacenamiento
  Scenario: Almacenamiento exitoso de nuevos campos
    Given tengo una transacción validada con:
      | campo               | valor        |
      | tid                 | POS123456789 |
      | mid                 | MERCHANT001  |
      | parent_company_code | CHAIN001     |
      | transaction_id      | TXN_001      |
      | amount              | 100.50       |
    When proceso la transacción
    Then los datos deben almacenarse en DynamoDB
    And deben estar presentes en validated_data, sold_data, refund_data y response
    And la estructura existente debe mantenerse intacta

  @critico @consultas
  Scenario: Creación y funcionalidad de GSI1
    Given tengo múltiples transacciones almacenadas:
      | transaction_id | tid    | mid      | parent_company_code | amount |
      | TXN_001        | POS001 | MERCH001 | CHAIN001            | 100.00 |
      | TXN_002        | POS002 | MERCH002 | CHAIN001            | 200.00 |
      | TXN_003        | POS003 | MERCH001 | CHAIN002            | 150.00 |
    When consulto GSI1 por parent_company_code "CHAIN001"
    Then debo obtener TXN_001 y TXN_002
    And el tiempo de respuesta debe ser menor a 100ms
    When consulto GSI1 por parent_company_code "CHAIN001" y mid "MERCH001"
    Then debo obtener solo TXN_001

  @importante @compatibilidad
  Scenario: Compatibilidad con transacciones V1 existentes
    Given tengo una transacción V1 sin nuevos campos:
      | campo          | valor      |
      | transaction_id | TXN_V1_001 |
      | amount         | 75.25      |
      | existing_field | value      |
    When proceso la transacción
    Then debe almacenarse sin errores
    And los campos tid, mid, parent_company_code deben ser NULL
    And la funcionalidad existente debe preservarse

Feature: Logging y Auditoría
  Como auditor del sistema
  Quiero que se registren TID, MID y parent_company_code en logs
  Para tener trazabilidad completa

  @importante @logging
  Scenario: Logging completo en procesamiento principal
    Given tengo una transacción con:
      | campo               | valor         |
      | transaction_id      | TXN_LOG_001   |
      | tid                 | POS_LOG_001   |
      | mid                 | MERCH_LOG_001 |
      | parent_company_code | CHAIN_LOG_001 |
    When proceso la transacción
    Then los logs deben contener TID, MID y parent_company_code en:
      | punto_de_log             |
      | Inicio de procesamiento  |
      | Validación exitosa       |
      | Almacenamiento DynamoDB  |
      | Finalización transacción |
    And los timestamps deben ser precisos y consistentes

  @importante @auditoria
  Scenario: Auditoría de cambios de transacción
    Given tengo una transacción existente:
      | campo               | valor_original |
      | transaction_id      | TXN_AUDIT_001  |
      | tid                 | POS_ORIGINAL   |
      | mid                 | MERCH_ORIGINAL |
      | parent_company_code | CHAIN_ORIGINAL |
      | status              | pending        |
    When modifico la transacción con:
      | campo               | valor_nuevo   |
      | tid                 | POS_UPDATED   |
      | mid                 | MERCH_UPDATED |
      | parent_company_code | CHAIN_UPDATED |
      | status              | completed     |
    Then debe generarse un log de auditoría con:
      | elemento          |
      | Estado anterior   |
      | Estado nuevo      |
      | Usuario/sistema   |
      | Timestamp preciso |

Feature: Consultas por Cadena
  Como analista de negocio
  Quiero consultar transacciones por cadena
  Para generar reportes específicos

  @importante @consultas
  Scenario: Consulta exitosa por cadena específica
    Given tengo transacciones almacenadas:
      | transaction_id | parent_company_code | mid      | amount | date       |
      | TXN_001        | CHAIN001            | MERCH001 | 100.00 | 2024-01-15 |
      | TXN_002        | CHAIN001            | MERCH002 | 200.00 | 2024-01-15 |
      | TXN_003        | CHAIN002            | MERCH003 | 150.00 | 2024-01-15 |
    When ejecuto GET /transactions/by-chain/CHAIN001
    Then debo obtener TXN_001 y TXN_002 únicamente
    And los datos deben incluir TID, MID completos
    And deben estar ordenados cronológicamente
    And el tiempo de respuesta debe ser menor a 2 segundos

  @importante @consultas
  Scenario: Consulta con filtros avanzados
    Given tengo transacciones de CHAIN_FILTER con diferentes características
    When consulto con filtros:
      | filtro              | valor        |
      | parent_company_code | CHAIN_FILTER |
      | date_from           | 2024-01-15   |
      | date_to             | 2024-01-15   |
      | amount_min          | 150          |
      | status              | completed    |
    Then debo obtener solo transacciones que cumplan TODOS los filtros
    And el tiempo de respuesta debe ser aceptable

Feature: Integración con Reportes
  Como usuario de reportes
  Quiero que TID, MID y parent_company_code estén en reportes
  Para análisis detallados

  @importante @reportes
  Scenario: Campos disponibles en reportes Glue
    Given tengo transacciones procesadas con nuevos campos
    When ejecuto el job de AWS Glue para generar reportes
    Then los campos tid, mid, parent_company_code deben estar presentes
    And los valores deben ser correctos sin corrupción
    And las relaciones entre campos deben preservarse
    And el job debe ejecutarse sin errores

  @importante @reportes
  Scenario: Nuevas dimensiones de análisis disponibles
    Given tengo un dataset con transacciones variadas
    When creo análisis agrupados por:
      | dimension           |
      | TID (por terminal)  |
      | MID (por merchant)  |
      | parent_company_code |
    Then debo poder generar métricas por cada dimensión
    And debo poder hacer análisis cruzados
    And la funcionalidad de drill-down debe funcionar

  @importante @reportes
  Scenario: Manejo de datos históricos en reportes
    Given tengo datos históricos sin TID/MID (valores NULL)
    And datos nuevos con todos los campos
    When genero un reporte que incluya ambos períodos
    Then los registros históricos deben aparecer con campos NULL
    And las agregaciones deben manejar NULLs apropiadamente
    And no debe haber errores en el procesamiento
    And los conteos totales deben incluir todos los registros