# Casos de Prueba - HU-165a Validación de Campos TID/MID

## Información General
- **Historia:** HU-165a - Validación de campos TID/MID
- **Componente:** Lambda Gateway (APIG-DEV-MCS-PRODUCT-VALID-Lmda)
- **Tipo:** Funcional, Integración
- **Prioridad:** Alta

---

## TC-165a-001: Validación exitosa de TID válido

**Objetivo:** Verificar que TID con formato correcto pase la validación

**Precondiciones:**
- Lambda Gateway desplegado y funcional
- Endpoint de validación disponible

**Datos de Prueba:**
```json
{
  "tid": "POS123456789",
  "mid": "MERCHANT001",
  "version": "v2"
}
```

**Pasos:**
1. Enviar solicitud POST al endpoint con TID de 12 caracteres
2. Verificar respuesta del sistema

**Resultado Esperado:**
- Status Code: 200
- Validación exitosa
- Flujo continúa al siguiente paso

**Criterios de Aceptación:**
- TID entre 1-16 caracteres alfanuméricos debe pasar
- No debe retornar errores de validación

---

## TC-165a-002: TID inválido por exceso de longitud

**Objetivo:** Verificar rechazo de TID con más de 16 caracteres

**Precondiciones:**
- Lambda Gateway desplegado y funcional

**Datos de Prueba:**
```json
{
  "tid": "POS1234567890123456789",
  "mid": "MERCHANT001", 
  "version": "v2"
}
```

**Pasos:**
1. Enviar solicitud con TID de 21 caracteres
2. Verificar respuesta de error

**Resultado Esperado:**
- Status Code: 400
- Mensaje: "TID excede longitud máxima (16 caracteres)"
- Flujo se detiene

---

## TC-165a-003: TID vacío o nulo

**Objetivo:** Verificar manejo de TID vacío según versión API

**Precondiciones:**
- Lambda Gateway desplegado

**Datos de Prueba V2:**
```json
{
  "tid": "",
  "mid": "MERCHANT001",
  "version": "v2"
}
```

**Datos de Prueba V1:**
```json
{
  "tid": "",
  "mid": "MERCHANT001"
}
```

**Pasos:**
1. Enviar solicitud V2 con TID vacío
2. Enviar solicitud V1 con TID vacío
3. Comparar respuestas

**Resultado Esperado V2:**
- Status Code: 400
- Mensaje: "TID y MID son requeridos en API v2"

**Resultado Esperado V1:**
- Status Code: 200
- Validación exitosa (campo opcional)

---

## TC-165a-004: Validación exitosa de MID válido

**Objetivo:** Verificar que MID con formato correcto pase la validación

**Datos de Prueba:**
```json
{
  "tid": "POS123",
  "mid": "MERCHANT12345678901234567",
  "version": "v2"
}
```

**Pasos:**
1. Enviar solicitud con MID de 25 caracteres
2. Verificar respuesta

**Resultado Esperado:**
- Status Code: 200
- Validación exitosa
- MID aceptado correctamente

---

## TC-165a-005: MID inválido por exceso de longitud

**Objetivo:** Verificar rechazo de MID con más de 25 caracteres

**Datos de Prueba:**
```json
{
  "tid": "POS123",
  "mid": "MERCHANT123456789012345678901234567890",
  "version": "v2"
}
```

**Pasos:**
1. Enviar solicitud con MID de 35 caracteres
2. Verificar respuesta de error

**Resultado Esperado:**
- Status Code: 400
- Mensaje: "MID excede longitud máxima (25 caracteres)"

---

## TC-165a-006: Campos requeridos en V2

**Objetivo:** Verificar que V2 requiera ambos campos

**Datos de Prueba:**
```json
{
  "version": "v2",
  "other_field": "value"
}
```

**Pasos:**
1. Enviar solicitud V2 sin TID ni MID
2. Verificar error específico

**Resultado Esperado:**
- Status Code: 400
- Mensaje: "TID y MID son requeridos en API v2"

---

## TC-165a-007: Compatibilidad con V1 existente

**Objetivo:** Verificar que V1 mantenga funcionalidad sin nuevos campos

**Datos de Prueba:**
```json
{
  "existing_field": "value",
  "amount": 100.00
}
```

**Pasos:**
1. Enviar solicitud sin header de versión (inferir V1)
2. No incluir TID ni MID
3. Verificar procesamiento normal

**Resultado Esperado:**
- Status Code: 200
- Procesamiento exitoso
- Sin errores de validación por campos faltantes

---

## TC-165a-008: Caracteres especiales en TID/MID

**Objetivo:** Verificar manejo de caracteres especiales

**Datos de Prueba:**
```json
{
  "tid": "POS-123_456",
  "mid": "MERCH@NT#001",
  "version": "v2"
}
```

**Pasos:**
1. Enviar solicitud con caracteres especiales
2. Verificar respuesta según reglas de negocio

**Resultado Esperado:**
- Definir según reglas: ¿Se permiten guiones, underscores, símbolos?
- Documentar comportamiento esperado

---

## TC-165a-009: Detección automática de versión

**Objetivo:** Verificar inferencia correcta de versión V1

**Datos de Prueba:**
```json
{
  "standard_field": "value"
}
```

**Pasos:**
1. Enviar solicitud sin header "version"
2. Verificar que se infiera V1
3. Confirmar que TID/MID sean opcionales

**Resultado Esperado:**
- Procesamiento como V1
- Sin errores por campos faltantes

---

## TC-165a-010: Validación de tipos de datos

**Objetivo:** Verificar que TID/MID sean strings

**Datos de Prueba:**
```json
{
  "tid": 123456789,
  "mid": 987654321,
  "version": "v2"
}
```

**Pasos:**
1. Enviar TID/MID como números
2. Verificar manejo de tipos

**Resultado Esperado:**
- Error de tipo de dato o conversión automática
- Comportamiento consistente documentado

---

## Casos de Prueba de Regresión

### TC-165a-REG-001: Funcionalidad V1 intacta
**Objetivo:** Asegurar que cambios no rompan V1 existente

**Datos de Prueba:** Casos de prueba V1 existentes

**Resultado Esperado:** Todos los casos V1 previos deben seguir funcionando

---

## Datos de Prueba Adicionales

### Casos Límite TID:
- `"A"` (1 carácter)
- `"1234567890123456"` (16 caracteres exactos)
- `"12345678901234567"` (17 caracteres - inválido)

### Casos Límite MID:
- `"M"` (1 carácter)
- `"1234567890123456789012345"` (25 caracteres exactos)
- `"12345678901234567890123456"` (26 caracteres - inválido)

### Headers de Versión:
- `"v1"`, `"v2"`, `"V1"`, `"V2"` (case sensitivity)
- Sin header (inferir V1)
- Header inválido `"v3"`

---

## Configuración de Ambiente de Prueba

**Prerrequisitos:**
- Lambda Gateway desplegado en ambiente de testing
- Logs habilitados para debugging
- Herramientas de testing API (Postman, curl, etc.)

**Variables de Ambiente:**
- `API_ENDPOINT`: URL del Lambda Gateway
- `API_VERSION`: Versión a probar
- `LOG_LEVEL`: DEBUG para pruebas detalladas