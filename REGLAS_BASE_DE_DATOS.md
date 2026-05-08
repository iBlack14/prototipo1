# 📑 Guía de Estándares de Base de Datos - Proyecto ABC

Este documento resume las normas de diseño físico extraídas del manual de estándares.

---

## 1. Nomenclatura (Naming)
- **Minúsculas:** Todos los nombres de objetos en minúsculas.
- **Singular:** Tablas y atributos siempre en singular.
- **Separador:** Usar guion bajo `_` (máximo 3 palabras).
- **SQL:** Comandos SQL en **MAYÚSCULAS**.

## 2. Prefijos de Objetos
| Objeto | Prefijo | Ejemplo |
| :--- | :--- | :--- |
| **Clave Primaria** | `pk_` | `pk_usuario` |
| **Clave Foránea** | `fk_` | `fk_pedido_cliente` |
| **Clave Única** | `uk_` | `uk_usuario_email` |
| **Check (Restricción)** | `ck_` | `ck_producto_stock` |
| **Índice** | `idx_` | `idx_producto_nombre` |
| **Vista** | `v_` | `v_ventas_mes` |
| **Función** | `fn_` | `fn_calcular_iva` |
| **Procedimiento** | `sp_` | `sp_insertar_usuario` |
| **Trigger** | `tri_` | `tri_ins_pedido` |

## 3. Atributos y Prefijos
| Tipo de Dato | Prefijo | Ejemplo |
| :--- | :--- | :--- |
| **Identificador** | `id_` | `id_producto` |
| **Fecha / Hora** | `fec_` | `fec_nacimiento` |
| **Descripción** | `desc_` | `desc_producto` |
| **Nombre** | `nom_` | `nom_cliente` |
| **Cantidad / Número** | `num_` | `num_stock` |
| **Monto / Total** | `tot_` | `tot_pago` |
| **Correo / Web** | `val_` | `val_email` |

- **ID:** Usar `id_` para claves (ej: `id_cliente`).
- **FK:** Deben llamarse igual que el campo que referencian.
- **Evitar NULL:** Intentar que los campos no permitan nulos (`NOT NULL`).
- **ANSI SQL:** Usar tipos de datos estándar (`DECIMAL`, `VARCHAR`, `INT`).

## 4. Mejores Prácticas de Querys
- ✅ **SÍ:** `SELECT nombre, correo FROM usuario`
- ❌ **NO:** `SELECT * FROM usuario`
- ⚠️ **UPDATE/DELETE:** Siempre deben llevar `WHERE`.
- 🚀 **Optimización:** Usar `=` en lugar de `LIKE` si es posible. Preferir `AND` sobre `OR`.

## 5. Estándares de Scripts
- **Codificación:** UTF-8 sin BOM.
- **Cabecera:** Todo script debe iniciar con:
  - Proyecto
  - Autor
  - Usuario
  - Descripción
  - Fecha de Modificación

## 6. Integridad y Restricciones
- **PK Explícitas:** Siempre definir la clave primaria con `CONSTRAINT pk_nombre`.
- **Valores por Defecto:** Usar `DEFAULT` para campos de estado o fechas.
- **Check Constraints:** Validar rangos numéricos (ej: `precio > 0`).

## 7. Manejo de Stock e Inventario
- **Stock Mínimo:** Todo producto debe tener un campo `stock_minimo`.
- **Validación de Existencia:** No permitir ventas si `num_stock < cantidad_solicitada`.
- **Estado de Disponibilidad:** Usar un campo `estado` (disponible/agotado) calculado o actualizado por trigger.
- **Histórico:** Los movimientos de stock deben registrarse en una tabla de auditoría/kardex.

## 8. Auditoría y Trazabilidad
- **Campos Obligatorios:** Todas las tablas de negocio deben incluir:
  - `fec_registro`: Fecha y hora de creación.
  - `usu_registro`: Usuario que creó el registro.
  - `fec_modificacion`: Fecha y hora del último cambio.
  - `usu_modificacion`: Usuario que realizó el cambio.

## 9. Documentación y Comentarios
- **Tablas:** Cada tabla debe tener un comentario explicando su propósito.
- **Columnas:** Comentar columnas que tengan lógica compleja o estados (ej: `estado: A=Activo, I=Inactivo`).
- **Scripts:** Usar `--` para comentarios de línea y `/* ... */` para bloques.



---
*Basado en el documento oficial: Estándares de diseño físico de BD (v1.0)*
