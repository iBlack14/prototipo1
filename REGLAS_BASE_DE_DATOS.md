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
| **Clave Foránea** | `fk_` | `fk_pedido-cliente` |
| **Índice** | `idx_` | `idx_producto_nombre` |
| **Vista** | `v_` | `v_ventas_mes` |
| **Función** | `fn_` | `fn_calcular_iva` |
| **Procedimiento** | `sp_` | `sp_insertar_usuario` |
| **Trigger** | `tri_` | `tri_ins_pedido` |

## 3. Atributos y Tipos
- **ID:** Usar `id_` para claves (ej: `id_cliente`).
- **FK:** Deben llamarse igual que el campo que referencian.
- **Evitar NULL:** Intentar que los campos no permitan nulos.
- **ANSI SQL:** Usar tipos de datos estándar.

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

---
*Basado en el documento oficial: Estándares de diseño físico de BD (v1.0)*
