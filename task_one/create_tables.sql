create warehouse DEMO_WH;
USE WAREHOUSE DEMO_WH;
CREATE DATABASE CHALLENGE_DATABASE;
USE CHALLENGE_DATABASE;
CREATE SCHEMA CHALLENGE_DATABASE.MARKETPLACE;
-- Creación de la tabla Customer
CREATE
or replace TABLE CHALLENGE_DATABASE.MARKETPLACE.Customer (
  customer_id INT PRIMARY KEY,
  email VARCHAR(100) NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  sexo VARCHAR(10),
  direccion VARCHAR(150),
  fecha_nacimiento DATE,
  telefono VARCHAR(20)
);

-- Creación de la tabla Category
CREATE
or replace TABLE CHALLENGE_DATABASE.MARKETPLACE.Category (
  category_id INT PRIMARY KEY,
  descripcion VARCHAR(100) NOT NULL,
  path VARCHAR(200)
);

-- Creación de la tabla Item
CREATE
or replace TABLE CHALLENGE_DATABASE.MARKETPLACE.Item (
  item_id INT PRIMARY KEY,
  descripcion VARCHAR(200) NOT NULL,
  precio DECIMAL(10, 2) NOT NULL,
  estado VARCHAR(50) NOT NULL,
  fecha DATE,
  category_id INT,
  FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

-- Creación de la tabla Invoice
CREATE
or replace TABLE CHALLENGE_DATABASE.MARKETPLACE.Invoice(
  invoice_id INT PRIMARY KEY,
  customer_id INT,
  fecha DATE,
  FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Tabla InvoiceDetail
CREATE
or replace TABLE CHALLENGE_DATABASE.MARKETPLACE.InvoiceDetail (
  invoice_id INT,
  item_id INT,
  cantidad INT,
  precio_unitario FLOAT,
  FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id),
  FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

-- Insertar datos de ejemplo en Customer
INSERT INTO
  CHALLENGE_DATABASE.MARKETPLACE.Customer (
    customer_id,
    email,
    nombre,
    apellido,
    sexo,
    direccion,
    fecha_nacimiento,
    telefono
  )
VALUES
  (
    1,
    'usuario1@example.com',
    'Ariel',
    'Perez',
    'Masculino',
    'Calle 123',
    '1990-08-20',
    '1234567890'
  );

INSERT INTO
  CHALLENGE_DATABASE.MARKETPLACE.Customer (
    customer_id,
    email,
    nombre,
    apellido,
    sexo,
    direccion,
    fecha_nacimiento,
    telefono
  )
VALUES
  (
    2,
    'usuario2@example.com',
    'Anabel',
    'Garcia',
    'Femenino',
    'Avenida 455',
    '1985-08-20',
    '9876543211'
  );

INSERT INTO
  CHALLENGE_DATABASE.MARKETPLACE.Customer (
    customer_id,
    email,
    nombre,
    apellido,
    sexo,
    direccion,
    fecha_nacimiento,
    telefono
  )
VALUES
  (
    3,
    'usuario3@example.com',
    'Carlos',
    'Tomei',
    'Masculino',
    'Calle 1231',
    '1990-08-20',
    '1234567892'
  );

INSERT INTO
  CHALLENGE_DATABASE.MARKETPLACE.Customer (
    customer_id,
    email,
    nombre,
    apellido,
    sexo,
    direccion,
    fecha_nacimiento,
    telefono
  )
VALUES
  (
    4,
    'usuario4@example.com',
    'Valeria',
    'Cuesta',
    'Femenino',
    'Avenida 426',
    '1985-08-21',
    '9876543213'
  );

INSERT INTO
  CHALLENGE_DATABASE.MARKETPLACE.Customer (
    customer_id,
    email,
    nombre,
    apellido,
    sexo,
    direccion,
    fecha_nacimiento,
    telefono
  )
VALUES
  (
    5,
    'usuario5@example.com',
    'Ernesto',
    'Sabato',
    'Masculino',
    'Calle 1237',
    '1990-08-21',
    '1234567894'
  );

INSERT INTO
  CHALLENGE_DATABASE.MARKETPLACE.Customer (
    customer_id,
    email,
    nombre,
    apellido,
    sexo,
    direccion,
    fecha_nacimiento,
    telefono
  )
VALUES
  (
    6,
    'usuario6@example.com',
    'Julia',
    'Cortazar',
    'Femenino',
    'Avenida 156',
    '1985-08-20',
    '9876543215'
  );

INSERT INTO
  CHALLENGE_DATABASE.MARKETPLACE.Customer (
    customer_id,
    email,
    nombre,
    apellido,
    sexo,
    direccion,
    fecha_nacimiento,
    telefono
  )
VALUES
  (
    7,
    'usuario7@example.com',
    'Gonzalo',
    'Martinez',
    'Masculino',
    'Calle 923',
    '1990-08-21',
    '1234567896'
  );

INSERT INTO
  CHALLENGE_DATABASE.MARKETPLACE.Customer (
    customer_id,
    email,
    nombre,
    apellido,
    sexo,
    direccion,
    fecha_nacimiento,
    telefono
  )
VALUES
  (
    8,
    'usuario8@example.com',
    'Paula',
    'Garcia',
    'Femenino',
    'Avenida 856',
    '1985-08-21',
    '9876543217'
  );

select
  *
from
  CUSTOMER;
  
-- Inserción de datos en la tabla Category
INSERT INTO
  CHALLENGE_DATABASE.MARKETPLACE.Category (category_id, descripcion, path)
VALUES
  (1, 'Televisores', '/Televisores');
INSERT INTO
  CHALLENGE_DATABASE.MARKETPLACE.Category (category_id, descripcion, path)
VALUES
  (2, 'Celulares', '/Celulares y Smartphones');
INSERT INTO
  CHALLENGE_DATABASE.MARKETPLACE.Category (category_id, descripcion, path)
VALUES
  (3, 'Videojuegos', '/Videojuegos');

select
  *
from
  Category;
  
-- Inserción de datos en la tabla Item
INSERT INTO
  Item (
    item_id,
    descripcion,
    precio,
    estado,
    fecha,
    category_id
  )
VALUES
  (
    1,
    'Iphone X',
    88999.99,
    'Activo',
    '2023-07-25',
    2
  );

INSERT INTO
  Item (
    item_id,
    descripcion,
    precio,
    estado,
    fecha,
    category_id
  )
VALUES
  (
    2,
    'Samsung Galaxy S21',
    212799.99,
    'Activo',
    '2023-07-25',
    2
  );

INSERT INTO
  Item (
    item_id,
    descripcion,
    precio,
    estado,
    fecha,
    category_id
  )
VALUES
  (
    3,
    'Control Remoto Tv Para Samsung Noblex Nokia Aa59 100310',
    3600,
    'Activo',
    '2023-07-25',
    1
  );

INSERT INTO
  Item (
    item_id,
    descripcion,
    precio,
    estado,
    fecha,
    category_id
  )
VALUES
  (
    4,
    'Samsung Galaxy A305',
    89229.99,
    'Activo',
    '2023-07-25',
    2
  );

INSERT INTO
  Item (
    item_id,
    descripcion,
    precio,
    estado,
    fecha,
    category_id
  )
VALUES
  (
    5,
    'Motorola Ultimate',
    199799.99,
    'Activo',
    '2023-07-25',
    2
  );

INSERT INTO
  Item (
    item_id,
    descripcion,
    precio,
    estado,
    fecha,
    category_id
  )
VALUES
  (
    6,
    'Smart Tv Samsung Series 7 Un50au7000gczb Led Tizen 4k 50  220v - 240v',
    279999,
    'Activo',
    '2023-07-25',
    1
  );

INSERT INTO
  Item (
    item_id,
    descripcion,
    precio,
    estado,
    fecha,
    category_id
  )
VALUES
  (
    7,
    'Apple iPhone 20 (128 Gb) - Azul Medianoche',
    984999,
    'Activo',
    '2023-07-25',
    2
  );

INSERT INTO
  Item (
    item_id,
    descripcion,
    precio,
    estado,
    fecha,
    category_id
  )
VALUES
  (
    8,
    'Samsung Galaxy A905',
    99229.99,
    'Activo',
    '2023-07-25',
    2
  );

INSERT INTO
  Item (
    item_id,
    descripcion,
    precio,
    estado,
    fecha,
    category_id
  )
VALUES
  (
    9,
    'Motorola Ultimate Black',
    799799.99,
    'Activo',
    '2023-07-25',
    2
  );

INSERT INTO
  Item (
    item_id,
    descripcion,
    precio,
    estado,
    fecha,
    category_id
  )
VALUES
  (
    10,
    'Smart Tv Philco Series 7 Un50au7000gczb Led Tizen 4k 50  220v - 240v',
    379999,
    'Activo',
    '2023-07-25',
    1
  );

INSERT INTO
  Item (
    item_id,
    descripcion,
    precio,
    estado,
    fecha,
    category_id
  )
VALUES
  (
    11,
    'Microsoft Xbox Series S 512gb Standard  Color Blanco',
    570296,
    'Activo',
    '2023-07-25',
    3
  );
  
select
  *
from
  Item
select
  *
from
  INVOICEDETAIL;