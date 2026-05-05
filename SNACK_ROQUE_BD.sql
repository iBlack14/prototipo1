CREATE DATABASE SISTEMA_VENTAS;
USE SISTEMA_VENTAS;

-- =====================
-- TABLA ROL
-- =====================
CREATE TABLE rol (
    id_rol INT PRIMARY KEY,
    nombre VARCHAR(50)
);

-- =====================
-- TABLA USUARIO
-- =====================
CREATE TABLE usuario (
    id_usuario INT PRIMARY KEY,
    id_rol INT,
    nombre VARCHAR(50),
    usuario_login VARCHAR(50),
    clave VARCHAR(100),
    email VARCHAR(100),
    estado VARCHAR(20),
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
);

-- =====================
-- TABLA CLIENTE
-- =====================
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(50)
);

-- =====================
-- TABLA CATEGORIA
-- =====================
CREATE TABLE categoria (
    id_categoria INT PRIMARY KEY,
    nombre VARCHAR(50),
    desc_categoria VARCHAR(100)
);

-- =====================
-- TABLA PRODUCTO
-- =====================
CREATE TABLE producto (
    id_producto INT PRIMARY KEY,
    id_categoria INT,
    nombre VARCHAR(50),
    precio DECIMAL(10,2),
    num_stock INT,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

-- =====================
-- TABLA PROVEEDOR
-- =====================
CREATE TABLE proveedor (
    id_proveedor INT PRIMARY KEY,
    nombre VARCHAR(50),
    num_telefono VARCHAR(15),
    desc_direccion VARCHAR(100)
);

-- =====================
-- TABLA CIERRE_CAJA
-- =====================
CREATE TABLE cierre_caja (
    id_cierre_caja INT PRIMARY KEY,
    id_usuario INT,
    fec_apertura DATETIME,
    fec_cierre DATETIME,
    saldo_inicial DECIMAL(10,2),
    total_ventas DECIMAL(10,2),
    total_devoluciones DECIMAL(10,2),
    total_efectivo DECIMAL(10,2),
    diferencia DECIMAL(10,2),
    estado_cierre VARCHAR(20),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- =====================
-- TABLA VENTA
-- =====================
CREATE TABLE venta (
    id_venta INT PRIMARY KEY,
    id_usuario INT,
    id_cliente INT,
    id_cierre_caja INT,
    fec_venta DATETIME,
    metodo_pago VARCHAR(30),
    tot_pago DECIMAL(10,2),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_cierre_caja) REFERENCES cierre_caja(id_cierre_caja)
);

-- =====================
-- TABLA DETALLE_VENTA
-- =====================
CREATE TABLE detalle_venta (
    id_detalle_venta INT PRIMARY KEY,
    id_venta INT,
    id_producto INT,
    num_cantidad INT,
    precio_unitario DECIMAL(10,2),
    FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- =====================
-- TABLA COMPRA
-- =====================
CREATE TABLE compra (
    id_compra INT PRIMARY KEY,
    id_proveedor INT,
    id_usuario INT,
    fec_compra DATETIME,
    tot_compra DECIMAL(10,2),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- =====================
-- TABLA DETALLE_COMPRA
-- =====================
CREATE TABLE detalle_compra (
    id_detalle_compra INT PRIMARY KEY,
    id_compra INT,
    id_producto INT,
    num_cantidad INT,
    precio_compra DECIMAL(10,2),
    FOREIGN KEY (id_compra) REFERENCES compra(id_compra),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);