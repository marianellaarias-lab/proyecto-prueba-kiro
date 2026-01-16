# HU-165d - Consultas por Cadena

## User Story
**Como** analista de negocio  
**Quiero** consultar transacciones por cadena de comercios usando parent_company_code y MID  
**Para** generar reportes específicos por cadena y analizar patrones de transacciones

## Información General
- **Historia Padre:** HU-165
- **Componente:** API de Consultas + DynamoDB GSI1
- **Prioridad:** Media
- **Estimación:** 4 puntos

## Criterios de Aceptación

### Escenario: Consulta por cadena específica
**DADO** que tengo transacciones almacenadas con parent_company_code  
**CUANDO** consulto por parent_company_code = "CHAIN001"  
**ENTONCES** debo obtener:
- Todas las transacciones de esa cadena
- Datos completos incluyendo TID, MID
- Resultados ordenados por fecha/hora
- Paginación para grandes volúmenes

### Escenario: Consulta por cadena y MID específico
**DADO** que uso GSI1 (parent_company_code + MID)  
**CUANDO** consulto por parent_company_code = "CHAIN001" y MID = "MERCHANT123"  
**ENTONCES** debo obtener:
- Transacciones específicas de ese merchant en esa cadena
- Respuesta rápida usando el índice GSI1
- Filtros adicionales disponibles (fecha, monto, estado)

### Escenario: Consulta con filtros avanzados
**DADO** que consulto transacciones por cadena  
**CUANDO** aplico filtros adicionales (rango de fechas, montos, TID)  
**ENTONCES** debo:
- Combinar eficientemente GSI1 con filtros
- Mantener rendimiento aceptable (<2 segundos)
- Proporcionar conteos y agregaciones básicas

### Escenario: Adaptación de filtros existentes
**DADO** que existen filtros o búsquedas actuales  
**CUANDO** se integran los nuevos campos TID/MID  
**ENTONCES** debo:
- Mantener funcionalidad existente
- Añadir nuevas opciones de filtrado
- Actualizar interfaces de usuario si aplican

## Definición de Terminado
- [ ] GSI1 optimizado para consultas por cadena
- [ ] API endpoints para consultas por parent_company_code
- [ ] API endpoints para consultas por parent_company_code + MID
- [ ] Filtros adicionales implementados (TID, fechas, montos)
- [ ] Paginación y ordenamiento funcional
- [ ] Pruebas de rendimiento satisfactorias
- [ ] Documentación de API actualizada

## Especificaciones Técnicas

### GSI1 Structure
```
PK: parent_company_code
SK: mid
Attributes: tid, transaction_date, amount, status, etc.
```

### API Endpoints Sugeridos
```
GET /transactions/by-chain/{parent_company_code}
GET /transactions/by-chain/{parent_company_code}/merchant/{mid}
GET /transactions/search?parent_company_code=X&mid=Y&tid=Z
```

### Parámetros de Consulta
- `parent_company_code` (requerido)
- `mid` (opcional)
- `tid` (opcional)
- `date_from`, `date_to` (opcional)
- `amount_min`, `amount_max` (opcional)
- `status` (opcional)
- `limit`, `offset` para paginación

## Consideraciones de Rendimiento
- GSI1 debe manejar consultas frecuentes eficientemente
- Implementar caching para consultas repetitivas
- Monitorear uso de RCU/WCU en DynamoDB
- Considerar partitioning si hay cadenas muy grandes

## Dependencias
- HU-165b (almacenamiento) debe estar completada
- GSI1 debe estar creado y poblado
- Coordinación con equipo de frontend para integración UI