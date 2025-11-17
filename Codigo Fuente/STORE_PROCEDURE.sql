--STORE PROCEDURE
USE BD2_TPI_G25
GO

--SP CREACION DE TICKET 
CREATE PROCEDURE dbo.sp_CrearTicket (
    @Id_Cliente INT,
    @Id_Equipo INT,
    @Titulos VARCHAR(100),
    @Id_TipoTicket INT,
    @Descripcion VARCHAR(MAX) 
)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @EstadoAbiertoID INT = 1; 
    DECLARE @NuevoTicketID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Tickets (
            Titulos, Fecha, Id_Cliente, Id_Tecnico, Id_Equipo, 
            Id_TipoTicket, Id_EstadoTicket, Id_SLA, Id_GrupoAsignado,
            Descripcion 
        )
        VALUES (
            @Titulos, GETDATE(), @Id_Cliente, NULL, @Id_Equipo, 
            @Id_TipoTicket, @EstadoAbiertoID, NULL, NULL,
            @Descripcion 
        );

        SET @NuevoTicketID = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SELECT @NuevoTicketID AS NuevoTicketID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

--SP para Actualizar Estado 

CREATE PROCEDURE dbo.sp_ActualizarEstadoTicket (
    @Id_Ticket INT,
    @Id_NuevoEstado INT,
    @Id_Tecnico INT,        
    @Descripcion VARCHAR(MAX) 
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Tickets WHERE Id_Ticket = @Id_Ticket)
    BEGIN
        RAISERROR('Error: El ticket con ID %d no existe.', 16, 1, @Id_Ticket);
        RETURN; 
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.EstadosTicket WHERE Id_EstadoTicket = @Id_NuevoEstado)
    BEGIN
        RAISERROR('Error: El estado con ID %d no es válido.', 16, 1, @Id_NuevoEstado);
        RETURN;
    END
    
    IF NOT EXISTS (SELECT 1 FROM dbo.Empleado WHERE Id_Empleado = @Id_Tecnico)
    BEGIN
        RAISERROR('Error: El empleado (técnico) con ID %d no existe.', 16, 1, @Id_Tecnico);
        RETURN; 
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE dbo.Tickets
        SET 
            Id_EstadoTicket = @Id_NuevoEstado
        WHERE 
            Id_Ticket = @Id_Ticket;

        INSERT INTO dbo.HistorialTickets (
            Id_Ticket, FechaModificacion, Modificado_Por, Id_Estado, Descripcion
        )
        VALUES (
            @Id_Ticket, GETDATE(), @Id_Tecnico, @Id_NuevoEstado, @Descripcion
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

--SP ARTICULO CONOCIMIENTO 
CREATE PROCEDURE SP_CrearArticuloConocimiento(
    @Titulo VARCHAR(150),
    @Solucion VARCHAR(MAX),
    @Id_Autor INTEGER
)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM Empleado WHERE Id_Empleado = @Id_Autor)
    BEGIN
        RAISERROR('Error: el ID Autor no existe', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION
        INSERT INTO BaseDeConocimiento(
            Titulo,
            Solucion,
            Id_Autor
        )
        VALUES(
            @Titulo,
            @Solucion,
            @Id_Autor
        )
        COMMIT TRANSACTION
        PRINT 'Base de Conocimiento Actualizada'
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        RAISERROR('No a sido posible actualizar la base', 16, 1)
    END CATCH
END
GO
-- SP ASIGNAR TICKET
IF OBJECT_ID('dbo.sp_AsignarTicket', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_AsignarTicket;
GO

CREATE PROCEDURE dbo.sp_AsignarTicket
(
    @Id_Ticket        INT,
    @Id_Tecnico       INT = NULL,
    @Id_GrupoAsignado INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @Id_Tecnico IS NULL AND @Id_GrupoAsignado IS NULL
        BEGIN
            RAISERROR('Debe especificar al menos un técnico o un grupo.', 16, 1);
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Tickets WHERE Id_Ticket = @Id_Ticket)
        BEGIN
            RAISERROR('El ticket indicado no existe.', 16, 1);
            RETURN;
        END

        IF @Id_Tecnico IS NOT NULL
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Empleado WHERE Id_Empleado = @Id_Tecnico AND Id_Rol = 2)
            BEGIN
                RAISERROR('El técnico indicado no existe.', 16, 1);
                RETURN;
            END
        END

        IF @Id_GrupoAsignado IS NOT NULL
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM GruposSoporte WHERE Id_Grupo = @Id_GrupoAsignado)
            BEGIN
                RAISERROR('El grupo de soporte indicado no existe.', 16, 1);
                RETURN;
            END
        END

        BEGIN TRANSACTION;
        UPDATE Tickets
        SET Id_Tecnico       = @Id_Tecnico,
            Id_GrupoAsignado = @Id_GrupoAsignado
        WHERE Id_Ticket = @Id_Ticket;
        COMMIT TRANSACTION;
        PRINT 'Ticket asignado correctamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

