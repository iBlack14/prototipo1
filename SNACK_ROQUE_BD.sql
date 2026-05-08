CREATE DATABASE db_pos;
USE db_pos;

-- =====================================
-- TABLA ROL
-- =====================================
CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT,
    nom_rol VARCHAR(50) NOT NULL,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    PRIMARY KEY (id_rol)
);

-- =====================================
-- TABLA USUARIO
-- =====================================
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT,
    id_rol INT NOT NULL,
    nom_usuario VARCHAR(100) NOT NULL,
    user_login VARCHAR(50) UNIQUE,
    val_password VARCHAR(255) NOT NULL,
    val_email VARCHAR(100) UNIQUE,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fec_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario),
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
);

-- =====================================
-- CLIENTE
-- =====================================
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT,
    nom_cliente VARCHAR(100),
    num_documento VARCHAR(20),
    num_telefono VARCHAR(20),
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    PRIMARY KEY (id_cliente)
);

-- =====================================
-- PROVEEDOR
-- =====================================
CREATE TABLE proveedor (
    id_proveedor INT AUTO_INCREMENT,
    nom_proveedor VARCHAR(100),
    num_telefono VARCHAR(20),
    desc_direccion VARCHAR(150),
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    PRIMARY KEY (id_proveedor)
);

-- =====================================
-- CATEGORIA
-- =====================================
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT,
    nom_categoria VARCHAR(100),
    desc_categoria VARCHAR(150),
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    PRIMARY KEY (id_categoria)
);

-- =====================================
-- PRODUCTO
-- =====================================
CREATE TABLE producto (
    id_producto INT AUTO_INCREMENT,
    id_categoria INT,
    nom_producto VARCHAR(100),
    tot_precio DECIMAL(10,2),
    num_stock INT DEFAULT 0,
    num_stock_minimo INT DEFAULT 5,
    estado VARCHAR(20) DEFAULT 'DISPONIBLE',
    PRIMARY KEY (id_producto),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

-- =====================================
-- METODO PAGO
-- =====================================
CREATE TABLE metodo_pago (
    id_metodo_pago INT AUTO_INCREMENT,
    nom_metodo VARCHAR(50),
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    PRIMARY KEY (id_metodo_pago)
);

INSERT INTO metodo_pago (nom_metodo, estado)
VALUES
('EFECTIVO','ACTIVO'),
('YAPE','ACTIVO'),
('PLIN','ACTIVO'),
('TRANSFERENCIA','ACTIVO'),
('TARJETA_DEBITO','ACTIVO'),
('TARJETA_CREDITO','ACTIVO');

-- =====================================
-- VENTA
-- =====================================
CREATE TABLE venta (
    id_venta INT AUTO_INCREMENT,
    id_usuario INT,
    id_cliente INT,
    id_metodo_pago INT,
    fec_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    tot_pago DECIMAL(10,2),
    estado VARCHAR(20) DEFAULT 'COMPLETADA',
    PRIMARY KEY (id_venta),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago(id_metodo_pago)
);

-- =====================================
-- DETALLE VENTA
-- =====================================
CREATE TABLE detalle_venta (
    id_detalle_venta INT AUTO_INCREMENT,
    id_venta INT,
    id_producto INT,
    num_cantidad INT,
    tot_precio_unitario DECIMAL(10,2),
    tot_subtotal DECIMAL(10,2),
    PRIMARY KEY (id_detalle_venta),
    FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- =====================================
-- COMPRA
-- =====================================
CREATE TABLE compra (
    id_compra INT AUTO_INCREMENT,
    id_usuario INT,
    id_proveedor INT,
    fec_compra DATETIME DEFAULT CURRENT_TIMESTAMP,
    tot_compra DECIMAL(10,2),
    estado VARCHAR(20) DEFAULT 'COMPLETADA',
    PRIMARY KEY (id_compra),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor)
);

-- =====================================
-- DETALLE COMPRA
-- =====================================
CREATE TABLE detalle_compra (
    id_detalle_compra INT AUTO_INCREMENT,
    id_compra INT,
    id_producto INT,
    num_cantidad INT,
    tot_precio_compra DECIMAL(10,2),
    tot_subtotal DECIMAL(10,2),
    PRIMARY KEY (id_detalle_compra),
    FOREIGN KEY (id_compra) REFERENCES compra(id_compra),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- =====================================
-- MOVIMIENTO STOCK
-- =====================================
CREATE TABLE movimiento_stock (
    id_movimiento INT AUTO_INCREMENT,
    id_producto INT,
    id_usuario INT,
    id_venta INT NULL,
    id_compra INT NULL,
    tipo_movimiento VARCHAR(20),
    num_cantidad INT,
    fec_movimiento DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_movimiento),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
    FOREIGN KEY (id_compra) REFERENCES compra(id_compra)
);

-- =====================================
-- DEVOLUCION
-- =====================================
CREATE TABLE devolucion (
    id_devolucion INT AUTO_INCREMENT,
    id_venta INT,
    tot_devolucion DECIMAL(10,2),
    motivo VARCHAR(150),
    fec_devolucion DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_devolucion),
    FOREIGN KEY (id_venta) REFERENCES venta(id_venta)
);

-- =====================================
-- CIERRE CAJA
-- =====================================
CREATE TABLE cierre_caja (
    id_cierre_caja INT AUTO_INCREMENT,
    id_usuario INT,
    fec_apertura DATETIME,
    fec_cierre DATETIME,
    tot_inicial DECIMAL(10,2),
    tot_ventas DECIMAL(10,2),
    tot_yape DECIMAL(10,2),
    tot_plin DECIMAL(10,2),
    tot_transferencia DECIMAL(10,2),
    tot_tarjeta DECIMAL(10,2),
    tot_efectivo DECIMAL(10,2),
    tot_diferencia DECIMAL(10,2),
    estado VARCHAR(20),
    PRIMARY KEY (id_cierre_caja),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- =====================================
-- AUDITORIA
-- =====================================
CREATE TABLE auditoria (
    id_auditoria INT AUTO_INCREMENT,
    id_usuario INT,
    nom_tabla VARCHAR(50),
    accion VARCHAR(50),
    fec_evento DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_auditoria),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);