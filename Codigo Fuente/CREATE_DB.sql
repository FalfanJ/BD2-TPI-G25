Create Database BD2_TPI_G25
Collate Latin1_General_CI_AI
GO
USE BD2_TPI_G25
GO

CREATE TABLE Marca (
	Id_Marca INTEGER NOT NULL IDENTITY(1,1) UNIQUE,
	Nombre VARCHAR(50) NOT NULL,
	PRIMARY KEY(Id_Marca)
);
GO

CREATE TABLE Roles (
	Id_Rol INTEGER NOT NULL IDENTITY(1,1) UNIQUE,
	NombreRol VARCHAR(50) NOT NULL,
	PRIMARY KEY(Id_Rol)
);
GO

CREATE TABLE Ubicacion (
	Id_Ubicacion INTEGER NOT NULL IDENTITY(1,1) UNIQUE,
	NombreUbicacion VARCHAR(70) NOT NULL,
	PRIMARY KEY(Id_Ubicacion)
);
GO

CREATE TABLE GruposSoporte (
	Id_Grupo INTEGER NOT NULL IDENTITY(1,1) UNIQUE,
	NombreGrupo VARCHAR(50) NOT NULL,
	PRIMARY KEY(Id_Grupo)
);
GO

CREATE TABLE TiposTickets (
	Id_TipoTicket INTEGER NOT NULL IDENTITY(1,1) UNIQUE,
	NombreTipo VARCHAR(30) NOT NULL,
	PRIMARY KEY(Id_TipoTicket)
);
GO

CREATE TABLE EstadosTicket (
	Id_EstadoTicket INTEGER NOT NULL IDENTITY(1,1) UNIQUE,
	NombreEstado VARCHAR(30) NOT NULL,
	PRIMARY KEY(Id_EstadoTicket)
);
GO

CREATE TABLE SLA (
	Id_SLA INTEGER NOT NULL IDENTITY(1,1) UNIQUE,
	Nivel VARCHAR(100) NOT NULL,
	PRIMARY KEY(Id_SLA)
);
GO

CREATE TABLE Equipo (
	Id_Equipo INTEGER NOT NULL IDENTITY(1,1) UNIQUE,
	Tipo_Equipo INTEGER NOT NULL,
	Id_Ubicacion INTEGER NOT NULL,
	Nombre VARCHAR(30) NOT NULL,
	Id_Marca INTEGER NOT NULL,
	Modelo VARCHAR(30),
	NumeroSerie VARCHAR(100),
	Fecha_adquisicion DATE,
	Estado VARCHAR(100) NOT NULL,
	PRIMARY KEY(Id_Equipo),
	FOREIGN KEY (Id_Ubicacion) REFERENCES Ubicacion (Id_Ubicacion),
	FOREIGN KEY (Id_Marca) REFERENCES Marca (Id_Marca)
);
GO

CREATE TABLE Empleado (
	Id_Empleado INTEGER NOT NULL IDENTITY(1,1) UNIQUE,
	Nombre VARCHAR(70) NOT NULL,
	Apellido VARCHAR(50) NOT NULL,
	Id_Ubicacion INTEGER NOT NULL,
	Correo VARCHAR(255),
	Telefono INTEGER,
	Id_Rol INTEGER NOT NULL,
	-- CAMBIO 1: Corregido para usar HASH
	PasswordHash VARBINARY(64) NULL,
	PRIMARY KEY(Id_Empleado),
	FOREIGN KEY (Id_Ubicacion) REFERENCES Ubicacion (Id_Ubicacion),
	FOREIGN KEY (Id_Rol) REFERENCES Roles (Id_Rol)
);
GO

CREATE TABLE BaseDeConocimiento (
	Id_Articulo BIGINT NOT NULL IDENTITY(1,1) UNIQUE,
	Titulo VARCHAR(150) NOT NULL,
	Solucion VARCHAR(MAX) NOT NULL,
	Id_Autor INTEGER NOT NULL,
	PRIMARY KEY(Id_Articulo),
	FOREIGN KEY (Id_Autor) REFERENCES Empleado (Id_Empleado)
);
GO

CREATE TABLE EquipoEmpleado (
	Id_Empleado INTEGER NOT NULL,
	Id_Equipo INTEGER NOT NULL UNIQUE,
	PRIMARY KEY(Id_Empleado, Id_Equipo),
	FOREIGN KEY (Id_Empleado) REFERENCES Empleado (Id_Empleado),
	FOREIGN KEY (Id_Equipo) REFERENCES Equipo (Id_Equipo)
);
GO

CREATE TABLE EmpleadosGrupos (
	Id_Empleado INTEGER NOT NULL,
	Id_Grupo INTEGER NOT NULL,
	PRIMARY KEY(Id_Empleado, Id_Grupo),
	FOREIGN KEY (Id_Empleado) REFERENCES Empleado (Id_Empleado),
	FOREIGN KEY (Id_Grupo) REFERENCES GruposSoporte (Id_Grupo)
);
GO

CREATE TABLE Tickets (
	Id_Ticket INTEGER NOT NULL IDENTITY(1,1) UNIQUE,
	Titulos VARCHAR(100) NOT NULL,
	Fecha DATE NOT NULL,
	Id_Cliente INTEGER NOT NULL,
	Id_Tecnico INTEGER,
	Id_Equipo INTEGER NOT NULL,
	Id_TipoTicket INTEGER NOT NULL,
	Id_EstadoTicket INTEGER NOT NULL,
	Id_SLA INTEGER,
	Id_GrupoAsignado INTEGER NULL,
    -- CAMBIO 2: Agregado para guardar la descripción
	Descripcion VARCHAR(MAX) NULL,
	PRIMARY KEY(Id_Ticket),
	FOREIGN KEY (Id_Cliente) REFERENCES Empleado (Id_Empleado),
	FOREIGN KEY (Id_Tecnico) REFERENCES Empleado (Id_Empleado),
	FOREIGN KEY (Id_Equipo) REFERENCES Equipo (Id_Equipo),
	FOREIGN KEY (Id_TipoTicket) REFERENCES TiposTickets (Id_TipoTicket),
	FOREIGN KEY (Id_EstadoTicket) REFERENCES EstadosTicket (Id_EstadoTicket),
	FOREIGN KEY (Id_SLA) REFERENCES SLA (Id_SLA),
    -- CAMBIO 3: Clave foránea corregida
	FOREIGN KEY (Id_GrupoAsignado) REFERENCES GruposSoporte (Id_Grupo)
);
GO

CREATE TABLE HistorialTickets (
	Id_Historial INTEGER NOT NULL IDENTITY(1,1) UNIQUE,
	Id_Ticket INTEGER NOT NULL,
	FechaModificacion DATETIME,
	Modificado_Por INTEGER,
	Id_Estado INTEGER NOT NULL,
	Descripcion VARCHAR(MAX), -- Cambiado a MAX
	PRIMARY KEY(Id_Historial),
	FOREIGN KEY (Id_Ticket) REFERENCES Tickets (Id_Ticket),
	FOREIGN KEY (Modificado_Por) REFERENCES Empleado (Id_Empleado),
	FOREIGN KEY (Id_Estado) REFERENCES EstadosTicket (Id_EstadoTicket)
);
GO