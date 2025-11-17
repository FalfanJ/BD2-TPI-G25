USE BD2_TPI_G25;
GO
SET NOCOUNT ON;

INSERT INTO dbo.Roles (NombreRol) VALUES
('Cliente'),
('Tecnico');
GO

INSERT INTO dbo.Ubicacion (NombreUbicacion) VALUES
('Sede Central - Piso 1'),
('Sede Central - Piso 2'),
('Deposito'),
('Sucursal Norte'),
('Home Office');
GO

INSERT INTO dbo.Marca (Nombre) VALUES
('Dell'),
('HP'),
('Lenovo'),
('Cisco'),
('Epson');
GO

INSERT INTO dbo.SLA (Nivel) VALUES
('Bajo (72 hs)'),
('Medio (24 hs)'),
('Alto (8 hs)'),
('Critico (2 hs)');
GO

INSERT INTO dbo.TiposTickets (NombreTipo) VALUES
('Incidente'),
('Requerimiento'),
('Consulta');
GO

INSERT INTO dbo.EstadosTicket (NombreEstado) VALUES
('Abierto'),
('En Progreso'),
('Pendiente Cliente'),
('Resuelto'),
('Cerrado');
GO

INSERT INTO dbo.GruposSoporte (NombreGrupo) VALUES
('Mesa de Ayuda N1'),
('Redes'),
('Infraestructura');
GO

INSERT INTO dbo.Empleado
    (Nombre, Apellido, Id_Ubicacion, Correo, Telefono, Id_Rol, PasswordHash)
VALUES
    ('Juan','Perez',1,'juan.perez@empresa.com',1111111111,1,HASHBYTES('SHA2_256','clave123')),
    ('Ana','Garcia',2,'ana.garcia@empresa.com',1222222222,1,HASHBYTES('SHA2_256','clave123')),
    ('Luis','Fernandez',4,'luis.fernandez@empresa.com',1333333333,1,HASHBYTES('SHA2_256','clave123')),
    ('Carla','Dominguez',5,'carla.dominguez@empresa.com',1444444444,1,HASHBYTES('SHA2_256','clave123')),
    ('Marcos','Ruiz',1,'marcos.ruiz@empresa.com',1555555555,2,HASHBYTES('SHA2_256','tecsoporte')),
    ('Laura','Gomez',2,'laura.gomez@empresa.com',1666666666,2,HASHBYTES('SHA2_256','tecsoporte')),
    ('Pedro','Alvarez',3,'pedro.alvarez@empresa.com',1777777777,2,HASHBYTES('SHA2_256','tecn2'));
GO

INSERT INTO dbo.EmpleadosGrupos (Id_Empleado, Id_Grupo) VALUES
(5,1),
(6,1),
(7,2),
(6,3);
GO

INSERT INTO dbo.Equipo
    (Tipo_Equipo, Id_Ubicacion, Nombre, Id_Marca, Modelo, NumeroSerie, Fecha_adquisicion, Estado)
VALUES
    (1,1,'Notebook Direccion',1,'Latitude 5400','NB-0001','2022-03-10','Operativo'),
    (1,2,'Notebook Finanzas',1,'Latitude 5410','NB-0002','2022-05-15','Operativo'),
    (2,1,'PC Escritorio Recepcion',3,'ThinkCentre M720','PC-0003','2021-11-20','Operativo'),
    (3,3,'Impresora HP Laser',2,'LaserJet M404','IMP-0004','2020-09-05','Operativo'),
    (4,2,'Router Cisco Oficina',4,'RV340','RT-0005','2019-07-01','Operativo'),
    (3,1,'Impresora Epson Color',5,'EcoTank L3150','IMP-0006','2021-01-25','Operativo');
GO

INSERT INTO dbo.EquipoEmpleado (Id_Empleado, Id_Equipo) VALUES
(1,1),
(2,2),
(3,3),
(4,6),
(5,4),
(6,5);
GO

INSERT INTO dbo.Tickets
    (Titulos, Fecha, Id_Cliente, Id_Tecnico, Id_Equipo,
     Id_TipoTicket, Id_EstadoTicket, Id_SLA, Id_GrupoAsignado, Descripcion)
