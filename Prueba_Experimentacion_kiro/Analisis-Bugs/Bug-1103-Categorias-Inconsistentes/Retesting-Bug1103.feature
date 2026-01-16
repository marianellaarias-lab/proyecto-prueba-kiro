Feature: Retesting Bug 1103 - Consistencia de Categorías entre Lista y Detalle
    Como QA tester
    Quiero verificar que las categorías se muestren consistentemente entre lista y detalle
    Para confirmar que el bug de inconsistencia de datos está completamente resuelto

    Background:
        Given el usuario está autenticado en el sistema
        And tiene acceso al módulo MCC
        And el cliente "MCS" está configurado
        And el build con el fix está desplegado en ambiente de desarrollo

    # ===== ESCENARIO 1: VERIFICACIÓN DEL CASO ORIGINAL =====

    Scenario: Verificación del caso original - Registro específico del bug
        Given el usuario está en el módulo MCC
        And existe el registro con ID "cd1c86cc-178f-479e-868d-17fd8a874ebb"
        And el registro tiene MCC Number "10001" y MCC Name "Prueba"
        When el usuario accede a la lista de categorías para cliente "MCS"
        And localiza el registro con MCC Number "10001"
        Then debe observar la categoría mostrada en la lista
        And debe documentar el "Category Code" mostrado en lista
        And debe documentar el "Category Name" mostrado en lista
        And debe documentar el "Category Description" mostrado en lista
        When el usuario hace clic en el registro para ver el detalle
        Then debe observar la categoría mostrada en el detalle
        And debe documentar el "Category Code" mostrado en detalle
        And debe documentar el "Category Name" mostrado en detalle
        And debe documentar el "Category Description" mostrado en detalle
        And el "Category Code" de lista debe ser igual al "Category Code" de detalle
        And el "Category Name" de lista debe ser igual al "Category Name" de detalle
        And el "Category Description" de lista debe ser igual al "Category Description" de detalle

    Scenario: Verificación de consistencia - No debe mostrar "Other 3" vs "Tech"
        Given el usuario está visualizando el registro con ID "cd1c86cc-178f-479e-868d-17fd8a874ebb"
        When el usuario ve la categoría en la lista
        And el usuario ve la categoría en el detalle
        Then NO debe ver "Other 3" en lista y "Tech" en detalle
        And NO debe ver "OTH3" en lista y "H06" en detalle
        And la información debe ser consistente entre ambas vistas

    Scenario: Verificación de datos correctos post-fix
        Given el registro problemático ha sido corregido
        When el usuario consulta la lista de categorías
        And selecciona el registro con MCC Number "10001"
        Then debe mostrar la categoría correcta en la lista
        When el usuario accede al detalle del mismo registro
        Then debe mostrar exactamente la misma categoría que en la lista
        And la información debe ser coherente y lógica

    # ===== ESCENARIO 2: VARIACIONES DEL CASO ORIGINAL =====

    Scenario Outline: Verificación de consistencia en múltiples registros de MCS
        Given el usuario está en la lista de categorías para cliente "MCS"
        When el usuario selecciona un registro con MCC Number "<mcc_number>"
        And observa la categoría en la lista
        And hace clic para ver el detalle
        Then la categoría mostrada en lista debe ser igual a la mostrada en detalle
        And no debe haber discrepancias en ningún campo de categoría

        Examples:
            | mcc_number | descripcion                |
            | 10001      | Registro original del bug  |
            | 10002      | Segundo registro de prueba |
            | 10003      | Tercer registro de prueba  |

    Scenario: Verificación con diferentes clientes
        Given existen registros para múltiples clientes
        When el usuario cambia al cliente "DEMO"
        And selecciona un registro de categoría
        And verifica la consistencia entre lista y detalle
        Then debe mostrar información consistente
        And el comportamiento debe ser igual para todos los clientes

    Scenario Outline: Verificación por tipos de categorías
        Given el usuario está en la lista de categorías
        When el usuario filtra por tipo de categoría "<tipo_categoria>"
        And selecciona un registro con código "<codigo_categoria>"
        And verifica la consistencia entre lista y detalle
        Then debe mostrar la misma información en ambas vistas
        And el tipo de categoría debe ser consistente

        Examples:
            | tipo_categoria | codigo_categoria | descripcion            |
            | Other          | OTH1             | Categoría Other tipo 1 |
            | Other          | OTH2             | Categoría Other tipo 2 |
            | Other          | OTH3             | Categoría Other tipo 3 |
            | Technical      | H06              | Categoría técnica      |
            | Standard       | STD1             | Categoría estándar     |

    #   Scenario: Casos edge - Registros con datos especiales
    #     Given existen registros con características especiales
    #     When el usuario selecciona un registro con "categoría muy larga"
    #     Then debe mostrar consistencia entre lista y detalle
    #     When el usuario selecciona un registro con "caracteres especiales en categoría"
    #     Then debe mostrar consistencia entre lista y detalle
    #     When el usuario selecciona un registro con "categoría recién creada"
    #     Then debe mostrar consistencia entre lista y detalle
    #     And todos los casos edge deben mantener consistencia

    # ===== ESCENARIO 3: VERIFICACIÓN DE INTEGRIDAD DE DATOS =====

    Scenario: Verificación de consistencia en base de datos
        Given el usuario tiene acceso a la base de datos
        When el usuario ejecuta la query de verificación del registro específico:
            """
            SELECT
            id,
            mcs_category_code,
            mcs_category_name,
            mcs_category_description,
            client,
            mcc_number,
            mcc_name
            FROM [tabla_categorias]
            WHERE id = 'cd1c86cc-178f-479e-868d-17fd8a874ebb'
            """
        Then debe retornar exactamente un registro
        And los datos deben ser consistentes internamente
        And no debe haber valores nulos en campos críticos

    # Scenario: Verificación de duplicados e inconsistencias masivas
    #     Given el usuario ejecuta la query de detección de inconsistencias:
    #         """
    #         SELECT
    #         mcc_number,
    #         mcc_name,
    #         COUNT(DISTINCT mcs_category_code) as different_codes,
    #         COUNT(DISTINCT mcs_category_name) as different_names
    #         FROM [tabla_categorias]
    #         WHERE client = 'MCS'
    #         GROUP BY mcc_number, mcc_name
    #         HAVING COUNT(DISTINCT mcs_category_code) > 1
    #         OR COUNT(DISTINCT mcs_category_name) > 1
    #         """
    #     Then la query NO debe retornar ningún registro
    #     And no debe haber duplicados con categorías diferentes
    #     And la integridad referencial debe estar mantenida

    Scenario: Verificación de APIs - Lista vs Detalle
        Given el usuario tiene acceso a las APIs del sistema
        When el usuario llama a la API de lista: "GET /api/mcc/categories?client=MCS"
        And extrae los datos del registro con ID "cd1c86cc-178f-479e-868d-17fd8a874ebb"
        And llama a la API de detalle: "GET /api/mcc/categories/cd1c86cc-178f-479e-868d-17fd8a874ebb"
        Then ambas APIs deben devolver la misma información de categoría
        And el "mcs_category_code" debe ser idéntico en ambas respuestas
        And el "mcs_category_name" debe ser idéntico en ambas respuestas
        And el "mcs_category_description" debe ser idéntico en ambas respuestas

    # Scenario: Verificación de sincronización de datos
    #     Given existe un registro con categoría conocida
    #     When el usuario modifica la categoría a través de la API
    #     And espera la sincronización del sistema
    #     And consulta la lista de categorías
    #     And accede al detalle del mismo registro
    #     Then ambas vistas deben mostrar la categoría actualizada
    #     And la sincronización debe ser inmediata
    #     And no debe haber delay entre lista y detalle

    # ===== ESCENARIO 4: TESTING DE REGRESIÓN =====

    Scenario: Verificación de funcionalidad de búsqueda y filtrado
        Given el usuario está en la lista de categorías
        When el usuario busca por Category Code "OTH3"
        Then debe mostrar los registros correspondientes
        And la información mostrada debe ser consistente
        When el usuario busca por Category Name "Other 3"
        Then debe mostrar los registros correspondientes
        And debe coincidir con la búsqueda por código
        When el usuario filtra por cliente "MCS"
        Then debe mostrar solo registros de MCS
        And todos deben mantener consistencia lista-detalle

    Scenario: Verificación de operaciones CRUD en categorías
        Given el usuario tiene permisos para gestionar categorías
        When el usuario crea una nueva categoría con diferentes valores
        Then la categoría debe aparecer en la lista
        When el usuario accede al detalle de la nueva categoría
        Then debe mostrar exactamente la misma información
        And debe haber consistencia inmediata entre lista y detalle

    Scenario: Verificación de modificación de categorías existentes
        Given existe una categoría con datos conocidos
        When el usuario modifica el "Category Name" de "Valor Original" a "Valor Modificado"
        And guarda los cambios
        Then la lista debe mostrar "Valor Modificado"
        When el usuario accede al detalle
        Then también debe mostrar "Valor Modificado"
        And la actualización debe ser consistente en ambas vistas

    # Scenario: Verificación de reportes y exportaciones
    #     Given el usuario accede a la funcionalidad de reportes
    #     When el usuario genera un reporte de categorías para cliente "MCS"
    #     Then el reporte debe mostrar datos consistentes
    #     And debe incluir el registro que tenía el bug original
    #     And los datos del reporte deben coincidir con lista y detalle
    #     When el usuario exporta la lista de categorías
    #     Then el archivo exportado debe contener datos consistentes
    #     And debe coincidir con lo mostrado en la interfaz

    # Scenario: Verificación de dashboard y métricas
    #     Given el usuario accede al dashboard de métricas
    #     When el sistema calcula estadísticas de categorías
    #     Then los cálculos deben basarse en datos consistentes
    #     And no debe haber discrepancias por datos duplicados
    #     And las métricas deben reflejar la realidad del sistema

    # ===== ESCENARIO 5: TESTING DE PERFORMANCE Y ESTABILIDAD =====

    # Scenario: Verificación de performance - Tiempo de carga
    #     Given el usuario está en el módulo MCC
    #     When el usuario accede a la lista de categorías
    #     Then la lista debe cargar en menos de 3 segundos
    #     When el usuario selecciona un registro para ver el detalle
    #     Then el detalle debe cargar en menos de 2 segundos
    #     And los tiempos de respuesta no deben haberse degradado por el fix

    # Scenario: Verificación de estabilidad - Testing repetitivo
    #     Given el usuario está en la lista de categorías
    #     When el usuario selecciona el registro con ID "cd1c86cc-178f-479e-868d-17fd8a874ebb"
    #     And verifica la consistencia entre lista y detalle
    #     And repite esta acción 5 veces consecutivas
    #     Then en todas las ejecuciones debe mostrar consistencia
    #     And no debe haber comportamiento intermitente
    #     And los datos deben ser estables en cada ejecución

    # Scenario Outline: Verificación de estabilidad con múltiples registros
    #     Given el usuario está en la lista de categorías
    #     When el usuario selecciona el registro "<registro_id>"
    #     And verifica la consistencia entre lista y detalle
    #     Then debe mostrar información consistente
    #     And el comportamiento debe ser estable

    #     Examples:
    #         | registro_id                          | descripcion                |
    #         | cd1c86cc-178f-479e-868d-17fd8a874ebb | Registro original del bug  |
    #         | 2c95f4c2-902e-426e-9b05-1761c6ce4c2  | Segundo registro de prueba |

    # Scenario: Verificación de performance con volumen de datos
    #     Given existen más de 100 registros de categorías en el sistema
    #     When el usuario carga la lista completa de categorías
    #     Then la lista debe cargar eficientemente
    #     And debe mantener la funcionalidad de paginación
    #     When el usuario navega entre múltiples páginas
    #     And accede a detalles de diferentes registros
    #     Then la performance debe mantenerse consistente
    #     And no debe haber degradación por el volumen de datos

    # Scenario: Verificación de concurrencia - Múltiples usuarios
    #     Given múltiples usuarios están accediendo al sistema simultáneamente
    #     When el "Usuario 1" consulta la lista de categorías
    #     And el "Usuario 2" consulta el detalle de una categoría
    #     And el "Usuario 3" modifica una categoría
    #     Then todos los usuarios deben ver datos consistentes
    #     And no debe haber conflictos de concurrencia
    #     And las operaciones deben completarse exitosamente

    # ===== CRITERIOS DE ACEPTACIÓN =====

    Scenario: Criterios de aceptación para considerar el retesting como EXITOSO
        Given se han ejecutado todos los escenarios de retesting
        Then el registro original "cd1c86cc-178f-479e-868d-17fd8a874ebb" debe mostrar datos consistentes
        And otros registros de MCS también deben mostrar consistencia
        And diferentes clientes deben funcionar correctamente
        And las consultas de BD deben confirmar integridad de datos
        And las APIs de lista y detalle deben devolver la misma información
        And no debe haber regresiones en funcionalidades relacionadas
        And la performance debe mantenerse o mejorar
        And el fix debe ser estable en múltiples ejecuciones
        And todos los criterios deben cumplirse para considerar PASS

    Scenario: Criterios que indican que el retesting ha FALLADO
        Given se han ejecutado los escenarios de retesting
        When se detecta que persiste inconsistencia en el registro original
        Or aparecen inconsistencias en otros registros
        Or las APIs devuelven información diferente
        Or hay regresiones en búsqueda/filtrado
        Or la performance se degrada significativamente
        Or hay comportamiento intermitente o inestable
        Then el retesting debe marcarse como FAIL
        And el bug debe reabrirse con la nueva información

    Scenario: Criterios que indican mejoras parciales
        Given se han ejecutado los escenarios de retesting
        When el registro original está corregido pero hay otros con problemas
        Or funciona para algunos clientes pero no todos
        Or hay mejoras parciales pero no solución completa
        Or requiere ajustes adicionales menores
        Then el retesting debe marcarse como PARTIAL
        And deben crearse nuevos bugs para los issues pendientes
        And debe definirse un plan para completar la resolución