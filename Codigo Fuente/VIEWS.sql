--VIEWS
USE BD2_TPI_G25
GO

CREATE VIEW dbo.v_BaseConocimientoAutores
AS
SELECT 
    bc.Id_Articulo,
    bc.Titulo,
    bc.Solucion,
    e.Nombre AS NombreAutor,
    e.Apellido AS ApellidoAutor,
    e.Correo AS CorreoAutor,
    bc.Id_Autor -- Mantenemos el Id_Autor por si se necesita
FROM 
    dbo.BaseDeConocimiento AS bc
INNER JOIN 
    dbo.Empleado AS e ON bc.Id_Autor = e.Id_Empleado
GO

CREATE VIEW dbo.V_TecnicosTKT
AS
SELECT
    em.Id_Empleado,
    em.Apellido + ' ' + em.Nombre AS 'Tecnico',
    COUNT(*) AS 'TKT Totales',
    SUM(CASE WHEN et.NombreEstado like '%Resuelto%' or et.NombreEstado like '%Cerrado%' then 1 else 0 end) AS 'TKT Completados',
    SUM(CASE WHEN et.NombreEstado like '%Abierto%' or et.NombreEstado like '%Progreso%' or et.NombreEstado like '%Pendiente%' then 1 else 0 end) AS 'TKT Pendientes',
    SUM(CASE WHEN sla.Nivel like '%Bajo%' THEN 1 ELSE 0 END) AS 'SLA Bajo',
    SUM(CASE WHEN sla.Nivel like '%Medio%' THEN 1 ELSE 0 END) AS 'SLA Medio',
    SUM(CASE WHEN sla.Nivel like '%Alto%' THEN 1 ELSE 0 END) AS 'SLA Alto',
    SUM(CASE WHEN sla.Nivel like '%Critico%' THEN 1 ELSE 0 END) AS 'SLA Critico'
FROM Tickets TKT
INNER JOIN SLA sla ON tkt.Id_SLA = sla.Id_SLA
INNER JOIN Empleado em ON tkt.Id_Tecnico = em.Id_Empleado
INNER JOIN EstadosTicket et ON tkt.Id_EstadoTicket = et.Id_EstadoTicket
GROUP BY em.Id_Empleado, em.Apellido, em.Nombre
GO

CREATE VIEW dbo.V_TecnicosTKTPendientes
AS
SELECT
    em.Id_Empleado, -- Se sigue mostrando el ID Tecnico
    em.Apellido + ' ' + em.Nombre AS 'Tecnico',
    COUNT(*) AS 'TKT Pendientes',
    SUM(CASE WHEN sla.Nivel like '%Bajo%' THEN 1 ELSE 0 END) AS 'SLA Bajo',
    SUM(CASE WHEN sla.Nivel like '%Medio%' THEN 1 ELSE 0 END) AS 'SLA Medio',
    SUM(CASE WHEN sla.Nivel like '%Alto%' THEN 1 ELSE 0 END) AS 'SLA Alto',
    SUM(CASE WHEN sla.Nivel like '%Critico%' THEN 1 ELSE 0 END) AS 'SLA Critico'
FROM Tickets TKT
INNER JOIN SLA sla ON tkt.Id_SLA=sla.Id_SLA
INNER JOIN Empleado em ON tkt.Id_Tecnico=em.Id_Empleado
WHERE tkt.Id_EstadoTicket IN(
    SELECT 
        Id_EstadoTicket
    FROM EstadosTicket
    WHERE NombreEstado IN ('Abierto', 'En Progreso', 'Pendiente Cliente')
)
GROUP BY em.Id_Empleado, em.Apellido, em.Nombre
GO

-- v_TicketsDetallados

CREATE VIEW dbo.v_TicketsDetallados
AS
SELECT 
    -- Datos del ticket
    T.Id_Ticket, T.Titulos AS Titulo, T.Fecha AS FechaCreacion,

    -- Cliente
    Cli.Id_Empleado  AS Id_Cliente, Cli.Nombre + ' ' + Cli.Apellido AS Cliente, Cli.Correo AS CorreoCliente, UbCli.NombreUbicacion AS UbicacionCliente, 

    -- Tecnico asignado
    Tec.Id_Empleado AS Id_Tecnico, Tec.Nombre + ' ' + Tec.Apellido AS Tecnico, UbTec.NombreUbicacion AS UbicacionTecnico, 

    -- Grupo de soporte asignado
    GS.Id_Grupo AS Id_GrupoAsignado, GS.NombreGrupo AS GrupoSoporte, 

    -- Equipo asociado
    Eq.Id_Equipo, Eq.Nombre AS NombreEquipo, Eq.Modelo, Eq.NumeroSerie, UbEq.NombreUbicacion AS UbicacionEquipo,

    -- Clasificacion del ticket
    TT.NombreTipo AS TipoTicket, ET.NombreEstado AS EstadoTicket, SLA.Nivel AS NivelSLA

FROM Tickets T
    -- Cliente
    INNER JOIN Empleado AS Cli ON T.Id_Cliente = Cli.Id_Empleado
    LEFT JOIN Ubicacion AS UbCli ON Cli.Id_Ubicacion = UbCli.Id_Ubicacion

    -- Tecnico
    LEFT JOIN Empleado AS Tec ON T.Id_Tecnico = Tec.Id_Empleado
    LEFT JOIN Ubicacion AS UbTec ON Tec.Id_Ubicacion = UbTec.Id_Ubicacion

    -- Grupo soporte
    LEFT JOIN GruposSoporte AS GS ON T.Id_GrupoAsignado = GS.Id_Grupo

    -- Equipo
    INNER JOIN Equipo AS Eq ON T.Id_Equipo = Eq.Id_Equipo
    LEFT  JOIN Ubicacion AS UbEq ON Eq.Id_Ubicacion = UbEq.Id_Ubicacion

    -- Tipo, estado, SLA
    INNER JOIN TiposTickets AS TT ON T.Id_TipoTicket = TT.Id_TipoTicket
    INNER JOIN EstadosTicket AS ET ON T.Id_EstadoTicket = ET.Id_EstadoTicket
    LEFT JOIN SLA AS SLA ON T.Id_SLA = SLA.Id_SLA;
GO

-- v_MiembrosGrupoSoporte

CREATE VIEW dbo.v_MiembrosGruposSoporte
AS
SELECT
    g.Id_Grupo,
    g.NombreGrupo,
    e.Id_Empleado,
    e.Nombre,
    e.Apellido,
    r.NombreRol,
    u.NombreUbicacion,
    e.Correo,
    e.Telefono
FROM EmpleadosGrupos eg
    INNER JOIN Empleado e ON eg.Id_Empleado = e.Id_Empleado
    INNER JOIN GruposSoporte g ON eg.Id_Grupo = g.Id_Grupo
    INNER JOIN Roles r ON e.Id_Rol = r.Id_Rol
    INNER JOIN Ubicacion u ON e.Id_Ubicacion = u.Id_Ubicacion;
GO

CREATE VIEW dbo.InventarioEquipos 
AS
SELECT
    e.Id_Equipo,
    e.Tipo_Equipo,
    u.NombreUbicacion,
    e.Nombre,
    m.Nombre AS 'Marca',
    e.Modelo,
    e.NumeroSerie,
    e.Fecha_adquisicion,
    e.Estado
FROM Equipo E
LEFT JOIN Ubicacion U ON e.Id_Ubicacion = u.Id_Ubicacion
LEFT JOIN Marca M ON e.Id_Marca = m.Id_Marca 
GO