VALUES
('No enciende la notebook',DATEADD(DAY,-25,GETDATE()),1,5,1,1,2,3,1,'El equipo no enciende.'),
('Pantalla azul al iniciar',DATEADD(DAY,-24,GETDATE()),2,5,2,1,5,4,1,'BSOD en arranque.'),
('Error de impresión HP',DATEADD(DAY,-23,GETDATE()),3,6,4,1,4,2,3,'Cola de impresión detenida.'),
('Mouse no responde',DATEADD(DAY,-22,GETDATE()),4,6,3,1,5,1,1,'Mouse falla.'),
('Sin conexión a Internet',DATEADD(DAY,-21,GETDATE()),1,7,5,1,1,4,2,'Sin acceso a Internet.'),
('Aplicación se cierra sola',DATEADD(DAY,-20,GETDATE()),2,5,2,2,2,2,1,'Aplicación se cierra.'),
('No puedo acceder al correo',DATEADD(DAY,-19,GETDATE()),3,6,3,1,3,1,1,'Error credenciales.'),
('Teclado deja de funcionar',DATEADD(DAY,-18,GETDATE()),4,NULL,1,1,1,1,1,'Teclado no responde.'),
('PC muy lenta',DATEADD(DAY,-17,GETDATE()),1,5,3,1,4,2,1,'PC lenta.'),
('Problema de sonido',DATEADD(DAY,-16,GETDATE()),2,6,2,1,2,1,1,'Sin audio.'),
('Actualización Windows',DATEADD(DAY,-15,GETDATE()),3,7,1,1,5,2,3,'Actualización falla.'),
('VPN no conecta',DATEADD(DAY,-14,GETDATE()),4,7,2,2,4,4,2,'VPN no conecta.'),
('No imprime en red',DATEADD(DAY,-13,GETDATE()),1,5,6,1,1,3,3,'Impresora no aparece.'),
('Error inicio sesión',DATEADD(DAY,-12,GETDATE()),2,5,1,1,2,1,1,'Inicio de sesión falla.'),
('Instalación Office',DATEADD(DAY,-11,GETDATE()),3,6,3,2,3,1,1,'Instalar Office.'),
('Cambio contraseña',DATEADD(DAY,-10,GETDATE()),4,6,2,2,4,1,1,'Cambiar contraseña.'),
('Alta nuevo usuario',DATEADD(DAY,-9,GETDATE()),1,5,5,2,1,2,1,'Crear usuario.'),
('Instalar impresora',DATEADD(DAY,-8,GETDATE()),2,6,4,2,2,2,3,'Instalar impresora.'),
('Error sistema gestión',DATEADD(DAY,-7,GETDATE()),3,5,3,1,3,4,1,'Sistema cuelga.'),
('Consulta licencia',DATEADD(DAY,-6,GETDATE()),4,NULL,1,3,5,1,1,'Consulta licencia.'),
('Monitor parpadea',DATEADD(DAY,-5,GETDATE()),1,7,3,1,1,3,3,'Monitor falla.'),
('USB no reconoce',DATEADD(DAY,-4,GETDATE()),2,5,2,1,2,2,1,'USB no reconoce.'),
('Problema proyector',DATEADD(DAY,-3,GETDATE()),3,6,5,1,3,3,2,'Proyector no detecta.'),
('Solicitud acceso remoto',DATEADD(DAY,-2,GETDATE()),4,7,2,2,4,4,2,'Acceso remoto.'),
('Restablecer red',DATEADD(DAY,-1,GETDATE()),1,5,5,1,1,4,2,'Reset red.');
GO

INSERT INTO dbo.HistorialTickets
    (Id_Ticket, FechaModificacion, Modificado_Por, Id_Estado, Descripcion)
VALUES
(1,DATEADD(DAY,-25,GETDATE()),1,1,'Ticket creado'),
(1,DATEADD(DAY,-24,GETDATE()),5,2,'En diagnóstico'),
(2,DATEADD(DAY,-24,GETDATE()),2,1,'Ticket creado'),
(2,DATEADD(DAY,-23,GETDATE()),5,2,'Analizando'),
(2,DATEADD(DAY,-22,GETDATE()),5,5,'Cerrado'),
(3,DATEADD(DAY,-23,GETDATE()),3,1,'Ticket creado'),
(3,DATEADD(DAY,-22,GETDATE()),6,2,'Revisión'),
(3,DATEADD(DAY,-21,GETDATE()),6,4,'Resuelto');
GO

INSERT INTO dbo.BaseDeConocimiento (Titulo, Solucion, Id_Autor) VALUES
('Notebook no enciende','Probar cargador, reset 30 segundos.',5),
('Error impresion HP','Reiniciar spooler y reinstalar driver.',6),
('VPN no conecta','Revisar Internet, firewall y cliente VPN.',7),
('Buenas prácticas contraseña','Cambiar periódicamente.',5);
GO

PRINT 'DATOS INSERTADOS CORRECTAMENTE';
