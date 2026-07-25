-- ============================================================
-- 1. CREACIÓN DE TABLAS CATÁLOGO / MAESTRAS
-- ============================================================

CREATE TABLE Tipo (
    id_tipo SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Estado (
    id_estado SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Rol (
    id_rol SERIAL PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- ============================================================
-- 2. CREACIÓN DE TABLAS PRINCIPALES (ENTIDADES)
-- ============================================================

CREATE TABLE Ambulancia (
    id_ambulancia SERIAL PRIMARY KEY,
    patente_ambulancia VARCHAR(15) UNIQUE NOT NULL,
    num_unidad VARCHAR(20) NOT NULL,
    id_tipo INT REFERENCES Tipo(id_tipo),
    id_estado INT REFERENCES Estado(id_estado)
);

CREATE TABLE Personal (
    id_personal SERIAL PRIMARY KEY,
    dni_personal VARCHAR(15) UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    id_rol INT REFERENCES Rol(id_rol)
);

CREATE TABLE Guardia (
    id_guardia SERIAL PRIMARY KEY,
    id_personal INT REFERENCES Personal(id_personal),
    fecha_inicio TIMESTAMP NOT NULL,
    fecha_fin TIMESTAMP
);

-- ============================================================
-- 3. CREACIÓN DE TABLAS RELACIONAL
-- ============================================================

CREATE TABLE Asignacion (
    id_asignacion SERIAL PRIMARY KEY,
    id_guardia INT REFERENCES Guardia(id_guardia),
    id_ambulancia INT REFERENCES Ambulancia(id_ambulancia),
    id_chofer INT REFERENCES Personal(id_personal),
    id_enfermero INT REFERENCES Personal(id_personal),
    estado VARCHAR(30) DEFAULT 'Activa'
);

-- ============================================================
-- 4. INSERCIÓN DE DATOS DE PRUEBA 
-- ============================================================

-- A. Insertar Catálogos (Tipos de ambulancia, Estados y Roles)
INSERT INTO Tipo (nombre) VALUES 
('UTIM - Alta Complejidad'),
('UEM - Emergencias Médicas'),
('Unidad de Traslado Básica');

INSERT INTO Estado (nombre) VALUES 
('Disponible'),
('En Servicio'),
('Mantenimiento'),
('Fuera de Servicio'),
('Desinfectando');

INSERT INTO Rol (nombre_rol, descripcion) VALUES 
('Chofer', 'Conductor profesional de unidades de emergencia'),
('Enfermero', 'Atención paramédica y soporte vital'),
('Médico', 'Atención médica avanzada e intervenciones');

-- B. Insertar Flota de Ambulancias
INSERT INTO Ambulancia (patente_ambulancia, num_unidad, id_tipo, id_estado) VALUES 
('AA123CD', 'Unidad 101', 1, 1), -- UTIM - Disponible
('AB456EF', 'Unidad 102', 1, 2), -- UTIM - En Servicio
('AC789GH', 'Unidad 103', 2, 1), -- UEM - Disponible
('AD012IJ', 'Unidad 104', 3, 1), -- Traslado - Disponible
('AE345KL', 'Unidad 105', 3, 3), -- Traslado - Mantenimiento
('AF678MN', 'Unidad 106', 2, 1), -- UEM - Disponible
('AG901OP', 'Unidad 107', 2, 5), -- UEM - Desinfectando
('AH234QR', 'Unidad 108', 1, 2), -- UTIM - En Servicio
('AI567ST', 'Unidad 109', 3, 4), -- Traslado - Fuera de Servicio
('AJ890UV', 'Unidad 110', 2, 1); -- UEM - Disponible

-- C. Insertar Staff de Personal
INSERT INTO Personal (dni_personal, nombre, apellido, id_rol) VALUES 
('38123456', 'Juan', 'Pérez', 1),        -- ID 1: Chofer
('35111222', 'Carlos', 'López', 1),      -- ID 2: Chofer
('39444555', 'Roberto', 'Gómez', 1),     -- ID 3: Chofer
('40987654', 'María', 'García', 2),     -- ID 4: Enfermera
('41222333', 'Laura', 'Martínez', 2),   -- ID 5: Enfermera
('42333444', 'Sonia', 'Rodríguez', 2),  -- ID 6: Enfermera
('32555666', 'Dr. Esteban', 'Quito', 3), -- ID 7: Médico
('33666777', 'Dra. Patricia', 'Sosa', 3), -- ID 8: Médica
('37888999', 'Diego', 'Fernández', 1),   -- ID 9: Chofer
('38999000', 'Valeria', 'Suárez', 2),    -- ID 10: Enfermera
('34777888', 'Dr. Marcos', 'Benítez', 3);-- ID 11: Médico

-- D. Insertar Turnos de Guardia (últimos 7 días + turnos activos ahora)
INSERT INTO Guardia (id_personal, fecha_inicio, fecha_fin) VALUES 
-- Guardias ya finalizadas, distribuidas en la última semana
(1, CURRENT_TIMESTAMP - INTERVAL '6 days 8 hours', CURRENT_TIMESTAMP - INTERVAL '6 days 0 hours'),  -- Juan Pérez
(1, CURRENT_TIMESTAMP - INTERVAL '4 days 8 hours', CURRENT_TIMESTAMP - INTERVAL '4 days 0 hours'),  -- Juan Pérez
(1, CURRENT_TIMESTAMP - INTERVAL '2 days 8 hours', CURRENT_TIMESTAMP - INTERVAL '2 days 0 hours'),  -- Juan Pérez
(2, CURRENT_TIMESTAMP - INTERVAL '5 days 8 hours', CURRENT_TIMESTAMP - INTERVAL '5 days 0 hours'),  -- Carlos López
(2, CURRENT_TIMESTAMP - INTERVAL '3 days 8 hours', CURRENT_TIMESTAMP - INTERVAL '3 days 0 hours'),  -- Carlos López
(3, CURRENT_TIMESTAMP - INTERVAL '6 days 6 hours', CURRENT_TIMESTAMP - INTERVAL '6 days 0 hours'),  -- Roberto Gómez
(3, CURRENT_TIMESTAMP - INTERVAL '1 days 6 hours', CURRENT_TIMESTAMP - INTERVAL '1 days 0 hours'),  -- Roberto Gómez
(4, CURRENT_TIMESTAMP - INTERVAL '5 days 8 hours', CURRENT_TIMESTAMP - INTERVAL '5 days 0 hours'),  -- María García
(4, CURRENT_TIMESTAMP - INTERVAL '4 days 8 hours', CURRENT_TIMESTAMP - INTERVAL '4 days 0 hours'),  -- María García
(4, CURRENT_TIMESTAMP - INTERVAL '2 days 8 hours', CURRENT_TIMESTAMP - INTERVAL '2 days 0 hours'),  -- María García
(5, CURRENT_TIMESTAMP - INTERVAL '3 days 8 hours', CURRENT_TIMESTAMP - INTERVAL '3 days 0 hours'),  -- Laura Martínez
(6, CURRENT_TIMESTAMP - INTERVAL '6 days 6 hours', CURRENT_TIMESTAMP - INTERVAL '6 days 0 hours'),  -- Sonia Rodríguez
(6, CURRENT_TIMESTAMP - INTERVAL '2 days 6 hours', CURRENT_TIMESTAMP - INTERVAL '2 days 0 hours'),  -- Sonia Rodríguez
(7, CURRENT_TIMESTAMP - INTERVAL '4 days 10 hours', CURRENT_TIMESTAMP - INTERVAL '4 days 0 hours'), -- Dr. Esteban Quito
(8, CURRENT_TIMESTAMP - INTERVAL '3 days 10 hours', CURRENT_TIMESTAMP - INTERVAL '3 days 0 hours'), -- Dra. Patricia Sosa
(9, CURRENT_TIMESTAMP - INTERVAL '5 days 8 hours', CURRENT_TIMESTAMP - INTERVAL '5 days 0 hours'),  -- Diego Fernández
(9, CURRENT_TIMESTAMP - INTERVAL '1 days 8 hours', CURRENT_TIMESTAMP - INTERVAL '1 days 0 hours'),  -- Diego Fernández
(10, CURRENT_TIMESTAMP - INTERVAL '6 days 8 hours', CURRENT_TIMESTAMP - INTERVAL '6 days 0 hours'), -- Valeria Suárez
-- Guardias activas en este momento (fecha_fin NULL)
(1, CURRENT_TIMESTAMP - INTERVAL '4 hours', NULL),  -- ID: Juan Pérez
(2, CURRENT_TIMESTAMP - INTERVAL '4 hours', NULL),  -- ID: Carlos López
(4, CURRENT_TIMESTAMP - INTERVAL '4 hours', NULL),  -- ID: María García
(5, CURRENT_TIMESTAMP - INTERVAL '4 hours', NULL),  -- ID: Laura Martínez
(7, CURRENT_TIMESTAMP - INTERVAL '2 hours', NULL),  -- ID: Dr. Esteban Quito
(3, CURRENT_TIMESTAMP - INTERVAL '1 hours', NULL),  -- ID: Roberto Gómez
(11, CURRENT_TIMESTAMP - INTERVAL '1 hours', NULL); -- ID: Dr. Marcos Benítez

-- E. Insertar Tripulaciones Asignadas a Ambulancias
-- Nota: los IDs de guardia 19-25 corresponden a las guardias activas (fecha_fin NULL) 
-- insertadas al final del bloque anterior (19=Juan, 20=Carlos, 21=María, 
-- 22=Laura, 23=Esteban, 24=Roberto, 25=Marcos).
INSERT INTO Asignacion (id_guardia, id_ambulancia, id_chofer, id_enfermero, estado) VALUES 
(19, 1, 1, 4, 'Activa'),        -- Unidad 101 (UTIM) lista con Juan (Chofer) y María (Enfermera)
(20, 2, 2, 5, 'En Emergencia'), -- Unidad 102 (UTIM) en viaje con Carlos y Laura
(24, 3, 3, 6, 'Activa');        -- Unidad 103 (UEM) lista con Roberto y Sonia

-- Consulta de ejemplo: tripulación completa por ambulancia
SELECT 
    a.num_unidad,
    t.nombre AS tipo_ambulancia,
    e.nombre AS estado_ambulancia,
    p_ch.nombre || ' ' || p_ch.apellido AS chofer,
    p_enf.nombre || ' ' || p_enf.apellido AS enfermero,
    asig.estado AS estado_asignacion
FROM Asignacion asig
JOIN Ambulancia a ON asig.id_ambulancia = a.id_ambulancia
JOIN Tipo t ON a.id_tipo = t.id_tipo
JOIN Estado e ON a.id_estado = e.id_estado
JOIN Personal p_ch ON asig.id_chofer = p_ch.id_personal
JOIN Personal p_enf ON asig.id_enfermero = p_enf.id_personal;
