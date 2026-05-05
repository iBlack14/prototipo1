-- =====================================================
-- SNACK ROQUE — Base de Datos
-- Proyecto: Sistema de Gestión POS
-- Autor: Equipo Desarrollo
-- Fecha: 2026-05-05
-- Descripción: Script de creación de BD completa
-- =====================================================

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS snack_roque;
USE snack_roque;

-- =====================================================
-- TABLA: rol
-- Descripción: Roles del sistema (Administrador, Cajero)
-- =====================================================
CREATE TABLE rol (
    id_rol INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único del rol',
    nombre VARCHAR(50) NOT NULL UNIQUE COMMENT 'Nombre del rol',
    descripcion VARCHAR(200) COMMENT 'Descripción del rol'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: usuario
-- Descripción: Usuarios del sistema
-- =====================================================
CREATE TABLE usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único del usuario',
    id_rol INT NOT NULL COMMENT 'Referencia al rol del usuario',
    nombre VARCHAR(100) NOT NULL COMMENT 'Nombre completo del usuario',
    user_login VARCHAR(50) NOT NULL UNIQUE COMMENT 'Usuario para login',
    password VARCHAR(255) NOT NULL COMMENT 'Contraseña encriptada',
    status_usuario VARCHAR(20) NOT NULL DEFAULT 'active' COMMENT 'Estado: active, inactive',
    fec_creacion DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación',
    CONSTRAINT fk_usuario_rol FOREIGN KEY (id_rol) REFERENCES rol(id_rol) ON DELETE RESTRICT,
    INDEX idx_usuario_login (user_login),
    INDEX idx_usuario_status (status_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: cliente
-- Descripción: Clientes que realizan compras
-- =====================================================
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único del cliente',
    nombre VARCHAR(100) NOT NULL COMMENT 'Nombre del cliente',
    num_telefono VARCHAR(15) COMMENT 'Teléfono de contacto',
    desc_direccion TEXT COMMENT 'Dirección del cliente',
    fec_registro DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro',
    INDEX idx_cliente_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: categoria
-- Descripción: Categorías de productos
-- =====================================================
CREATE TABLE categoria (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único de la categoría',
    nombre VARCHAR(100) NOT NULL UNIQUE COMMENT 'Nombre de la categoría',
    desc_categoria TEXT COMMENT 'Descripción de la categoría'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: producto
-- Descripción: Inventario de productos
-- =====================================================
CREATE TABLE producto (
    id_producto INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único del producto',
    id_categoria INT NOT NULL COMMENT 'Referencia a la categoría',
    nombre VARCHAR(100) NOT NULL COMMENT 'Nombre del producto',
    precio DECIMAL(10,2) NOT NULL COMMENT 'Precio de venta',
    num_stock INT NOT NULL DEFAULT 0 COMMENT 'Cantidad en stock',
    stock_minimo INT DEFAULT 5 COMMENT 'Stock mínimo para alertas',
    fec_ingreso DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de ingreso',
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria) ON DELETE RESTRICT,
    INDEX idx_producto_nombre (nombre),
    INDEX idx_producto_stock (num_stock)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: venta
-- Descripción: Registro de ventas
-- =====================================================
CREATE TABLE venta (
    id_venta INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único de la venta',
    id_usuario INT NOT NULL COMMENT 'Usuario que registró la venta',
    id_cliente INT COMMENT 'Cliente que realizó la compra',
    fec_venta DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de la venta',
    metodo_pago VARCHAR(50) NOT NULL COMMENT 'Método de pago (efectivo, tarjeta, etc)',
    tot_pago DECIMAL(12,2) NOT NULL COMMENT 'Total pagado',
    observaciones TEXT COMMENT 'Observaciones de la venta',
    CONSTRAINT fk_venta_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE RESTRICT,
    CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE SET NULL,
    INDEX idx_venta_fecha (fec_venta),
    INDEX idx_venta_usuario (id_usuario),
    INDEX idx_venta_cliente (id_cliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: detalle_venta
-- Descripción: Detalles de cada venta (productos vendidos)
-- =====================================================
CREATE TABLE detalle_venta (
    id_detalle_venta INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único del detalle',
    id_venta INT NOT NULL COMMENT 'Referencia a la venta',
    id_producto INT NOT NULL COMMENT 'Referencia al producto',
    num_cantidad INT NOT NULL COMMENT 'Cantidad vendida',
    precio_unitario DECIMAL(10,2) NOT NULL COMMENT 'Precio unitario en el momento de la venta',
    subtotal DECIMAL(12,2) GENERATED ALWAYS AS (num_cantidad * precio_unitario) STORED COMMENT 'Subtotal automático',
    CONSTRAINT fk_detalle_venta_venta FOREIGN KEY (id_venta) REFERENCES venta(id_venta) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_venta_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE RESTRICT,
    INDEX idx_detalle_venta_venta (id_venta),
    INDEX idx_detalle_venta_producto (id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: proveedor
-- Descripción: Proveedores de productos
-- =====================================================
CREATE TABLE proveedor (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único del proveedor',
    nombre VARCHAR(100) NOT NULL COMMENT 'Nombre del proveedor',
    num_telefono VARCHAR(15) COMMENT 'Teléfono de contacto',
    desc_direccion TEXT COMMENT 'Dirección del proveedor',
    email VARCHAR(100) COMMENT 'Email del proveedor',
    fec_registro DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de registro',
    INDEX idx_proveedor_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: compra
-- Descripción: Compras a proveedores
-- =====================================================
CREATE TABLE compra (
    id_compra INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único de la compra',
    id_proveedor INT NOT NULL COMMENT 'Proveedor de la compra',
    id_usuario INT NOT NULL COMMENT 'Usuario que registró la compra',
    fec_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de la compra',
    tot_compra DECIMAL(12,2) NOT NULL COMMENT 'Total de la compra',
    num_factura VARCHAR(50) COMMENT 'Número de factura del proveedor',
    estado_compra VARCHAR(20) DEFAULT 'pendiente' COMMENT 'Estado: pendiente, recibida, cancelada',
    CONSTRAINT fk_compra_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor) ON DELETE RESTRICT,
    CONSTRAINT fk_compra_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE RESTRICT,
    INDEX idx_compra_fecha (fec_compra),
    INDEX idx_compra_estado (estado_compra)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: detalle_compra
-- Descripción: Detalles de cada compra (productos comprados)
-- =====================================================
CREATE TABLE detalle_compra (
    id_detalle_compra INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único del detalle',
    id_compra INT NOT NULL COMMENT 'Referencia a la compra',
    id_producto INT NOT NULL COMMENT 'Referencia al producto',
    num_cantidad INT NOT NULL COMMENT 'Cantidad comprada',
    precio_compra DECIMAL(10,2) NOT NULL COMMENT 'Precio unitario de compra',
    subtotal DECIMAL(12,2) GENERATED ALWAYS AS (num_cantidad * precio_compra) STORED COMMENT 'Subtotal automático',
    CONSTRAINT fk_detalle_compra_compra FOREIGN KEY (id_compra) REFERENCES compra(id_compra) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_compra_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE RESTRICT,
    INDEX idx_detalle_compra_compra (id_compra),
    INDEX idx_detalle_compra_producto (id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA: cierre_caja
-- Descripción: Registro de cierres de caja diarios
-- =====================================================
CREATE TABLE cierre_caja (
    id_cierre_caja INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único del cierre',
    id_usuario INT NOT NULL COMMENT 'Cajero que cerró la caja',
    fec_apertura DATETIME NOT NULL COMMENT 'Fecha y hora de apertura de caja',
    fec_cierre DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de cierre',
    saldo_inicial DECIMAL(12,2) NOT NULL COMMENT 'Saldo inicial en la caja',
    total_ventas DECIMAL(12,2) NOT NULL DEFAULT 0 COMMENT 'Total de ventas del período',
    total_devoluciones DECIMAL(12,2) DEFAULT 0 COMMENT 'Total de devoluciones',
    total_efectivo DECIMAL(12,2) NOT NULL COMMENT 'Total de efectivo declarado',
    diferencia DECIMAL(12,2) GENERATED ALWAYS AS (total_efectivo - (saldo_inicial + total_ventas - total_devoluciones)) STORED COMMENT 'Diferencia calculada automáticamente',
    estado_cierre VARCHAR(20) NOT NULL DEFAULT 'cuadre' COMMENT 'Estado: cuadre, sobrante, faltante',
    observaciones TEXT COMMENT 'Observaciones sobre el cierre',
    CONSTRAINT fk_cierre_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE RESTRICT,
    INDEX idx_cierre_fecha (fec_cierre),
    INDEX idx_cierre_estado (estado_cierre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- INSERCIÓN DE DATOS INICIALES
-- =====================================================

-- Roles
INSERT INTO rol (nombre, descripcion) VALUES
('Administrador', 'Acceso total al sistema'),
('Cajero', 'Acceso limitado a ventas y reportes');

-- Usuarios
INSERT INTO usuario (id_rol, nombre, user_login, password, status_usuario) VALUES
(1, 'María Rodríguez', 'admin', 'admin123', 'active'),
(2, 'Juan López', 'cajero', 'cajero123', 'active'),
(2, 'Ana Paredes', 'ana', 'ana123', 'active');

-- Categorías
INSERT INTO categoria (nombre, desc_categoria) VALUES
('Panes', 'Panes variados: francés, molde, integral, etc'),
('Tortas', 'Tortas dulces y decoradas'),
('Otros', 'Productos variados: empanadillas, roscas, etc');

-- Clientes
INSERT INTO cliente (nombre, num_telefono, desc_direccion) VALUES
('Cliente General', '999999999', 'Mostrador'),
('Panadería Central', '987654321', 'Jr. Principal 123'),
('Supermercado Plaza', '976543210', 'Av. Central 456');

-- Productos
INSERT INTO producto (id_categoria, nombre, precio, num_stock, stock_minimo) VALUES
(1, 'Pan Francés', 0.20, 250, 50),
(1, 'Croissant', 2.50, 5, 10),
(2, 'Torta Chocolate', 45.00, 8, 3),
(1, 'Pan de Molde', 8.00, 0, 10),
(3, 'Empanada', 1.50, 60, 20),
(1, 'Cachito', 1.00, 45, 30),
(1, 'Pan Integral', 3.50, 20, 15),
(3, 'Rosca', 4.00, 15, 10);

-- Proveedores
INSERT INTO proveedor (nombre, num_telefono, desc_direccion, email) VALUES
('Distribuidora La Americana', '987123456', 'Av. Bolognesi 789', 'info@laamericana.com'),
('Molino del Centro', '985234567', 'Jr. Comercio 234', 'ventas@molinocentro.com'),
('Dulcería San José', '984345678', 'Calle Principal 567', 'contacto@dulceriasj.com');

-- =====================================================
-- ÍNDICES ADICIONALES PARA OPTIMIZACIÓN
-- =====================================================

CREATE INDEX idx_usuario_rol ON usuario(id_rol);
CREATE INDEX idx_detalle_venta_producto ON detalle_venta(id_producto);
CREATE INDEX idx_detalle_compra_producto ON detalle_compra(id_producto);
CREATE INDEX idx_cierre_caja_usuario ON cierre_caja(id_usuario);

-- =====================================================
-- VISTAS ÚTILES
-- =====================================================

-- Vista: Ventas del día con detalles
CREATE OR REPLACE VIEW v_ventas_hoy AS
SELECT 
    v.id_venta,
    v.fec_venta,
    u.nombre AS cajero,
    c.nombre AS cliente,
    COUNT(dv.id_detalle_venta) AS num_productos,
    SUM(dv.subtotal) AS total,
    v.metodo_pago
FROM venta v
LEFT JOIN usuario u ON v.id_usuario = u.id_usuario
LEFT JOIN cliente c ON v.id_cliente = c.id_cliente
LEFT JOIN detalle_venta dv ON v.id_venta = dv.id_venta
WHERE DATE(v.fec_venta) = CURDATE()
GROUP BY v.id_venta, v.fec_venta, u.nombre, c.nombre, v.metodo_pago
ORDER BY v.fec_venta DESC;

-- Vista: Productos con stock bajo
CREATE OR REPLACE VIEW v_stock_bajo AS
SELECT 
    id_producto,
    nombre,
    precio,
    num_stock,
    stock_minimo,
    (stock_minimo - num_stock) AS deficit
FROM producto
WHERE num_stock <= stock_minimo
ORDER BY deficit DESC;

-- Vista: Resumen de cierres de caja
CREATE OR REPLACE VIEW v_cierres_resumen AS
SELECT 
    id_cierre_caja,
    DATE(fec_cierre) AS fecha,
    u.nombre AS cajero,
    saldo_inicial,
    total_ventas,
    total_efectivo,
    diferencia,
    estado_cierre
FROM cierre_caja c
LEFT JOIN usuario u ON c.id_usuario = u.id_usuario
ORDER BY fec_cierre DESC;

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================
