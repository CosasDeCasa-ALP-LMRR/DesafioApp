-- ============================================================
-- RONDA 1 — Script SQL para la base de datos "desafio"
-- ============================================================

-- La base de datos "desafio" ya fue creada por la variable
-- POSTGRES_DB en docker-compose.yml

-- Crear la tabla usuarios
CREATE TABLE usuarios (
    id               SERIAL PRIMARY KEY,
    nombre           VARCHAR(100) NOT NULL,
    email            VARCHAR(100) UNIQUE,
    fecha_registro   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar al menos 3 registros
INSERT INTO usuarios (nombre, email) VALUES
    ('Ana García',    'ana.garcia@desafio.com'),
    ('Luis Martínez', 'luis.martinez@desafio.com'),
    ('María López',   'maria.lopez@desafio.com');

-- Verificar los registros insertados
SELECT * FROM usuarios;