--SP REGISTAR EMPLEADO 
IF OBJECT_ID('dbo.sp_RegistrarEmpleado', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.sp_RegistrarEmpleado;
END
GO

CREATE PROCEDURE dbo.sp_RegistrarEmpleado (
    @Nombre VARCHAR(70),
    @Apellido VARCHAR(50),
    @Id_Ubicacion INT,
    @Correo VARCHAR(255),
    @Telefono INT,
    @Id_Rol INT,
    @Password VARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM dbo.Empleado WHERE Correo = @Correo)
    BEGIN
        RAISERROR('Error: El correo electrónico ya está registrado.', 16, 1);
        RETURN; 
    END

    DECLARE @PasswordHash VARBINARY(64);
    SET @PasswordHash = HASHBYTES('SHA2_256', @Password);
    INSERT INTO dbo.Empleado (
        Nombre, Apellido, Id_Ubicacion, Correo, Telefono, Id_Rol, PasswordHash 
    )
    VALUES (
        @Nombre, @Apellido, @Id_Ubicacion, @Correo, @Telefono, @Id_Rol, @PasswordHash
    );

    PRINT 'Empleado registrado con éxito.';
    SELECT SCOPE_IDENTITY() AS NuevoEmpleadoID;
END
GO

--SP VALIDAR USUARIO 
CREATE PROCEDURE dbo.sp_ValidarUsuario (
    @Correo VARCHAR(255),
    @Password VARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UsuarioID INT;
    DECLARE @PasswordHashGuardado VARBINARY(64);
    
    DECLARE @PasswordInputHash VARBINARY(64);
    SET @PasswordInputHash = HASHBYTES('SHA2_256', @Password);

    SELECT 
        @UsuarioID = Id_Empleado,
        @PasswordHashGuardado = PasswordHash 
    FROM 
        dbo.Empleado
    WHERE 
        Correo = @Correo;

    IF @UsuarioID IS NULL
    BEGIN
        RAISERROR('Error: El correo electronico no se encuentra registrado.', 16, 1);
        RETURN; 
    END

    IF @PasswordHashGuardado = @PasswordInputHash
    BEGIN
        
        SELECT 
            E.Id_Empleado,
            E.Nombre,
            E.Apellido,
            E.Correo,
            R.Id_Rol,
            R.NombreRol  
        FROM 
            dbo.Empleado E
        INNER JOIN 
            dbo.Roles R ON E.Id_Rol = R.Id_Rol 
        WHERE 
            E.Id_Empleado = @UsuarioID;
        
        RETURN; 
    END
    ELSE
    BEGIN
        RAISERROR('Error: La password es incorrecta.', 16, 1);
        RETURN; 
    END
END
GO


-- SP para actualizar el SLA
IF OBJECT_ID('dbo.sp_ActualizarSLA', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ActualizarSLA;
GO

CREATE PROCEDURE dbo.sp_ActualizarSLA (
    @Id_Ticket INT,
    @Id_SLA INT
)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Tickets
    SET Id_SLA = @Id_SLA
    WHERE Id_Ticket = @Id_Ticket;
END
GO

